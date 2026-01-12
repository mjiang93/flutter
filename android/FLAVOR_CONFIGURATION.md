# Android Flavor Configuration

This document describes the Android flavor configuration for the Enterprise Flutter Framework.

## Flavors

The project is configured with three product flavors:

### 1. Dev Flavor
- **Application ID**: `com.enterprise.flutter.dev`
- **App Name**: Enterprise Flutter (Dev)
- **Purpose**: Development environment
- **Build Command**: `flutter build apk --flavor dev`
- **Run Command**: `flutter run --flavor dev`

### 2. Test Flavor
- **Application ID**: `com.enterprise.flutter.test`
- **App Name**: Enterprise Flutter (Test)
- **Purpose**: Testing/staging environment
- **Build Command**: `flutter build apk --flavor test`
- **Run Command**: `flutter run --flavor test`

### 3. Prod Flavor
- **Application ID**: `com.enterprise.flutter`
- **App Name**: Enterprise Flutter
- **Purpose**: Production environment
- **Build Command**: `flutter build apk --release --flavor prod --obfuscate --split-debug-info=build/app/outputs/symbols`
- **Run Command**: `flutter run --release --flavor prod`

## Permissions

The following permissions are configured in AndroidManifest.xml:

### Required Permissions
- `INTERNET` - Network access
- `ACCESS_NETWORK_STATE` - Check network connectivity
- `ACCESS_WIFI_STATE` - Check WiFi connectivity

### Optional Permissions
- `CAMERA` - Camera access for photo capture
- `READ_EXTERNAL_STORAGE` - Read files (Android 12 and below)
- `WRITE_EXTERNAL_STORAGE` - Write files (Android 12 and below)
- `READ_MEDIA_IMAGES` - Read images (Android 13+)
- `READ_MEDIA_VIDEO` - Read videos (Android 13+)

## Network Security

The app uses a network security configuration (`network_security_config.xml`) that:
- Allows cleartext traffic for localhost and local network addresses (for development)
- Enforces HTTPS for production traffic
- Trusts system certificates

## ProGuard Configuration

ProGuard rules are configured in `proguard-rules.pro` to:
- Keep Flutter classes
- Keep Gson serialization classes
- Keep Retrofit interfaces
- Keep data models and entities
- Keep OkHttp classes

## App Icons

Each flavor has its own set of app icons located in:
- `android/app/src/dev/res/mipmap-*/ic_launcher.png`
- `android/app/src/test/res/mipmap-*/ic_launcher.png`
- `android/app/src/prod/res/mipmap-*/ic_launcher.png`

To customize icons for each flavor, replace the `ic_launcher.png` files in the respective directories.

## Build Types

### Debug
- Minification: Disabled
- Obfuscation: Disabled
- Signing: Debug keystore

### Release
- Minification: Enabled
- Obfuscation: Enabled (when using --obfuscate flag)
- ProGuard: Enabled
- Signing: Debug keystore (update with production keystore)

## Next Steps

1. **Update Application ID**: Change `com.enterprise.flutter` to your actual package name
2. **Configure Signing**: Set up proper signing configuration for release builds
3. **Customize Icons**: Replace app icons for each flavor with appropriate designs
4. **Update Permissions**: Add or remove permissions based on your app's requirements
