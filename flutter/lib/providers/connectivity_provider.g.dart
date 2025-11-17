// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$connectivityControllerHash() =>
    r'8b0535d9304e67893afe6c53c96ce49a78f8a483';

/// Connectivity provider for monitoring network status
///
/// Copied from [ConnectivityController].
@ProviderFor(ConnectivityController)
final connectivityControllerProvider = AutoDisposeNotifierProvider<
    ConnectivityController, ConnectivityState>.internal(
  ConnectivityController.new,
  name: r'connectivityControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$connectivityControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ConnectivityController = AutoDisposeNotifier<ConnectivityState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
