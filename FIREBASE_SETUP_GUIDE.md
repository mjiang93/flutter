# Firebase Setup Guide

This guide explains how to configure Firebase Analytics and Crashlytics for the Enterprise Flutter App.

## Prerequisites

- Firebase project created at [Firebase Console](https://console.firebase.google.com/)
- FlutterFire CLI installed: `dart pub global activate flutterfire_cli`
- Firebase CLI installed: `npm install -g firebase-tools`

## Setup Steps

### 1. Login to Firebase

```bash
firebase login
```

### 2. Configure FlutterFire

Run the FlutterFire configuration command:

```bash
flutterfire configure
```

This will:
- List your Firebase projects
- Let you select a project
- Generate `lib/firebase_options.dart` with your project configuration
- Configure Android and iOS apps automatically

### 3. Android Configuration

#### 3.1 Update `android/build.gradle.kts`

Add the Google Services classpath:

```kotlin
buildscript {
    dependencies {
        classpath("com.google.gms:google-services:4.4.0")
        classpath("com.google.firebase:firebase-crashlytics-gradle:2.9.9")
    }
}
```

#### 3.2 Update `android/app/build.gradle.kts`

Add the plugins at the top:

```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
}
```

### 4. iOS Configuration

#### 4.1 Add GoogleService-Info.plist

1. Download `GoogleService-Info.plist` from Firebase Console
2. Add it to `ios/Runner/` directory
3. Open `ios/Runner.xcworkspace` in Xcode
4. Drag `GoogleService-Info.plist` into the Runner target

#### 4.2 Update Podfile

Ensure minimum iOS version is 12.0 or higher:

```ruby
platform :ios, '12.0'
```

#### 4.3 Install Pods

```bash
cd ios
pod install
cd ..
```

### 5. Verify Installation

Run the app and check the logs:

```bash
flutter run --flavor dev
```

You should see:
```
Firebase initialized successfully
Crashlytics configured successfully
Analytics initialized with device ID: xxx
```

### 6. Test Crashlytics

Add a test crash button to verify Crashlytics is working:

```dart
ElevatedButton(
  onPressed: () {
    FirebaseCrashlytics.instance.crash();
  },
  child: Text('Test Crash'),
)
```

After triggering the crash, check the Firebase Console → Crashlytics to see the crash report.

### 7. Test Analytics

Analytics events are automatically logged. Check Firebase Console → Analytics → Events to see:
- `screen_view` events (automatic page tracking)
- Custom events logged via `AnalyticsManager.logEvent()`

## Features Implemented

### Analytics

- **Automatic Page View Tracking**: All pages extending `BasePage` automatically log page views
- **Page Duration Tracking**: Calculates and logs time spent on each page
- **Custom Event Tracking**: Use `AnalyticsManager.logEvent()` to track custom events
- **Metadata Enrichment**: All events include timestamp, device_id, app_version, and environment

### Crashlytics

- **Automatic Crash Reporting**: All uncaught exceptions are reported to Crashlytics
- **Flutter Error Reporting**: Flutter framework errors are captured
- **Async Error Reporting**: Dart async errors are captured
- **Custom Keys**: Crash reports include flavor and app_version
- **Manual Error Logging**: Use `LogUtil.e()` to log non-fatal errors

## Usage Examples

### Log Custom Event

```dart
AnalyticsManager.logEvent('button_click', {
  'button_name': 'login',
  'screen': 'login_page',
});
```

### Log Click Event

```dart
AnalyticsManager.logClick('submit_button', 'registration_page');
```

### Set User ID

```dart
AnalyticsManager.setUserId('user_123');
```

### Set User Property

```dart
AnalyticsManager.setUserProperty('user_type', 'premium');
```

### Log Non-Fatal Error

```dart
try {
  // Some operation
} catch (e, stackTrace) {
  LogUtil.e('Operation failed', e, stackTrace);
}
```

### Force Crash (Testing Only)

```dart
FirebaseCrashlytics.instance.crash();
```

## Environment-Specific Configuration

The app supports different Firebase projects for different environments:

- **Dev**: Use a separate Firebase project for development
- **Test**: Use a separate Firebase project for testing
- **Prod**: Use the production Firebase project

To configure multiple projects, run `flutterfire configure` for each flavor and update the Firebase options accordingly.

## Troubleshooting

### Firebase not initialized

**Error**: `[core/no-app] No Firebase App '[DEFAULT]' has been created`

**Solution**: Ensure `Firebase.initializeApp()` is called before any Firebase services are used.

### Crashlytics not reporting

**Error**: Crashes not appearing in Firebase Console

**Solution**:
1. Ensure you're running a release build: `flutter run --release`
2. Wait a few minutes for reports to appear
3. Check that `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) is properly configured

### Analytics events not appearing

**Error**: Events not showing in Firebase Console

**Solution**:
1. Wait up to 24 hours for events to appear in the console
2. Use DebugView in Firebase Console for real-time event monitoring
3. Enable debug mode:
   - Android: `adb shell setprop debug.firebase.analytics.app com.enterprise.flutter`
   - iOS: Add `-FIRAnalyticsDebugEnabled` to Xcode scheme arguments

## Best Practices

1. **Don't log sensitive data**: Never include passwords, tokens, or PII in analytics events
2. **Use consistent naming**: Follow the `snake_case` convention for event names
3. **Limit event parameters**: Keep event parameters under 25 per event
4. **Test in debug mode**: Use Firebase DebugView to verify events before production
5. **Monitor crash-free rate**: Aim for >99% crash-free users in production

## Additional Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Analytics Best Practices](https://firebase.google.com/docs/analytics/best-practices)
- [Crashlytics Documentation](https://firebase.google.com/docs/crashlytics)
