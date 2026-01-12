import 'dart:async';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'core/configs/flavor_config.dart';
import 'core/services/analytics_manager.dart';
import 'core/utils/log_util.dart';
import 'data/datasources/local/sp_manager.dart';
import 'data/datasources/remote/services/request_cache_service.dart';
import 'firebase_options.dart';
import 'injection/locator.dart';
import 'presentation/controllers/network_controller.dart';
import 'presentation/controllers/theme_controller.dart';
import 'presentation/pages/main_tab_page.dart';
import 'presentation/theme/app_theme.dart';

/// Main entry point for the application
/// 
/// This file should not be run directly. Use flavor-specific entry points:
/// - main_dev.dart for development
/// - main_test.dart for testing
/// - main_prod.dart for production
Future<void> main() async {
  // This is a placeholder. Use flavor-specific entry points.
  throw UnsupportedError(
    'Do not run main.dart directly. '
    'Use main_dev.dart, main_test.dart, or main_prod.dart instead.',
  );
}

/// Initialize and run the application
/// 
/// This function is called by flavor-specific entry points
Future<void> runEnterpriseApp(FlavorConfig config) async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations (portrait only)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // CRITICAL: Initialize only essential components before app starts
  // Initialize dependency injection (required for app to function)
  await setupLocator();

  // Load saved language preference (required for localization)
  final savedLanguage = await _loadSavedLanguage();

  // Initialize global controllers (required for app state)
  Get.put(ThemeController(), permanent: true);
  Get.put(
    NetworkController(requestCacheService: getIt<RequestCacheService>()),
    permanent: true,
  );

  // Initialize EasyLocalization (required for UI text)
  await EasyLocalization.ensureInitialized();

  // Run the app immediately - don't wait for non-critical services
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('zh'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: savedLanguage,
      child: const MyApp(),
    ),
  );

  // NON-CRITICAL: Initialize after first frame is rendered
  // This improves perceived startup time
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _initializeNonCriticalServices();
  });
}

/// Initialize non-critical services after the first frame
/// 
/// This improves startup performance by deferring initialization
/// of services that aren't immediately needed
Future<void> _initializeNonCriticalServices() async {
  try {
    LogUtil.d('Initializing non-critical services...');

    // Initialize Firebase (for analytics and crashlytics)
    await _initializeFirebase();

    // Set up error handling (must be after Firebase initialization)
    await _setupErrorHandling();

    // Initialize Analytics
    await AnalyticsManager.initialize();

    // Preload home page data in background
    _preloadHomeData();

    LogUtil.i('Non-critical services initialized successfully');
  } catch (e, stackTrace) {
    LogUtil.e('Failed to initialize non-critical services', e, stackTrace);
    // Don't crash the app if non-critical services fail
  }
}

/// Preload home page data in the background
/// 
/// This improves the user experience by having data ready
/// when the user navigates to the home page
void _preloadHomeData() {
  // Use Future.delayed to avoid blocking the UI thread
  Future.delayed(const Duration(milliseconds: 500), () async {
    try {
      LogUtil.d('Preloading home page data...');
      
      // TODO: Implement actual home data preloading
      // Example:
      // final homeUseCase = getIt<GetHomeDataUseCase>();
      // await homeUseCase(page: 1);
      
      LogUtil.i('Home page data preloaded successfully');
    } catch (e, stackTrace) {
      LogUtil.e('Failed to preload home data', e, stackTrace);
      // Don't crash if preloading fails - data will be loaded on demand
    }
  });
}

/// Main app widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      return GetMaterialApp(
        title: 'Enterprise Flutter App',
        debugShowCheckedModeBanner: false,
        
        // Localization configuration
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        
        // Theme configuration
        theme: _getTheme(themeController),
        darkTheme: AppTheme.darkTheme,
        themeMode: _getThemeMode(themeController.themeMode),
        
        // Initial route - Main tab page
        home: const MainTabPage(),
        
        // GetX configuration
        defaultTransition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 300),
        
        // Firebase Analytics navigation observer
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
        ],
        
        // Builder for global widgets (e.g., loading overlay)
        builder: (context, child) {
          return MediaQuery(
            // Prevent text scaling from system settings
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: 1.0,
            ),
            child: child ?? const SizedBox.shrink(),
          );
        },
      );
    });
  }

  /// Get theme based on theme mode
  ThemeData _getTheme(ThemeController controller) {
    if (controller.themeMode == AppThemeMode.custom && 
        controller.customPrimaryColor != null) {
      return AppTheme.customTheme(primaryColor: controller.customPrimaryColor!);
    }
    return AppTheme.lightTheme;
  }

  /// Convert AppThemeMode to Flutter ThemeMode
  ThemeMode _getThemeMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.custom:
        return ThemeMode.light;
    }
  }
}

/// Initialize Firebase
/// 
/// Initializes Firebase Core and configures Crashlytics
Future<void> _initializeFirebase() async {
  try {
    // Initialize Firebase with platform-specific options
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    LogUtil.i('Firebase initialized successfully');

    // Configure Crashlytics
    // Pass all uncaught "fatal" errors from the framework to Crashlytics
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    // Set custom keys for crash reports
    await FirebaseCrashlytics.instance.setCustomKey('flavor', FlavorConfig.instance.flavor.name);
    await FirebaseCrashlytics.instance.setCustomKey('app_version', '1.0.0'); // TODO: Get from package_info

    LogUtil.i('Crashlytics configured successfully');
  } catch (e, stackTrace) {
    LogUtil.e('Failed to initialize Firebase', e, stackTrace);
    // Don't rethrow - app should continue even if Firebase fails
  }
}

/// Set up global error handling
Future<void> _setupErrorHandling() async {
  // Catch Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    LogUtil.e(
      'Flutter error: ${details.exception}',
      details.exception,
      details.stack,
    );

    // Report to Crashlytics
    FirebaseCrashlytics.instance.recordFlutterFatalError(details);
  };

  // Catch Dart async errors
  PlatformDispatcher.instance.onError = (error, stack) {
    LogUtil.e('Async error: $error', error, stack);

    // Report to Crashlytics
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);

    return true;
  };
}

/// Load saved language preference from SharedPreferences
/// 
/// Returns the saved locale or null to use the fallback locale
Future<Locale?> _loadSavedLanguage() async {
  try {
    final languageCode = await SPManager.getLanguage();
    if (languageCode != null) {
      LogUtil.d('Loaded saved language: $languageCode');
      return Locale(languageCode);
    }
  } catch (e) {
    LogUtil.e('Failed to load saved language', e);
  }
  return null;
}


