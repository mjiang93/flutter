# Final Verification Checklist

## Overview

This document provides a comprehensive checklist for final verification of the Enterprise Flutter Framework before production deployment.

## Build Verification

### Dev Flavor Build
- [ ] Build command executes successfully: `fvm flutter build apk --flavor dev -t lib/main_dev.dart`
- [ ] APK generated at: `build/app/outputs/flutter-apk/app-dev-release.apk`
- [ ] APK installs on Android device without errors
- [ ] App launches successfully
- [ ] App name displays as "Enterprise Flutter (Dev)"
- [ ] Application ID is `com.enterprise.flutter.dev`

### Staging Flavor Build
- [ ] Build command executes successfully: `fvm flutter build apk --flavor staging -t lib/main_staging.dart`
- [ ] APK generated at: `build/app/outputs/flutter-apk/app-staging-release.apk`
- [ ] APK installs on Android device without errors
- [ ] App launches successfully
- [ ] App name displays as "Enterprise Flutter (Staging)"
- [ ] Application ID is `com.enterprise.flutter.staging`

### Prod Flavor Build
- [ ] Build command executes successfully: `fvm flutter build apk --release --flavor prod --obfuscate --split-debug-info=build/app/outputs/symbols -t lib/main_prod.dart`
- [ ] APK generated at: `build/app/outputs/flutter-apk/app-prod-release.apk`
- [ ] Debug symbols generated at: `build/app/outputs/symbols/`
- [ ] APK installs on Android device without errors
- [ ] App launches successfully
- [ ] App name displays as "Enterprise Flutter"
- [ ] Application ID is `com.enterprise.flutter`
- [ ] Code obfuscation verified (decompiled APK shows obfuscated code)

## Core Features End-to-End Testing

### 1. Network Requests

#### Dev Environment
- [ ] API base URL is `https://dev-api.example.com`
- [ ] Request headers include: token, device-id, app-version, os-type, lang
- [ ] Non-GET requests are encrypted with AES
- [ ] Response code 200 is handled correctly (data parsed)
- [ ] Response code 401 redirects to login and clears user data
- [ ] Response code 403 shows permission denied dialog
- [ ] Response code 500/502/503/504 shows error page with retry
- [ ] Connection timeout throws NetworkException
- [ ] No internet connection throws NoInternetConnectionException
- [ ] Debug logs show request/response details

#### Staging Environment
- [ ] API base URL is `https://staging-api.example.com`
- [ ] All network features work as expected
- [ ] Debug logs are enabled

#### Prod Environment
- [ ] API base URL is `https://prod-api.example.com`
- [ ] All network features work as expected
- [ ] Debug logs are disabled (only error logs)
- [ ] Sensitive data is masked in logs

### 2. Offline Mode

- [ ] App detects network disconnection
- [ ] Toast notification shows "网络连接已断开"
- [ ] Failed requests are cached to Isar
- [ ] App switches to cached data when offline
- [ ] Network reconnection is detected
- [ ] Toast notification shows "网络已恢复"
- [ ] Cached requests are retried in order
- [ ] Analytics events are cached when offline
- [ ] Cached analytics events are uploaded when online

### 3. Local Storage

#### Isar Database
- [ ] User info is cached correctly
- [ ] User info can be retrieved from cache
- [ ] Message list is cached correctly
- [ ] Message list can be retrieved from cache
- [ ] Unread count is cached correctly
- [ ] Mark as read updates cache correctly
- [ ] Cache is cleared on logout

#### SharedPreferences
- [ ] Token is saved and retrieved correctly
- [ ] Token is encrypted before storage
- [ ] Theme mode is persisted correctly
- [ ] Language preference is persisted correctly
- [ ] Preferences survive app restart

### 4. Theme Switching

- [ ] Light theme displays correctly
- [ ] Dark theme displays correctly
- [ ] System theme follows device settings
- [ ] Custom theme with custom primary color works
- [ ] Theme change updates all UI components immediately
- [ ] Theme preference is persisted across app restarts
- [ ] Theme preview shows correct colors before applying
- [ ] Brand colors are applied correctly
- [ ] Functional colors (success, warning, error, info) display correctly
- [ ] Neutral colors (background, surface, text, divider) display correctly

### 5. Language Switching

- [ ] Chinese language displays correctly
- [ ] English language displays correctly
- [ ] Language change updates all text immediately (no restart required)
- [ ] Language preference is persisted across app restarts
- [ ] Translations are loaded from JSON files
- [ ] No hardcoded text strings in UI
- [ ] Plural forms work correctly (if applicable)
- [ ] Date/time formatting respects locale

### 6. Routing and Navigation

- [ ] All routes navigate correctly
- [ ] Deep links work (Android App Links)
- [ ] Deep links work (iOS Universal Links)
- [ ] Protected routes redirect to login when not authenticated
- [ ] AuthGuard intercepts unauthorized access
- [ ] Page transitions animate smoothly (300ms duration)
- [ ] Back navigation works correctly
- [ ] Navigation state is preserved correctly

### 7. State Management

#### Global State (GetX)
- [ ] User info state is global and persistent
- [ ] Theme state is global and persistent
- [ ] Network status state is global and reactive
- [ ] Unread message count is accessible globally

#### Page State (GetX Controllers)
- [ ] Home controller manages state correctly
- [ ] Message controller manages state correctly
- [ ] Mine controller manages state correctly
- [ ] Controllers are disposed when pages are destroyed
- [ ] Memory leaks are prevented (verified with DevTools)

#### Component State (Flutter Hooks)
- [ ] useState works correctly in components
- [ ] useEffect lifecycle works correctly
- [ ] useMemoized caches values correctly

### 8. Home Page

- [ ] Banner carousel displays correctly
- [ ] Banner auto-scrolls (if implemented)
- [ ] List items display correctly
- [ ] Pull-to-refresh works
- [ ] Load more works when scrolling to bottom
- [ ] Skeleton screen shows during initial load
- [ ] Empty state shows when no data
- [ ] Error state shows with retry button when load fails
- [ ] Item tap navigates to detail page
- [ ] Page view is tracked in analytics
- [ ] Page duration is calculated correctly

### 9. Message Page

- [ ] Message list displays correctly
- [ ] Unread messages show indicator
- [ ] Unread count badge shows on bottom tab
- [ ] Badge updates when messages are read
- [ ] Pull-to-refresh works
- [ ] Load more works when scrolling to bottom
- [ ] Message tap marks as read
- [ ] Message tap navigates to detail page
- [ ] Message detail displays correctly
- [ ] Offline cached messages are accessible
- [ ] Page view is tracked in analytics

### 10. Mine Page

- [ ] User info displays correctly (avatar, nickname, phone)
- [ ] Phone number is masked correctly
- [ ] Theme setting entry navigates to theme page
- [ ] Language setting entry navigates to language page
- [ ] Logout button shows confirmation dialog
- [ ] Logout clears all local data
- [ ] Logout navigates to login page
- [ ] User info is cached for offline access
- [ ] Page view is tracked in analytics

### 11. Analytics Tracking

- [ ] Firebase Analytics is initialized
- [ ] Page views are tracked automatically
- [ ] Page duration is calculated and logged
- [ ] Click events are tracked
- [ ] Custom events are tracked
- [ ] Event metadata includes timestamp and device_id
- [ ] Events follow naming convention: module_eventType
- [ ] Events are cached when offline
- [ ] Cached events are uploaded when online
- [ ] Analytics work in all flavors (dev, staging, prod)

### 12. Crash Reporting

- [ ] Firebase Crashlytics is initialized
- [ ] Flutter framework errors are captured (FlutterError.onError)
- [ ] Dart async errors are captured (runZonedGuarded)
- [ ] Crash reports include device info
- [ ] Crash reports include user ID (if logged in)
- [ ] Crash reports include app version
- [ ] Crash reports include flavor information
- [ ] Test crash is reported correctly
- [ ] Crash reports appear in Firebase Console
- [ ] Crash reports work in all flavors

### 13. Performance

- [ ] App startup time is acceptable (< 3 seconds)
- [ ] Home page loads quickly
- [ ] List scrolling is smooth (60 FPS)
- [ ] Image loading doesn't block UI
- [ ] Image loading pauses during scroll
- [ ] Image loading resumes after scroll stops
- [ ] Memory usage is reasonable (< 200MB)
- [ ] No memory leaks detected
- [ ] RepaintBoundary isolates repaint regions
- [ ] Const constructors are used for static widgets

### 14. Permissions

- [ ] Camera permission request shows explanation dialog
- [ ] Photo library permission request shows explanation dialog
- [ ] Location permission request shows explanation dialog
- [ ] Permission denial guides user to settings
- [ ] Android 14 permission grouping works correctly
- [ ] iOS 17 limited photo library access works

### 15. Deep Linking

#### Android App Links
- [ ] assetlinks.json is hosted at: `https://example.com/.well-known/assetlinks.json`
- [ ] Deep link opens app: `https://example.com/home`
- [ ] Deep link opens app: `https://example.com/message/123`
- [ ] Deep link opens app: `https://example.com/mine`
- [ ] App handles deep link parameters correctly

#### iOS Universal Links
- [ ] apple-app-site-association is hosted at: `https://example.com/.well-known/apple-app-site-association`
- [ ] Deep link opens app: `https://example.com/home`
- [ ] Deep link opens app: `https://example.com/message/123`
- [ ] Deep link opens app: `https://example.com/mine`
- [ ] App handles deep link parameters correctly

### 16. UI Components

- [ ] RefreshLoadMoreList works correctly
- [ ] EmptyWidget displays all four states (no data, network, error, permission)
- [ ] LoadingWidget displays correctly (global and local)
- [ ] SkeletonWidget shows shimmer effect
- [ ] ThemeSwitcherWidget allows theme selection
- [ ] BasePage renders correctly with AppBar
- [ ] All custom widgets render correctly

### 17. Code Quality

- [ ] `flutter analyze` passes with no errors
- [ ] `flutter analyze` passes with no warnings
- [ ] All public APIs have documentation comments
- [ ] Null safety is enforced (no ! operator abuse)
- [ ] No use of `print()` (LogUtil is used instead)
- [ ] Naming conventions are followed
- [ ] Code is properly formatted

### 18. Testing

- [ ] All unit tests pass: `flutter test`
- [ ] Test coverage is ≥ 80%: `flutter test --coverage`
- [ ] All widget tests pass
- [ ] Property-based tests pass (if implemented)
- [ ] Integration tests pass (if implemented)

### 19. Documentation

- [ ] README.md is complete and accurate
- [ ] Architecture diagram is included
- [ ] Setup guide is complete
- [ ] Usage examples are provided
- [ ] Troubleshooting guide is helpful
- [ ] API documentation is generated: `dartdoc`
- [ ] All guides are up to date

### 20. Security

- [ ] Sensitive data is encrypted (token, user info)
- [ ] API requests use HTTPS
- [ ] Request parameters are encrypted (non-GET)
- [ ] Response data is decrypted correctly
- [ ] ProGuard rules are configured for release builds
- [ ] Code obfuscation works in prod builds
- [ ] No sensitive data in logs (prod environment)
- [ ] Network security config is properly set

## Platform-Specific Verification

### Android
- [ ] Minimum SDK version is correct
- [ ] Target SDK version is correct
- [ ] All flavors build successfully
- [ ] App icons are correct for each flavor
- [ ] App names are correct for each flavor
- [ ] Permissions are declared in AndroidManifest.xml
- [ ] ProGuard rules don't break functionality
- [ ] APK size is reasonable

### iOS
- [ ] Minimum iOS version is correct
- [ ] All schemes build successfully
- [ ] App icons are correct for each flavor
- [ ] App names are correct for each flavor
- [ ] Permissions are declared in Info.plist
- [ ] Code signing is configured
- [ ] IPA size is reasonable

## Final Checks

- [ ] All tasks in tasks.md are completed
- [ ] All requirements are met
- [ ] All acceptance criteria are satisfied
- [ ] No critical bugs remain
- [ ] Performance is acceptable
- [ ] User experience is smooth
- [ ] App is ready for production deployment

## Sign-Off

- [ ] Development team approves
- [ ] QA team approves
- [ ] Product owner approves
- [ ] Ready for production release

## Notes

Use this space to document any issues found during verification and their resolutions:

---

**Date:** _______________

**Verified By:** _______________

**Status:** _______________

**Issues Found:** _______________

**Resolution:** _______________
