# Deep Linking Configuration Guide

This guide explains how to configure and test deep linking for the Enterprise Flutter Framework.

## Overview

The app supports two types of deep linking:

1. **Universal Links (iOS) / App Links (Android)**: HTTPS URLs that open the app
2. **Custom URL Schemes**: Custom protocol URLs (e.g., `enterpriseflutter://`)

## Supported Deep Link Patterns

### Universal Links / App Links
- `https://enterprise.flutter.com/home` - Navigate to home page
- `https://enterprise.flutter.com/message` - Navigate to message list
- `https://enterprise.flutter.com/message?id=123` - Navigate to specific message
- `https://enterprise.flutter.com/mine` - Navigate to profile page
- `https://enterprise.flutter.com/settings` - Navigate to settings page

### Custom URL Scheme
- `enterpriseflutter://app/home` - Navigate to home page
- `enterpriseflutter://app/message` - Navigate to message list
- `enterpriseflutter://app/message?id=123` - Navigate to specific message
- `enterpriseflutter://app/mine` - Navigate to profile page
- `enterpriseflutter://app/settings` - Navigate to settings page

## Android Configuration

### 1. AndroidManifest.xml

The AndroidManifest.xml has been configured with intent filters for both App Links and custom URL schemes.

**App Links (HTTPS)**:
```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    
    <data
        android:scheme="https"
        android:host="enterprise.flutter.com"
        android:pathPrefix="/" />
</intent-filter>
```

**Custom URL Scheme**:
```xml
<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    
    <data
        android:scheme="enterpriseflutter"
        android:host="app" />
</intent-filter>
```

### 2. Digital Asset Links (assetlinks.json)

For App Links to work, you need to host an `assetlinks.json` file at:
```
https://enterprise.flutter.com/.well-known/assetlinks.json
```

**Steps to configure**:

1. Get your app's SHA-256 fingerprint:
   ```bash
   # For debug keystore
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   
   # For release keystore
   keytool -list -v -keystore /path/to/your/keystore.jks -alias your-alias
   ```

2. Update `android/assetlinks.json` with your SHA-256 fingerprints

3. Upload the file to your web server at `/.well-known/assetlinks.json`

4. Verify the file is accessible:
   ```bash
   curl https://enterprise.flutter.com/.well-known/assetlinks.json
   ```

5. Test with Google's Digital Asset Links tool:
   https://developers.google.com/digital-asset-links/tools/generator

### 3. Testing Android Deep Links

**Test Custom URL Scheme**:
```bash
adb shell am start -W -a android.intent.action.VIEW -d "enterpriseflutter://app/home" com.enterprise.flutter.dev
```

**Test App Links**:
```bash
adb shell am start -W -a android.intent.action.VIEW -d "https://enterprise.flutter.com/home" com.enterprise.flutter.dev
```

**Verify App Links**:
```bash
adb shell pm get-app-links com.enterprise.flutter.dev
```

## iOS Configuration

### 1. Info.plist

The Info.plist has been configured with:

**Custom URL Schemes**:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLName</key>
        <string>com.enterprise.flutter</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>enterpriseflutter</string>
        </array>
    </dict>
</array>
```

**Associated Domains**:
```xml
<key>com.apple.developer.associated-domains</key>
<array>
    <string>applinks:enterprise.flutter.com</string>
    <string>applinks:www.enterprise.flutter.com</string>
</array>
```

### 2. Xcode Configuration

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select the Runner target
3. Go to **Signing & Capabilities** tab
4. Click **+ Capability** and add **Associated Domains**
5. Add the following domains:
   - `applinks:enterprise.flutter.com`
   - `applinks:www.enterprise.flutter.com`

### 3. Apple App Site Association (AASA)

For Universal Links to work, you need to host an `apple-app-site-association` file at:
```
https://enterprise.flutter.com/.well-known/apple-app-site-association
```

**Steps to configure**:

1. Get your Team ID from Apple Developer Portal

2. Update `ios/apple-app-site-association` with your Team ID

3. Upload the file to your web server at `/.well-known/apple-app-site-association`

4. Ensure the file:
   - Has no file extension
   - Is served with `Content-Type: application/json`
   - Is accessible via HTTPS

5. Verify the file is accessible:
   ```bash
   curl https://enterprise.flutter.com/.well-known/apple-app-site-association
   ```

6. Test with Apple's AASA Validator:
   https://search.developer.apple.com/appsearch-validation-tool/

### 4. Testing iOS Deep Links

**Test Custom URL Scheme** (in Safari or Notes):
```
enterpriseflutter://app/home
```

**Test Universal Links** (in Safari, Messages, or Notes):
```
https://enterprise.flutter.com/home
```

**Test from Command Line** (iOS Simulator):
```bash
xcrun simctl openurl booted "enterpriseflutter://app/home"
xcrun simctl openurl booted "https://enterprise.flutter.com/home"
```

## Flutter Implementation

### Deep Link Service

The `DeepLinkService` class handles incoming deep links and navigates to the appropriate screen.

**Initialize in main.dart**:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize deep link service
  final deepLinkService = DeepLinkService();
  await deepLinkService.initialize();
  
  runApp(MyApp());
}
```

**Listen to deep link events**:
```dart
deepLinkService.deepLinkStream.listen((uri) {
  print('Deep link received: $uri');
  // Handle navigation
});
```

## Testing Checklist

### Android
- [ ] Custom URL scheme works from browser
- [ ] Custom URL scheme works from ADB command
- [ ] App Links work from browser (after assetlinks.json is hosted)
- [ ] App Links verified with Google's tool
- [ ] Deep links work for all flavors (dev, test, prod)

### iOS
- [ ] Custom URL scheme works from Safari
- [ ] Custom URL scheme works from Notes/Messages
- [ ] Universal Links work from Safari (after AASA is hosted)
- [ ] Universal Links work from Messages
- [ ] Associated Domains capability is enabled in Xcode
- [ ] AASA file validated with Apple's tool
- [ ] Deep links work for all flavors (dev, test, prod)

## Common Issues and Solutions

### Android

**Issue**: App Links not working
- **Solution**: Verify assetlinks.json is hosted correctly and SHA-256 fingerprint matches
- **Check**: Run `adb shell pm get-app-links com.enterprise.flutter.dev`

**Issue**: Custom URL scheme opens browser instead of app
- **Solution**: Ensure intent filter has `android:autoVerify="false"` for custom schemes

### iOS

**Issue**: Universal Links not working
- **Solution**: Verify AASA file is hosted correctly and Team ID is correct
- **Check**: Use Apple's AASA Validator tool

**Issue**: Universal Links open in Safari instead of app
- **Solution**: Long-press the link and select "Open in [App Name]" once to set preference
- **Note**: Universal Links won't work if tapped from the same domain

**Issue**: Associated Domains capability not showing
- **Solution**: Ensure you're signed in with your Apple Developer account in Xcode

## Production Deployment

### Before Going Live

1. **Update Domain**: Replace `enterprise.flutter.com` with your actual domain in:
   - `android/app/src/main/AndroidManifest.xml`
   - `ios/Runner/Info.plist`
   - `lib/core/services/deep_link_service.dart`

2. **Host Verification Files**:
   - Upload `assetlinks.json` to `https://yourdomain.com/.well-known/assetlinks.json`
   - Upload `apple-app-site-association` to `https://yourdomain.com/.well-known/apple-app-site-association`

3. **Update SHA-256 Fingerprints**: Use production keystore fingerprints in assetlinks.json

4. **Update Team ID**: Use your actual Apple Team ID in apple-app-site-association

5. **Test Thoroughly**: Test all deep link patterns on both platforms

6. **Monitor**: Set up analytics to track deep link usage and failures

## Additional Resources

- [Android App Links Documentation](https://developer.android.com/training/app-links)
- [iOS Universal Links Documentation](https://developer.apple.com/ios/universal-links/)
- [Flutter Deep Linking Guide](https://docs.flutter.dev/development/ui/navigation/deep-linking)
