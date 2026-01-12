import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../pages/home/home_page.dart';
import '../pages/message/message_page.dart';
import '../pages/message/message_detail_page.dart';
import '../pages/mine/mine_page.dart';
import '../pages/mine/setting_page.dart';
import '../pages/mine/theme_setting_page.dart';
import '../pages/mine/language_setting_page.dart';
import 'auth_guard.dart';

part 'app_router.gr.dart';

/// Application router configuration
/// 
/// Defines all routes with type-safe navigation using AutoRoute
@AutoRouterConfig(
  replaceInRouteName: 'Page,Route',
)
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    // Main tabs
    AutoRoute(
      page: HomeRoute.page,
      initial: true,
      path: '/home',
    ),
    AutoRoute(
      page: MessageRoute.page,
      path: '/message',
      guards: [AuthGuard()],
    ),
    AutoRoute(
      page: MessageDetailRoute.page,
      path: '/message/:id',
      guards: [AuthGuard()],
    ),
    AutoRoute(
      page: MineRoute.page,
      path: '/mine',
      guards: [AuthGuard()],
    ),
    
    // Settings
    AutoRoute(
      page: SettingRoute.page,
      path: '/setting',
      guards: [AuthGuard()],
    ),
    AutoRoute(
      page: ThemeSettingRoute.page,
      path: '/theme-setting',
    ),
    AutoRoute(
      page: LanguageSettingRoute.page,
      path: '/language-setting',
    ),
  ];
}
