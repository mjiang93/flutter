import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../base_page.dart';
import '../../widgets/theme/theme_switcher_widget.dart';

/// Theme settings page - allows user to change app theme
@RoutePage()
class ThemeSettingPage extends BasePage {
  const ThemeSettingPage({Key? key}) : super(key: key);

  @override
  String? get title => 'Theme Settings';

  @override
  Widget buildBody(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: ThemeSwitcherWidget(),
      ),
    );
  }
}
