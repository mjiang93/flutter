/// Route name constants following pattern: module_page
/// 
/// Used for type-safe navigation with AutoRoute
class RouteNames {
  RouteNames._();

  // Auth routes
  static const String login = '/login';
  static const String register = '/register';

  // Main routes
  static const String home = '/home';
  static const String homeIndex = 'home_index';
  static const String homeDetail = 'home_detail';

  static const String message = '/message';
  static const String messageIndex = 'message_index';
  static const String messageDetail = 'message_detail';

  static const String mine = '/mine';
  static const String mineIndex = 'mine_index';
  static const String setting = 'setting';
  static const String themeSetting = 'theme_setting';
  static const String languageSetting = 'language_setting';

  // Other routes
  static const String splash = '/splash';
  static const String error = '/error';
}
