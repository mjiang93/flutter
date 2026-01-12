import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/usecases/get_user_info_usecase.dart';
import '../../../domain/usecases/logout_usecase.dart';
import '../../../injection/locator.dart';
import '../../controllers/mine_controller.dart';
import '../base_page.dart';
import 'widgets/user_info_widget.dart';

/// Mine page - user profile and settings
/// 
/// Features:
/// - User information display (avatar, nickname, phone)
/// - Logout button with confirmation
/// - Theme setting entry
/// - Language setting entry
/// - General settings entry
@RoutePage()
class MinePage extends BasePage {
  const MinePage({Key? key}) : super(key: key);

  @override
  String? get title => 'Mine';

  @override
  bool get showBackButton => false;

  @override
  Widget buildBody(BuildContext context) {
    // Inject controller with Get.put for lifecycle management
    // Get dependencies from getIt instead of Get.find
    final controller = Get.put(MineController(
      getIt(),
      getIt(),
    ));

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Obx(() {
      return SingleChildScrollView(
        child: Column(
          children: [
            // User info section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primaryContainer,
                    colorScheme.secondaryContainer,
                  ],
                ),
              ),
              child: UserInfoWidget(user: controller.user),
            ),
            
            const SizedBox(height: 16),
            
            // Settings section
            _buildSettingsSection(
              context,
              children: [
                _buildSettingItem(
                  context,
                  icon: Icons.palette_outlined,
                  title: 'Theme',
                  subtitle: 'Customize app appearance',
                  onTap: controller.navigateToThemeSetting,
                ),
                _buildSettingItem(
                  context,
                  icon: Icons.language_outlined,
                  title: 'Language',
                  subtitle: 'Change app language',
                  onTap: controller.navigateToLanguageSetting,
                ),
                _buildSettingItem(
                  context,
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  subtitle: 'General app settings',
                  onTap: controller.navigateToSettings,
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Logout section
            _buildSettingsSection(
              context,
              children: [
                _buildSettingItem(
                  context,
                  icon: Icons.logout_outlined,
                  title: 'Logout',
                  subtitle: 'Sign out of your account',
                  onTap: controller.logout,
                  isDestructive: true,
                ),
              ],
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      );
    });
  }

  Widget _buildSettingsSection(
    BuildContext context, {
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final iconColor = isDestructive ? colorScheme.error : colorScheme.primary;
    final titleColor = isDestructive ? colorScheme.error : colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            
            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: titleColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            
            // Arrow icon
            Icon(
              Icons.chevron_right,
              color: colorScheme.outline,
            ),
          ],
        ),
      ),
    );
  }
}
