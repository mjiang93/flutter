import 'package:flutter/material.dart';

/// Flutter framework extensions
/// 
/// Provides convenient extension methods for:
/// - BuildContext (theme, mediaQuery, navigation shortcuts)
/// - Widget (padding, margin, visibility helpers)
/// - Color (brightness, opacity, hex conversion)
/// - TextStyle (weight, size helpers)

// BuildContext extensions
extension BuildContextExtension on BuildContext {
  // Theme shortcuts
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  
  Color get primaryColor => colorScheme.primary;
  Color get secondaryColor => colorScheme.secondary;
  Color get backgroundColor => colorScheme.background;
  Color get surfaceColor => colorScheme.surface;
  Color get errorColor => colorScheme.error;
  
  // MediaQuery shortcuts
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  EdgeInsets get padding => mediaQuery.padding;
  EdgeInsets get viewInsets => mediaQuery.viewInsets;
  EdgeInsets get viewPadding => mediaQuery.viewPadding;
  double get devicePixelRatio => mediaQuery.devicePixelRatio;
  Brightness get platformBrightness => mediaQuery.platformBrightness;
  
  bool get isKeyboardVisible => viewInsets.bottom > 0;
  bool get isDarkMode => platformBrightness == Brightness.dark;
  bool get isLightMode => platformBrightness == Brightness.light;
  
  // Responsive helpers
  bool get isSmallScreen => screenWidth < 600;
  bool get isMediumScreen => screenWidth >= 600 && screenWidth < 1024;
  bool get isLargeScreen => screenWidth >= 1024;
  
  // Navigation shortcuts
  NavigatorState get navigator => Navigator.of(this);
  
  void pop<T>([T? result]) => navigator.pop(result);
  
  Future<T?> push<T>(Route<T> route) => navigator.push(route);
  
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) =>
      navigator.pushNamed(routeName, arguments: arguments);
  
  Future<T?> pushReplacement<T, TO>(Route<T> route, {TO? result}) =>
      navigator.pushReplacement(route, result: result);
  
  Future<T?> pushReplacementNamed<T, TO>(String routeName, {TO? result, Object? arguments}) =>
      navigator.pushReplacementNamed(routeName, result: result, arguments: arguments);
  
  Future<T?> pushAndRemoveUntil<T>(Route<T> route, bool Function(Route<dynamic>) predicate) =>
      navigator.pushAndRemoveUntil(route, predicate);
  
  Future<T?> pushNamedAndRemoveUntil<T>(
    String routeName,
    bool Function(Route<dynamic>) predicate, {
    Object? arguments,
  }) =>
      navigator.pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);
  
  void popUntil(bool Function(Route<dynamic>) predicate) =>
      navigator.popUntil(predicate);
  
  // ScaffoldMessenger shortcuts
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);
  
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
      ),
    );
  }
  
  void showErrorSnackBar(String message) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: errorColor,
        duration: const Duration(seconds: 4),
      ),
    );
  }
  
  void showSuccessSnackBar(String message) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }
  
  void hideCurrentSnackBar() => scaffoldMessenger.hideCurrentSnackBar();
  
  // FocusScope shortcuts
  FocusScopeNode get focusScope => FocusScope.of(this);
  
  void unfocus() => focusScope.unfocus();
  
  void requestFocus(FocusNode node) => focusScope.requestFocus(node);
}

// Widget extensions
extension WidgetExtension on Widget {
  // Padding helpers
  Widget paddingAll(double padding) => Padding(
        padding: EdgeInsets.all(padding),
        child: this,
      );
  
  Widget paddingSymmetric({double horizontal = 0, double vertical = 0}) => Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
        child: this,
      );
  
  Widget paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) =>
      Padding(
        padding: EdgeInsets.only(left: left, top: top, right: right, bottom: bottom),
        child: this,
      );
  
  Widget get paddingZero => Padding(
        padding: EdgeInsets.zero,
        child: this,
      );
  
  // Margin helpers (using Container)
  Widget marginAll(double margin) => Container(
        margin: EdgeInsets.all(margin),
        child: this,
      );
  
  Widget marginSymmetric({double horizontal = 0, double vertical = 0}) => Container(
        margin: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
        child: this,
      );
  
  Widget marginOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) =>
      Container(
        margin: EdgeInsets.only(left: left, top: top, right: right, bottom: bottom),
        child: this,
      );
  
  // Visibility helpers
  Widget visible(bool isVisible) => Visibility(
        visible: isVisible,
        child: this,
      );
  
  Widget invisible(bool isInvisible) => Visibility(
        visible: !isInvisible,
        child: this,
      );
  
  Widget opacity(double opacity) => Opacity(
        opacity: opacity,
        child: this,
      );
  
  // Gesture helpers
  Widget onTap(VoidCallback? onTap, {bool opaque = true}) => GestureDetector(
        onTap: onTap,
        behavior: opaque ? HitTestBehavior.opaque : HitTestBehavior.deferToChild,
        child: this,
      );
  
  Widget onLongPress(VoidCallback? onLongPress) => GestureDetector(
        onLongPress: onLongPress,
        child: this,
      );
  
  Widget onDoubleTap(VoidCallback? onDoubleTap) => GestureDetector(
        onDoubleTap: onDoubleTap,
        child: this,
      );
  
  // Alignment helpers
  Widget center() => Center(child: this);
  
  Widget align(Alignment alignment) => Align(
        alignment: alignment,
        child: this,
      );
  
  // Expanded/Flexible helpers
  Widget expanded({int flex = 1}) => Expanded(
        flex: flex,
        child: this,
      );
  
  Widget flexible({int flex = 1, FlexFit fit = FlexFit.loose}) => Flexible(
        flex: flex,
        fit: fit,
        child: this,
      );
  
  // SizedBox helpers
  Widget sized({double? width, double? height}) => SizedBox(
        width: width,
        height: height,
        child: this,
      );
  
  Widget sizedSquare(double size) => SizedBox(
        width: size,
        height: size,
        child: this,
      );
  
  // Card wrapper
  Widget card({
    Color? color,
    double? elevation,
    ShapeBorder? shape,
    EdgeInsetsGeometry? margin,
  }) =>
      Card(
        color: color,
        elevation: elevation,
        shape: shape,
        margin: margin,
        child: this,
      );
  
  // ClipRRect helper
  Widget clipRRect({double radius = 8.0}) => ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: this,
      );
  
  // Hero wrapper
  Widget hero(String tag) => Hero(
        tag: tag,
        child: this,
      );
  
  // SafeArea wrapper
  Widget safeArea({
    bool top = true,
    bool bottom = true,
    bool left = true,
    bool right = true,
  }) =>
      SafeArea(
        top: top,
        bottom: bottom,
        left: left,
        right: right,
        child: this,
      );
}

// Color extensions
extension ColorExtension on Color {
  /// Check if color is dark
  bool get isDark => computeLuminance() < 0.5;
  
  /// Check if color is light
  bool get isLight => computeLuminance() >= 0.5;
  
  /// Get contrasting text color (black or white)
  Color get contrastingTextColor => isDark ? Colors.white : Colors.black;
  
  /// Lighten color by percentage (0.0 to 1.0)
  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
  
  /// Darken color by percentage (0.0 to 1.0)
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
  
  /// Create color with opacity
  Color withOpacityValue(double opacity) => withOpacity(opacity);
  
  /// Convert to hex string (e.g., #FF5733)
  String toHex({bool includeAlpha = false}) {
    if (includeAlpha) {
      return '#${alpha.toRadixString(16).padLeft(2, '0')}'
          '${red.toRadixString(16).padLeft(2, '0')}'
          '${green.toRadixString(16).padLeft(2, '0')}'
          '${blue.toRadixString(16).padLeft(2, '0')}'
          .toUpperCase();
    }
    return '#${red.toRadixString(16).padLeft(2, '0')}'
        '${green.toRadixString(16).padLeft(2, '0')}'
        '${blue.toRadixString(16).padLeft(2, '0')}'
        .toUpperCase();
  }
  
  /// Create color from hex string (e.g., #FF5733 or FF5733)
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
  
  /// Create color from hex string with alpha (e.g., #80FF5733)
  static Color fromHexWithAlpha(String hexString) {
    final buffer = StringBuffer();
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

// TextStyle extensions
extension TextStyleExtension on TextStyle {
  // Font weight helpers
  TextStyle get thin => copyWith(fontWeight: FontWeight.w100);
  TextStyle get extraLight => copyWith(fontWeight: FontWeight.w200);
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);
  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);
  TextStyle get extraBold => copyWith(fontWeight: FontWeight.w800);
  TextStyle get black => copyWith(fontWeight: FontWeight.w900);
  
  // Font size helpers
  TextStyle size(double size) => copyWith(fontSize: size);
  TextStyle get xs => copyWith(fontSize: 12);
  TextStyle get sm => copyWith(fontSize: 14);
  TextStyle get base => copyWith(fontSize: 16);
  TextStyle get lg => copyWith(fontSize: 18);
  TextStyle get xl => copyWith(fontSize: 20);
  TextStyle get xl2 => copyWith(fontSize: 24);
  TextStyle get xl3 => copyWith(fontSize: 30);
  TextStyle get xl4 => copyWith(fontSize: 36);
  
  // Color helper
  TextStyle textColor(Color color) => copyWith(color: color);
  
  // Letter spacing helper
  TextStyle letterSpacing(double spacing) => copyWith(letterSpacing: spacing);
  
  // Line height helper
  TextStyle lineHeight(double height) => copyWith(height: height);
  
  // Font style helpers
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);
  TextStyle get normal => copyWith(fontStyle: FontStyle.normal);
  
  // Text decoration helpers
  TextStyle get underline => copyWith(decoration: TextDecoration.underline);
  TextStyle get lineThrough => copyWith(decoration: TextDecoration.lineThrough);
  TextStyle get overline => copyWith(decoration: TextDecoration.overline);
  TextStyle get noDecoration => copyWith(decoration: TextDecoration.none);
}
