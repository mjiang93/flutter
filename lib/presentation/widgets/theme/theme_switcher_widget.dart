import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/theme_controller.dart';
import '../../theme/app_theme.dart';

/// Widget for switching between different theme modes
/// 
/// Provides UI for selecting theme mode and previewing themes
class ThemeSwitcherWidget extends StatelessWidget {
  const ThemeSwitcherWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ThemeController>();

    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThemeModeOption(
              context,
              controller,
              AppThemeMode.light,
              'Light Theme',
              'Bright and clean interface',
              Icons.light_mode,
            ),
            const Divider(),
            _buildThemeModeOption(
              context,
              controller,
              AppThemeMode.dark,
              'Dark Theme',
              'Easy on the eyes in low light',
              Icons.dark_mode,
            ),
            const Divider(),
            _buildThemeModeOption(
              context,
              controller,
              AppThemeMode.system,
              'System Theme',
              'Follow system settings',
              Icons.settings_system_daydream,
            ),
            const Divider(),
            _buildThemeModeOption(
              context,
              controller,
              AppThemeMode.custom,
              'Custom Theme',
              'Choose your own colors',
              Icons.palette,
            ),
            if (controller.themeMode == AppThemeMode.custom) ...[
              const SizedBox(height: 16),
              _buildCustomColorPicker(context, controller),
            ],
          ],
        ));
  }

  Widget _buildThemeModeOption(
    BuildContext context,
    ThemeController controller,
    AppThemeMode mode,
    String title,
    String subtitle,
    IconData icon,
  ) {
    final isSelected = controller.themeMode == mode;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppTheme.primaryColor : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppTheme.primaryColor : null,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppTheme.primaryColor)
          : null,
      onTap: () => controller.setThemeMode(mode),
    );
  }

  Widget _buildCustomColorPicker(
    BuildContext context,
    ThemeController controller,
  ) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];

    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose Primary Color',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: colors.map((color) {
                final isSelected = controller.customPrimaryColor == color;
                return RepaintBoundary(
                  child: GestureDetector(
                    onTap: () => controller.setCustomPrimaryColor(color),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Colors.white, width: 3)
                            : null,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: color.withOpacity(0.5),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                )
                              ]
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
