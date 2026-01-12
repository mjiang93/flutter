import 'package:flutter/material.dart';

import '../../core/services/analytics_manager.dart';

/// Base page for all pages in the app
/// 
/// Provides common page structure with:
/// - Optional AppBar with title
/// - Optional back button
/// - Optional actions
/// - SafeArea wrapper
/// - Automatic page view tracking with duration calculation
abstract class BasePage extends StatefulWidget {
  const BasePage({super.key});

  /// Page title (null = no AppBar)
  String? get title => null;

  /// Show back button in AppBar
  bool get showBackButton => true;

  /// AppBar actions
  List<Widget>? get actions => null;

  /// AppBar background color (null = use theme default)
  Color? get appBarBackgroundColor => null;

  /// Page name for analytics (defaults to runtimeType)
  /// 
  /// Override this to provide a custom page name for analytics.
  /// Use snake_case format (e.g., 'home_page', 'message_detail')
  String get pageName => runtimeType.toString().replaceAllMapped(
        RegExp(r'([A-Z])'),
        (match) => '_${match.group(0)!.toLowerCase()}',
      ).substring(1);

  /// Build page body
  Widget buildBody(BuildContext context);

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  DateTime? _pageEnterTime;

  @override
  void initState() {
    super.initState();
    _pageEnterTime = DateTime.now();
    
    // Log page view
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AnalyticsManager.logPageView(widget.pageName);
    });
  }

  @override
  void dispose() {
    // Calculate and log page duration
    if (_pageEnterTime != null) {
      final duration = DateTime.now().difference(_pageEnterTime!);
      AnalyticsManager.logEvent('page_exit', {
        'page_name': widget.pageName,
        'duration_seconds': duration.inSeconds,
        'duration_ms': duration.inMilliseconds,
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.title != null
          ? AppBar(
              title: Text(widget.title!),
              automaticallyImplyLeading: widget.showBackButton,
              actions: widget.actions,
              backgroundColor: widget.appBarBackgroundColor,
            )
          : null,
      body: SafeArea(
        child: widget.buildBody(context),
      ),
    );
  }
}
