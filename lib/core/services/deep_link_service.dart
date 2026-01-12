import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../utils/log_util.dart';
import '../../core/constants/route_names.dart';

/// Service for handling deep links and universal links
class DeepLinkService {
  static const MethodChannel _channel = MethodChannel('deep_link_channel');
  
  /// Stream controller for deep link events
  final _deepLinkController = StreamController<Uri>.broadcast();
  
  /// Stream of deep link URIs
  Stream<Uri> get deepLinkStream => _deepLinkController.stream;
  
  /// Initialize deep link handling
  Future<void> initialize() async {
    // Handle initial deep link (app opened from terminated state)
    try {
      final String? initialLink = await _channel.invokeMethod('getInitialLink');
      if (initialLink != null) {
        _handleDeepLink(Uri.parse(initialLink));
      }
    } on PlatformException catch (e) {
      LogUtil.e('Failed to get initial link', e);
    }
    
    // Listen for deep links while app is running
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onDeepLink') {
        final String? link = call.arguments as String?;
        if (link != null) {
          _handleDeepLink(Uri.parse(link));
        }
      }
    });
  }
  
  /// Handle deep link navigation
  void _handleDeepLink(Uri uri) {
    LogUtil.i('Deep link received: $uri');
    _deepLinkController.add(uri);
    
    // Parse and navigate based on the URI
    final path = uri.path;
    final queryParams = uri.queryParameters;
    
    if (path.startsWith('/home')) {
      Get.toNamed(RouteNames.home);
    } else if (path.startsWith('/message')) {
      final messageId = queryParams['id'];
      if (messageId != null) {
        Get.toNamed(RouteNames.messageDetail, arguments: {'id': messageId});
      } else {
        Get.toNamed(RouteNames.message);
      }
    } else if (path.startsWith('/mine')) {
      Get.toNamed(RouteNames.mine);
    } else if (path.startsWith('/settings')) {
      Get.toNamed(RouteNames.setting);
    } else {
      // Default to home if path is not recognized
      LogUtil.w('Unrecognized deep link path: $path');
      Get.toNamed(RouteNames.home);
    }
  }
  
  /// Dispose resources
  void dispose() {
    _deepLinkController.close();
  }
}
