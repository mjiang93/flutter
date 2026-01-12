import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/route_names.dart';
import '../base_page.dart';

/// Settings page - general app settings
/// 
/// Features:
/// - List all settings options
/// - Navigate to specific setting pages (theme, language)
/// - Display app version and build info
@RoutePage()
class SettingPage extends BasePage {
  const SettingPage({Key? key}) : super(key: key);

  @override
  String? get title => 'Settings';

  @override
  Widget buildBody(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Appearance section
        _buildSectionHeader(context, 'Appearance'),
        const SizedBox(height: 8),
        _buildSettingsCard(
          context,
          children: [
            _buildSettingItem(
              context,
              icon: Icons.palette_outlined,
              title: 'Theme',
              subtitle: 'Customize app appearance',
              onTap: () => Get.toNamed(RouteNames.themeSetting),
            ),
            const Divider(height: 1),
            _buildSettingItem(
              context,
              icon: Icons.language_outlined,
              title: 'Language',
              subtitle: 'Change app language',
              onTap: () => Get.toNamed(RouteNames.languageSetting),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Notifications section
        _buildSectionHeader(context, 'Notifications'),
        const SizedBox(height: 8),
        _buildSettingsCard(
          context,
          children: [
            _buildSwitchItem(
              context,
              icon: Icons.notifications_outlined,
              title: 'Push Notifications',
              subtitle: 'Receive push notifications',
              value: true,
              onChanged: (value) {
                // TODO: Implement notification toggle
              },
            ),
            const Divider(height: 1),
            _buildSwitchItem(
              context,
              icon: Icons.vibration_outlined,
              title: 'Vibration',
              subtitle: 'Vibrate on notifications',
              value: true,
              onChanged: (value) {
                // TODO: Implement vibration toggle
              },
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Data & Storage section
        _buildSectionHeader(context, 'Data & Storage'),
        const SizedBox(height: 8),
        _buildSettingsCard(
          context,
          children: [
            _buildSettingItem(
              context,
              icon: Icons.cleaning_services_outlined,
              title: 'Clear Cache',
              subtitle: 'Free up storage space',
              onTap: () {
                _showClearCacheDialog(context);
              },
            ),
            const Divider(height: 1),
            _buildSettingItem(
              context,
              icon: Icons.download_outlined,
              title: 'Download Settings',
              subtitle: 'Manage download preferences',
              onTap: () {
                // TODO: Navigate to download settings
              },
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // About section
        _buildSectionHeader(context, 'About'),
        const SizedBox(height: 8),
        _buildSettingsCard(
          context,
          children: [
            _buildSettingItem(
              context,
              icon: Icons.info_outlined,
              title: 'Version',
              subtitle: '1.0.0 (Build 1)',
              trailing: null,
            ),
            const Divider(height: 1),
            _buildSettingItem(
              context,
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              subtitle: 'Read our terms',
              onTap: () {
                // TODO: Navigate to terms
              },
            ),
            const Divider(height: 1),
            _buildSettingItem(
              context,
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              subtitle: 'Read our privacy policy',
              onTap: () {
                // TODO: Navigate to privacy policy
              },
            ),
          ],
        ),
        
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context, {
    required List<Widget> children,
  }) {
    return Container(
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
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: colorScheme.primary,
                size: 20,
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
                    style: theme.textTheme.titleSmall?.copyWith(
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
            
            // Trailing
            if (trailing != null)
              trailing
            else if (onTap != null)
              Icon(
                Icons.chevron_right,
                color: colorScheme.outline,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return _buildSettingItem(
      context,
      icon: icon,
      title: title,
      subtitle: subtitle,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text(
          'This will clear all cached data. Are you sure you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              // TODO: Implement cache clearing
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache cleared successfully'),
                ),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
