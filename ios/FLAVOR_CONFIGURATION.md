# iOS Flavor Configuration

This document describes the iOS flavor configuration for the Enterprise Flutter Framework.

## Flavors

The project is configured with three schemes/flavors:

### 1. Dev Flavor
- **Bundle Identifier**: `com.enterprise.flutter.dev`
- **Display Name**: Enterprise Flutter (Dev)
- **Purpose**: Development environment
- **Build Command**: `flutter build ios --flavor dev`
- **Run Command**: `flutter run --flavor dev`
- **Configuration File**: `ios/Flutter/Dev.xcconfig`

### 2. Test Flavor
- **Bundle Identifier**: `com.enterprise.flutter.test`
- **Display Name**: Enterprise Flutter (Test)
- **Purpose**: Testing/staging environment
- **Build Command**: `flutter build ios --flavor test`
- **Run Command**: `flutter run --flavor test`
- **Configuration File**: `ios/Flutter/Test.xcconfig`

### 3. Prod Flavor
- **Bundle Identifier**: `com.enterprise.flutter`
- **Display Name**: Enterprise Flutter
- **Purpose**: Production environment
- **Build Command**: `flutter build ios --release --flavor prod`
- **Run Command**: `flutter run --release --flavor prod`
- **Configuration File**: `ios/Flutter/Prod.xcconfig`

## Permissions

The following permissions are configured in Info.plist:

### Privacy Permissions
- **NSCameraUsageDescription** - Camera access for photo capture
- **NSPhotoLibraryUsageDescription** - Photo library access for selecting photos
- **NSPhotoLibraryAddUsageDescription** - Permission to save photos
- **NSLocationWhenInUseUsageDescription** - Location access for location-based services
- **NSMicrophoneUsageDescription** - Microphone access for audio recording

### App Transport Security
- **NSAllowsArbitraryLoads**: `false` - Enforces HTTPS
- **NSAllowsLocalNetworking**: `true` - Allows local network access for development

## Configuration Files

### Flavor-Specific Configurations
Each flavor has its own xcconfig file:
- `ios/Flutter/Dev.xcconfig` - Dev environment settings
- `ios/Flutter/Test.xcconfig` - Test environment settings
- `ios/Flutter/Prod.xcconfig` - Production environment settings

### Flavor-Specific Info.plist
Each flavor has additional Info.plist settings:
- `ios/Runner/Dev/Info.plist` - Dev display name and bundle name
- `ios/Runner/Test/Info.plist` - Test display name and bundle name
- `ios/Runner/Prod/Info.plist` - Prod display name and bundle name

## App Icons

Each flavor has its own app icon set:
- `ios/Runner/Assets-Dev.xcassets/AppIcon.appiconset/` - Dev app icons
- `ios/Runner/Assets-Test.xcassets/AppIcon.appiconset/` - Test app icons
- `ios/Runner/Assets-Prod.xcassets/AppIcon.appiconset/` - Prod app icons

To customize icons for each flavor, replace the icon files in the respective directories.

## Xcode Configuration

### Creating Schemes in Xcode

To properly configure schemes in Xcode:

1. Open `ios/Runner.xcworkspace` in Xcode
2. Go to **Product > Scheme > Manage Schemes**
3. Duplicate the "Runner" scheme three times and rename them:
   - Runner-Dev
   - Runner-Test
   - Runner-Prod
4. For each scheme:
   - Edit the scheme
   - Under **Build Configuration**, select the appropriate configuration
   - Under **Run**, set the build configuration to Debug (for dev/test) or Release (for prod)
   - Under **Archive**, set the build configuration to Release

### Build Configurations

Create build configurations in Xcode:

1. Select the project in the Project Navigator
2. Select the project (not target) in the editor
3. Go to the **Info** tab
4. Under **Configurations**, duplicate Debug and Release configurations:
   - Debug-Dev, Debug-Test, Debug-Prod
   - Release-Dev, Release-Test, Release-Prod
5. For each configuration, set the appropriate xcconfig file:
   - Debug-Dev → `ios/Flutter/Dev.xcconfig`
   - Debug-Test → `ios/Flutter/Test.xcconfig`
   - Debug-Prod → `ios/Flutter/Prod.xcconfig`
   - Release-Dev → `ios/Flutter/Dev.xcconfig`
   - Release-Test → `ios/Flutter/Test.xcconfig`
   - Release-Prod → `ios/Flutter/Prod.xcconfig`

## Running Different Flavors

### From Command Line
```bash
# Dev flavor
flutter run --flavor dev

# Test flavor
flutter run --flavor test

# Prod flavor (release mode)
flutter run --release --flavor prod
```

### From Xcode
1. Select the appropriate scheme (Runner-Dev, Runner-Test, or Runner-Prod)
2. Click Run or press Cmd+R

## Building for Distribution

### Development Build
```bash
flutter build ios --flavor dev
```

### Test Build
```bash
flutter build ios --flavor test
```

### Production Build
```bash
flutter build ios --release --flavor prod
```

### Archive for App Store
1. Open Xcode
2. Select the Runner-Prod scheme
3. Select "Any iOS Device" as the destination
4. Go to **Product > Archive**
5. Once archived, click **Distribute App**

## Next Steps

1. **Update Bundle Identifiers**: Change `com.enterprise.flutter` to your actual bundle identifier
2. **Configure Signing**: Set up proper code signing for each flavor
3. **Customize Icons**: Replace app icons for each flavor with appropriate designs
4. **Update Permissions**: Add or remove permissions based on your app's requirements
5. **Configure Xcode**: Complete the Xcode scheme and configuration setup as described above
6. **Test Builds**: Test building and running each flavor to ensure proper configuration
