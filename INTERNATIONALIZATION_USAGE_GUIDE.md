# Internationalization Usage Guide

## Overview
This guide explains how to use the EasyLocalization system in the Enterprise Flutter Framework.

## Quick Start

### 1. Import EasyLocalization
```dart
import 'package:easy_localization/easy_localization.dart';
```

### 2. Basic Translation Usage

#### Simple Translation
```dart
// Translation key: "home.title" in JSON
Text('home.title'.tr())
```

#### Translation with Parameters
```dart
// JSON: "welcome": "Welcome, {name}!"
Text('welcome'.tr(args: ['John']))
// Output: "Welcome, John!"
```

#### Plural Translations
```dart
// JSON: "items": {"zero": "No items", "one": "1 item", "other": "{} items"}
Text('items'.plural(count))
```

#### Gender-Specific Translations
```dart
// JSON: "greeting": {"male": "Hello Mr. {}", "female": "Hello Ms. {}"}
Text('greeting'.tr(gender: 'male', args: ['Smith']))
```

## Translation File Structure

### Location
`assets/translations/`
- `en.json` - English
- `zh.json` - Chinese (Simplified)

### Module Organization
```json
{
  "app": {
    "name": "App Name",
    "title": "App Title"
  },
  "common": {
    "ok": "OK",
    "cancel": "Cancel",
    "loading": "Loading..."
  },
  "home": {
    "title": "Home",
    "refresh": "Pull to refresh"
  },
  "message": {
    "title": "Messages",
    "unread": "Unread"
  },
  "mine": {
    "title": "Mine",
    "settings": "Settings"
  }
}
```

## Common Use Cases

### 1. Page Titles
```dart
@override
String? get title => 'home.title'.tr();
```

### 2. Button Labels
```dart
ElevatedButton(
  onPressed: () {},
  child: Text('common.save'.tr()),
)
```

### 3. Dialog Messages
```dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('common.confirm'.tr()),
    content: Text('mine.logout_confirm'.tr()),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text('common.cancel'.tr()),
      ),
      TextButton(
        onPressed: () => _logout(),
        child: Text('common.ok'.tr()),
      ),
    ],
  ),
);
```

### 4. Error Messages
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('error.network'.tr())),
);
```

### 5. Empty States
```dart
Center(
  child: Text('common.no_data'.tr()),
)
```

## Accessing Current Locale

### Get Current Locale
```dart
final currentLocale = context.locale;
print(currentLocale.languageCode); // 'en' or 'zh'
```

### Check Current Language
```dart
if (context.locale.languageCode == 'zh') {
  // Chinese-specific logic
}
```

## Changing Language

### Programmatically Change Language
```dart
// Change to English
await context.setLocale(const Locale('en'));

// Change to Chinese
await context.setLocale(const Locale('zh'));

// Don't forget to persist!
await SPManager.saveLanguage(locale.languageCode);
```

### Reset to Device Locale
```dart
await context.resetLocale();
```

## Best Practices

### 1. Never Hardcode Strings
❌ **Bad:**
```dart
Text('Home')
```

✅ **Good:**
```dart
Text('home.title'.tr())
```

### 2. Use Descriptive Keys
❌ **Bad:**
```dart
"text1": "Submit"
```

✅ **Good:**
```dart
"common.submit": "Submit"
```

### 3. Organize by Module
Keep translations organized by feature/module:
```
home.*
message.*
mine.*
common.*
```

### 4. Keep Keys Consistent
Use the same key structure across all language files:
```json
// en.json
{
  "home": {
    "title": "Home"
  }
}

// zh.json
{
  "home": {
    "title": "首页"
  }
}
```

### 5. Handle Missing Translations
EasyLocalization will fall back to the fallback locale (English) if a key is missing.

## Adding New Languages

### 1. Create Translation File
Create `assets/translations/es.json` for Spanish:
```json
{
  "app": {
    "name": "Aplicación Empresarial"
  },
  "common": {
    "ok": "Aceptar",
    "cancel": "Cancelar"
  }
}
```

### 2. Update Supported Locales
In `lib/main.dart`:
```dart
supportedLocales: const [
  Locale('en'),
  Locale('zh'),
  Locale('es'),  // Add Spanish
]
```

### 3. Update Language Settings Page
Add the new language option in `LanguageSettingPage`.

## Testing Translations

### 1. Check All Keys Exist
Ensure all translation keys exist in all language files.

### 2. Test Language Switching
- Switch between languages
- Verify all text updates
- Check that language persists after restart

### 3. Test Fallback Behavior
- Remove a key from one language file
- Verify it falls back to English

## Common Translation Keys

### App-Level
- `app.name` - Application name
- `app.title` - Application title

### Common UI
- `common.ok` - OK button
- `common.cancel` - Cancel button
- `common.confirm` - Confirm button
- `common.save` - Save button
- `common.delete` - Delete button
- `common.edit` - Edit button
- `common.loading` - Loading message
- `common.retry` - Retry button
- `common.refresh` - Refresh action
- `common.no_data` - No data message
- `common.no_network` - Network error
- `common.error` - Generic error
- `common.success` - Success message
- `common.failed` - Failure message

### Navigation
- `home.title` - Home page title
- `message.title` - Message page title
- `mine.title` - Profile page title

### Settings
- `mine.settings` - Settings label
- `mine.theme` - Theme settings
- `mine.language` - Language settings
- `mine.logout` - Logout button
- `mine.logout_confirm` - Logout confirmation

### Theme
- `theme.light` - Light theme
- `theme.dark` - Dark theme
- `theme.system` - System theme
- `theme.custom` - Custom theme

### Language
- `language.english` - English label
- `language.chinese` - Chinese label

### Errors
- `error.network` - Network error
- `error.timeout` - Timeout error
- `error.server` - Server error
- `error.unknown` - Unknown error

## Advanced Features

### Context Extension Methods
```dart
// Get translation
context.tr('key')

// Get plural
context.plural('key', count)

// Get locale
context.locale

// Set locale
context.setLocale(locale)

// Reset locale
context.resetLocale()
```

### Date and Number Formatting
```dart
// Format date according to locale
final formattedDate = DateFormat.yMMMd(context.locale.toString()).format(date);

// Format number according to locale
final formattedNumber = NumberFormat.currency(
  locale: context.locale.toString(),
  symbol: '\$',
).format(amount);
```

## Troubleshooting

### Translation Not Showing
1. Check the key exists in JSON file
2. Verify JSON syntax is valid
3. Ensure asset path is correct in pubspec.yaml
4. Rebuild the app

### Language Not Persisting
1. Verify `SPManager.saveLanguage()` is called
2. Check SharedPreferences permissions
3. Ensure `_loadSavedLanguage()` is called on startup

### Fallback Not Working
1. Verify fallback locale is set correctly
2. Check that fallback locale has all keys
3. Ensure EasyLocalization is properly initialized

## Resources

- [EasyLocalization Documentation](https://pub.dev/packages/easy_localization)
- [Flutter Internationalization Guide](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)
- Translation Files: `assets/translations/`
- Implementation: `lib/main.dart`, `lib/presentation/pages/mine/language_setting_page.dart`
