import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/log_util.dart';
import '../../data/datasources/remote/services/request_cache_service.dart';

/// Controller for monitoring network connectivity status
/// 
/// Provides real-time network status updates and shows toast notifications
/// when network status changes. Also handles retrying cached requests when
/// network is restored.
class NetworkController extends GetxController {
  final RequestCacheService? _requestCacheService;

  final _isConnected = true.obs;
  final _connectionType = ConnectivityResult.wifi.obs;

  bool get isConnected => _isConnected.value;
  ConnectivityResult get connectionType => _connectionType.value;

  late StreamSubscription<ConnectivityResult> _subscription;

  NetworkController({RequestCacheService? requestCacheService})
      : _requestCacheService = requestCacheService;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen(_updateConnectionStatus);
  }

  /// Initialize connectivity status
  Future<void> _initConnectivity() async {
    try {
      final result = await Connectivity().checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      LogUtil.e('Failed to check connectivity', e);
    }
  }

  /// Update connection status and show toast notification
  void _updateConnectionStatus(ConnectivityResult result) {
    final wasConnected = _isConnected.value;
    _isConnected.value = result != ConnectivityResult.none;
    _connectionType.value = result;

    // Show toast on status change
    if (wasConnected && !_isConnected.value) {
      Get.snackbar(
        'Network',
        'Network connection lost',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(8),
      );
    } else if (!wasConnected && _isConnected.value) {
      Get.snackbar(
        'Network',
        'Network connection restored',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(8),
      );

      // Retry cached requests when network is restored
      _retryCachedRequests();
    }

    LogUtil.i('Network status changed: ${result.name}');
  }

  /// Retry all cached requests when network is restored
  Future<void> _retryCachedRequests() async {
    if (_requestCacheService == null) return;

    try {
      final count = await _requestCacheService!.getCachedRequestCount();
      if (count > 0) {
        LogUtil.i('Found $count cached requests to retry');
        final successCount = await _requestCacheService!.retryAllCachedRequests();
        if (successCount > 0) {
          Get.snackbar(
            'Network',
            'Successfully retried $successCount cached requests',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.blue,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
            margin: const EdgeInsets.all(8),
          );
        }
      }
    } catch (e) {
      LogUtil.e('Failed to retry cached requests', e);
    }
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
}
