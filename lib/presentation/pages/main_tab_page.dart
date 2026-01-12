import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../injection/locator.dart';
import '../controllers/home_controller.dart';
import '../controllers/main_tab_controller.dart';
import '../controllers/message_controller.dart';
import '../controllers/mine_controller.dart';
import 'home/home_page.dart';
import 'message/message_page.dart';
import 'mine/mine_page.dart';

/// Main tab navigation page with bottom navigation bar
class MainTabPage extends StatelessWidget {
  const MainTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controllers with dependencies
    final mainTabController = Get.put(MainTabController());
    
    // Initialize page controllers
    Get.lazyPut(() => HomeController(getIt()));
    Get.lazyPut(() => MessageController(getIt(), getIt(), getIt()));
    Get.lazyPut(() => MineController(getIt(), getIt()));

    return Obx(() {
      return Scaffold(
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: _buildCurrentPage(mainTabController.currentIndex),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(
          context,
          mainTabController,
        ),
      );
    });
  }

  /// Build the current page based on selected tab
  Widget _buildCurrentPage(int index) {
    switch (index) {
      case 0:
        return const HomePage(key: ValueKey('home'));
      case 1:
        return const MessagePage(key: ValueKey('message'));
      case 2:
        return const MinePage(key: ValueKey('mine'));
      default:
        return const HomePage(key: ValueKey('home'));
    }
  }

  /// Build bottom navigation bar
  Widget _buildBottomNavigationBar(
    BuildContext context,
    MainTabController controller,
  ) {
    return Obx(() {
      return BottomNavigationBar(
        currentIndex: controller.currentIndex,
        onTap: controller.changeTab,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _buildMessageIcon(controller),
            activeIcon: _buildMessageIcon(controller, isActive: true),
            label: 'Message',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Mine',
          ),
        ],
      );
    });
  }

  /// Build message icon with unread badge
  Widget _buildMessageIcon(MainTabController controller, {bool isActive = false}) {
    final unreadCount = controller.unreadCount;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          isActive ? Icons.message : Icons.message_outlined,
        ),
        if (unreadCount > 0)
          Positioned(
            right: -8,
            top: -4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                ),
              ),
              constraints: const BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              child: Center(
                child: Text(
                  unreadCount > 99 ? '99+' : unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
