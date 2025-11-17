import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

final offlineSyncProvider = StateNotifierProvider<OfflineSyncNotifier, OfflineSyncState>((ref) {
  return OfflineSyncNotifier(
    apiService: ref.watch(apiServiceProvider),
  );
});

class OfflineSyncState {
  final bool isSyncing;
  final int pendingItems;
  final String? lastSyncTime;
  final String? error;

  OfflineSyncState({
    this.isSyncing = false,
    this.pendingItems = 0,
    this.lastSyncTime,
    this.error,
  });

  OfflineSyncState copyWith({
    bool? isSyncing,
    int? pendingItems,
    String? lastSyncTime,
    String? error,
  }) {
    return OfflineSyncState(
      isSyncing: isSyncing ?? this.isSyncing,
      pendingItems: pendingItems ?? this.pendingItems,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      error: error ?? this.error,
    );
  }
}

class OfflineSyncNotifier extends StateNotifier<OfflineSyncState> {
  final ApiService _apiService;
  Timer? _syncTimer;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  OfflineSyncNotifier({
    required ApiService apiService,
  }) : _apiService = apiService,
       super(OfflineSyncState()) {
    _initialize();
  }

  void _initialize() async {
    // Load initial state
    await _loadPendingItems();
    
    // Set up connectivity monitoring
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        // Network restored, attempt sync
        syncPendingItems();
      }
    });

    // Set up periodic sync
    _syncTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      syncPendingItems();
    });
  }

  Future<void> _loadPendingItems() async {
    try {
      final queue = StorageService.getOfflineQueue();
      state = state.copyWith(pendingItems: queue.length);
    } catch (e) {
      state = state.copyWith(error: 'Failed to load pending items');
    }
  }

  Future<void> syncPendingItems() async {
    if (state.isSyncing) return;

    state = state.copyWith(isSyncing: true, error: null);

    try {
      // Get offline queue
      final queue = StorageService.getOfflineQueue();
      
      if (queue.isEmpty) {
        state = state.copyWith(
          isSyncing: false,
          pendingItems: 0,
          lastSyncTime: DateTime.now().toIso8601String(),
        );
        return;
      }

      // Check network connectivity
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        state = state.copyWith(
          isSyncing: false,
          error: 'No internet connection',
        );
        return;
      }

      // Sync with server
      await _apiService.syncOfflineQueue(queue);
      
      // Clear successfully synced items
      await StorageService.clearOfflineQueue();
      
      state = state.copyWith(
        isSyncing: false,
        pendingItems: 0,
        lastSyncTime: DateTime.now().toIso8601String(),
        error: null,
      );

    } catch (e) {
      state = state.copyWith(
        isSyncing: false,
        error: 'Sync failed: ${e.toString()}',
      );
    }
  }

  Future<void> addToQueue(Map<String, dynamic> item) async {
    try {
      await StorageService.addToOfflineQueue(item);
      await _loadPendingItems();
      
      // Attempt immediate sync if connected
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        syncPendingItems();
      }
    } catch (e) {
      state = state.copyWith(error: 'Failed to add to queue: ${e.toString()}');
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}