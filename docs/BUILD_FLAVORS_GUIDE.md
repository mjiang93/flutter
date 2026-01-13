# Build Flavors Guide

## Overview

This guide explains how to build the Enterprise Flutter App with different flavors (environments).

## Important Note: Flavor Naming Change

**The "test" flavor has been renamed to "staging"** because "test" is a reserved name in Gradle and causes build failures.

### Updated Flavor Names
- `dev` - Development environment
- `staging` - Staging/Testing environment (formerly "test")
- `prod` - Production environment

## Prerequisites

1. Flutter SDK installed (via FVM)
2. Android SDK with NDK installed
3. Xcode (for iOS builds)

## Flavor Configuration

### Android Configuration

Flavors are configured in `android/app/build.gradle.kts`:

```kotlin
productFlavors {
    create("dev") {
        dimension = "environment"
        applicationIdSuffix = ".dev"
        versionNameSuffix = "-dev"
        resValue("string", "app_name", "Enterprise Flutter (Dev)")
    }
    create("staging") {
        dimension = "environment"
        applicationIdSuffix = ".staging"
        versionNameSuffix = "-staging"
        resValue("string", "app_name", "Enterprise Flutter (Staging)")
    }
    create("prod") {
        dimension = "environment"
        resValue("string", "app_name", "Enterprise Flutter")
    }
}
```

### iOS Configuration

Flavors are configured using xcconfig files:
- `ios/Flutter/Dev.xcconfig`
- `ios/Flutter/Staging.xcconfig`
- `ios/Flutter/Prod.xcconfig`

### Entry Points

Each flavor has its own entry point:
- `lib/main_dev.dart` - Development
- `lib/main_staging.dart` - Staging
- `lib/main_prod.dart` - Production

## Building APKs

### Dev Flavor (Debug)

```bash
fvm flutter build apk --debug --flavor dev -t lib/main_dev.dart
```

Output: `build/app/outputs/flutter-apk/app-dev-debug.apk`

### Dev Flavor (Release)

```bash
fvm flutter build apk --flavor dev -t lib/main_dev.dart
```

Output: `build/app/outputs/flutter-apk/app-dev-release.apk`

### Staging Flavor (Debug)

```bash
fvm flutter build apk --debug --flavor staging -t lib/main_staging.dart
```

Output: `build/app/outputs/flutter-apk/app-staging-debug.apk`

### Staging Flavor (Release)

```bash
fvm flutter build apk --flavor staging -t lib/main_staging.dart
```

Output: `build/app/outputs/flutter-apk/app-staging-release.apk`

### Prod Flavor (Release with Obfuscation)

```bash
fvm flutter build apk --release --flavor prod --obfuscate --split-debug-info=build/app/outputs/symbols -t lib/main_prod.dart
```

Output: `build/app/outputs/flutter-apk/app-prod-release.apk`

## Running on Device/Emulator

### Dev Flavor

```bash
fvm flutter run --flavor dev -t lib/main_dev.dart
```

### Staging Flavor

```bash
fvm flutter run --flavor staging -t lib/main_staging.dart
```

### Prod Flavor

```bash
fvm flutter run --flavor prod -t lib/main_prod.dart
```

## Verification Checklist

### After Building Dev Flavor

- [ ] APK installs successfully on device
- [ ] App name shows "Enterprise Flutter (Dev)"
- [ ] App uses dev API URL: `https://dev-api.example.com`
- [ ] Debug logs are enabled
- [ ] App icon shows dev variant (if configured)

### After Building Staging Flavor

- [ ] APK installs successfully on device
- [ ] App name shows "Enterprise Flutter (Staging)"
- [ ] App uses staging API URL: `https://staging-api.example.com`
- [ ] Debug logs are enabled
- [ ] App icon shows staging variant (if configured)

### After Building Prod Flavor

- [ ] APK installs successfully on device
- [ ] App name shows "Enterprise Flutter"
- [ ] App uses prod API URL: `https://prod-api.example.com`
- [ ] Debug logs are disabled
- [ ] Code is obfuscated
- [ ] App icon shows production variant

## Troubleshooting

### NDK Issues

If you encounter NDK-related errors:

```bash
rm -rf ~/Library/Android/sdk/ndk/[version]
```

Then rebuild. Gradle will automatically download the correct NDK version.

### Flavor Not Found

If you get "flavor not found" errors, ensure:
1. Flavor names match exactly in `build.gradle.kts`
2. Corresponding entry point file exists (e.g., `lib/main_dev.dart`)
3. Run `fvm flutter clean` and rebuild

### Build Timeout

If builds take too long:
1. Ensure you have a stable internet connection (for dependency downloads)
2. Close other resource-intensive applications
3. Consider using `--debug` flag for faster builds during development

## API Configuration per Flavor

### Dev
- API Base URL: `https://dev-api.example.com`
- Connect Timeout: 5 seconds
- Receive Timeout: 15 seconds
- Debug Logs: Enabled
- Encryption Key: `dev-encryption-key-32-chars!!`

### Staging
- API Base URL: `https://staging-api.example.com`
- Connect Timeout: 3 seconds
- Receive Timeout: 10 seconds
- Debug Logs: Enabled
- Encryption Key: `staging-encryption-key-32-ch`

### Prod
- API Base URL: `https://prod-api.example.com`
- Connect Timeout: 3 seconds
- Receive Timeout: 10 seconds
- Debug Logs: Disabled
- Encryption Key: `prod-encryption-key-32-chars!`

## Code Changes Summary

The following files were updated to rename "test" to "staging":

1. `android/app/build.gradle.kts` - Updated flavor configuration
2. `android/app/src/test/` → `android/app/src/staging/` - Renamed directory
3. `ios/Runner/Assets-Test.xcassets` → `ios/Runner/Assets-Staging.xcassets` - Renamed assets
4. `ios/Flutter/Test.xcconfig` → `ios/Flutter/Staging.xcconfig` - Renamed config
5. `ios/Runner/Test/` → `ios/Runner/Staging/` - Renamed directory
6. `lib/main_test.dart` → `lib/main_staging.dart` - Renamed entry point
7. `lib/core/configs/flavor_config.dart` - Updated Flavor enum from `test` to `staging`

## Next Steps

After successfully building all flavors:
1. Test each flavor on physical devices
2. Verify API endpoints are correct
3. Test all core features (network, storage, navigation, theme, i18n)
4. Verify analytics and crash reporting work
5. Test deep linking functionality
6. Perform end-to-end testing
