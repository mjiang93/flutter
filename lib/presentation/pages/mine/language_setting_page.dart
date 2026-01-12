import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../data/datasources/local/sp_manager.dart';
import '../base_page.dart';

/// Language settings page - allows user to change app language
/// 
/// Features:
/// - Display language options (Chinese, English)
/// - Handle language change
/// - Show current language selection
/// - Apply changes immediately
@RoutePage()
class LanguageSettingPage extends BasePage {
  const LanguageSettingPage({Key? key}) : super(key: key);

  @override
  String? get title => 'Language Settings';

  @override
  Widget buildBody(BuildContext context) {
    final currentLocale = context.locale;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildLanguageOption(
          context,
          locale: const Locale('en'),
          title: 'English',
          subtitle: 'English',
          icon: '🇺🇸',
          isSelected: currentLocale.languageCode == 'en',
        ),
        const SizedBox(height: 12),
        _buildLanguageOption(
          context,
          locale: const Locale('zh'),
          title: '简体中文',
          subtitle: 'Simplified Chinese',
          icon: '🇨🇳',
          isSelected: currentLocale.languageCode == 'zh',
        ),
      ],
    );
  }

  Widget _buildLanguageOption(
    BuildContext context, {
    required Locale locale,
    required String title,
    required String subtitle,
    required String icon,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: isSelected ? 4 : 1,
      color: isSelected 
          ? colorScheme.primaryContainer 
          : colorScheme.surface,
      child: InkWell(
        onTap: () async {
          // Change language
          await context.setLocale(locale);
          
          // Persist language preference
          await SPManager.saveLanguage(locale.languageCode);
          
          // Show confirmation
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Language changed to $title'),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Flag icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected 
                        ? colorScheme.primary 
                        : colorScheme.outline.withOpacity(0.2),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    icon,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Language info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: isSelected 
                            ? FontWeight.bold 
                            : FontWeight.w600,
                        color: isSelected 
                            ? colorScheme.onPrimaryContainer 
                            : colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isSelected 
                            ? colorScheme.onPrimaryContainer.withOpacity(0.7)
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Selection indicator
              if (isSelected)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: colorScheme.onPrimary,
                    size: 20,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
