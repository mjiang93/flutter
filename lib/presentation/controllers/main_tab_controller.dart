import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'message_controller.dart';

/// Controller for managing main tab navigation
class MainTabController extends GetxController {
  // Current tab index
  final _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;

  // Scroll controllers for each tab (for double-tap to scroll to top)
  final Map<int, ScrollController> _scrollControllers = {};

  // Last tap time for double-tap detection
  final Map<int, DateTime> _lastTapTimes = {};

  @override
  void onInit() {
    super.onInit();
    // Initialize scroll controllers for each tab
    for (int i = 0; i < 3; i++) {
      _scrollControllers[i] = ScrollController();
    }
  }

  /// Change tab with animation
  void changeTab(int index) {
    if (_currentIndex.value == index) {
      // Double tap on same tab - scroll to top
      _handleDoubleTap(index);
    } else {
      // Switch to different tab
      _currentIndex.value = index;
    }
  }

  /// Handle double tap to scroll to top
  void _handleDoubleTap(int index) {
    final now = DateTime.now();
    final lastTap = _lastTapTimes[index];

    if (lastTap != null && now.difference(lastTap).inMilliseconds < 500) {
      // Double tap detected - scroll to top
      final scrollController = _scrollControllers[index];
      if (scrollController != null && scrollController.hasClients) {
        scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }

    _lastTapTimes[index] = now;
  }

  /// Get scroll controller for a specific tab
  ScrollController? getScrollController(int index) {
    return _scrollControllers[index];
  }

  /// Get unread message count for badge display
  int get unreadCount {
    try {
      final messageController = Get.find<MessageController>();
      return messageController.unreadCount.value;
    } catch (e) {
      return 0;
    }
  }

  @override
  void onClose() {
    // Dispose all scroll controllers
    for (final controller in _scrollControllers.values) {
      controller.dispose();
    }
    super.onClose();
  }
}
