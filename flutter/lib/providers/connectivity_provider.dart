import 'package:connectivity_plus/connectivity_plus.dart' as connectivity_plus;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_provider.g.dart';
part 'connectivity_provider.freezed.dart';

/// Connectivity state
@freezed
class ConnectivityState with _$ConnectivityState {
  const factory ConnectivityState({
    @Default(true) bool isConnected,
    @Default(connectivity_plus.ConnectivityResult.wifi) connectivity_plus.ConnectivityResult connectionType,
  }) = _ConnectivityState;
}

/// Connectivity provider for monitoring network status
@riverpod
class ConnectivityController extends _$ConnectivityController {
  late final connectivity_plus.Connectivity _connectivity;

  @override
  ConnectivityState build() {
    _connectivity = connectivity_plus.Connectivity();
    return const ConnectivityState();
  }

  /// Initialize connectivity monitoring
  Future<void> initialize() async {
    // Check initial connectivity
    final result = await _connectivity.checkConnectivity();
    _updateConnectivity(result);

    // Listen for connectivity changes
    _connectivity.onConnectivityChanged.listen((result) {
      _updateConnectivity(result);
    });
  }

  /// Update connectivity state
  void _updateConnectivity(connectivity_plus.ConnectivityResult result) {
    final isConnected = result != connectivity_plus.ConnectivityResult.none;
    state = ConnectivityState(
      isConnected: isConnected,
      connectionType: result,
    );
  }

  /// Check if device is currently connected
  bool get isConnected => state.isConnected;

  /// Get current connection type
  connectivity_plus.ConnectivityResult get connectionType => state.connectionType;
}