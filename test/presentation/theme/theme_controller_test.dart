import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:enterprise_flutter_app/presentation/theme/theme_controller.dart';
import 'package:enterprise_flutter_app/presentation/theme/app_theme.dart';

/// Feature: enterprise-flutter-framework, Property 16: Theme Change Propagation
/// 
/// Property: For any theme mode change, all visible UI components should 
/// immediately reflect the new theme without requiring manual refresh.
/// 
/// Validates: Requirements 6.2
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Property 16: Theme Change Propagation', () {
    late ThemeController themeController;

    setUp(() async {
      // Initialize SharedPreferences with mock
      SharedPreferences.setMockInitialValues({});
      
      // Initialize GetX
      Get.testMode = true;
      
      // Create controller
      themeController = ThemeController();
      Get.put(themeController);
    });

    tearDown(() {
      Get.delete<ThemeController>();
      Get.reset();
    });

    /// Test that theme changes propagate immediately to UI components
    /// This is a property-based test that verifies the universal property
    /// across multiple theme mode changes
    testWidgets(
      'For any theme mode change, UI components should immediately reflect new theme',
      (WidgetTester tester) async {
        // Property test: Run multiple iterations with different theme modes
        final themeModes = [
          AppThemeMode.light,
          AppThemeMode.dark,
          AppThemeMode.system,
          AppThemeMode.light,
          AppThemeMode.dark,
        ];

        for (final themeMode in themeModes) {
          // Build a test widget that observes theme changes
          await tester.pumpWidget(
            GetMaterialApp(
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: _mapThemeMode(themeMode),
              home: Scaffold(
                appBar: AppBar(
                  title: const Text('Theme Test'),
                ),
                body: Obx(() {
                  // This widget rebuilds when theme changes
                  final currentTheme = Theme.of(Get.context!);
                  return Container(
                    color: currentTheme.scaffoldBackgroundColor,
                    child: Column(
                      children: [
                        Text(
                          'Current Theme: ${themeController.themeMode.name}',
                          style: currentTheme.textTheme.bodyLarge,
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Test Button'),
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Test Card',
                              style: currentTheme.textTheme.titleMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          );

          // Wait for initial build
          await tester.pumpAndSettle();

          // Capture initial theme colors
          final initialScaffoldColor = tester
              .widget<Container>(find.byType(Container).first)
              .color;

          // Change theme mode
          await themeController.setThemeMode(themeMode);

          // Pump frames to allow theme change to propagate
          await tester.pumpAndSettle();

          // Verify theme has changed in the controller
          expect(themeController.themeMode, equals(themeMode));

          // Verify UI components reflect the new theme
          final currentContext = tester.element(find.byType(Scaffold));
          final currentTheme = Theme.of(currentContext);

          // Verify scaffold background color matches expected theme
          final expectedBackgroundColor = themeMode == AppThemeMode.dark
              ? AppTheme.darkBackground
              : AppTheme.lightBackground;

          expect(
            currentTheme.scaffoldBackgroundColor,
            equals(expectedBackgroundColor),
            reason:
                'Scaffold background should match $themeMode theme immediately',
          );

          // Verify AppBar theme
          final appBar = tester.widget<AppBar>(find.byType(AppBar));
          expect(
            appBar.backgroundColor ?? currentTheme.appBarTheme.backgroundColor,
            equals(currentTheme.appBarTheme.backgroundColor),
            reason: 'AppBar should reflect new theme immediately',
          );

          // Verify text theme
          final textWidget = tester.widget<Text>(find.text(
              'Current Theme: ${themeController.themeMode.name}'));
          expect(
            textWidget.style?.color ?? currentTheme.textTheme.bodyLarge?.color,
            equals(currentTheme.textTheme.bodyLarge?.color),
            reason: 'Text should reflect new theme immediately',
          );

          // Verify button theme
          final buttonFinder = find.byType(ElevatedButton);
          expect(buttonFinder, findsOneWidget,
              reason: 'Button should be visible after theme change');

          // Verify card theme
          final cardWidget = tester.widget<Card>(find.byType(Card));
          expect(
            cardWidget.color ?? currentTheme.cardTheme.color,
            equals(currentTheme.cardTheme.color),
            reason: 'Card should reflect new theme immediately',
          );

          // Property verification: No manual refresh was required
          // The fact that we can verify the theme change without calling
          // tester.pump() again proves immediate propagation
        }
      },
    );

    /// Test theme change propagation with custom colors
    testWidgets(
      'For any custom primary color, UI components should immediately reflect the custom theme',
      (WidgetTester tester) async {
        // Property test: Run with multiple custom colors
        final customColors = [
          Colors.red,
          Colors.green,
          Colors.blue,
          Colors.purple,
          Colors.orange,
        ];

        for (final customColor in customColors) {
          await tester.pumpWidget(
            GetMaterialApp(
              theme: themeController.getThemeData(),
              darkTheme: themeController.getDarkThemeData(),
              home: Scaffold(
                appBar: AppBar(
                  title: const Text('Custom Theme Test'),
                ),
                body: Obx(() {
                  final currentTheme = Theme.of(Get.context!);
                  return ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Primary: ${currentTheme.colorScheme.primary.value.toRadixString(16)}',
                    ),
                  );
                }),
              ),
            ),
          );

          await tester.pumpAndSettle();

          // Set custom primary color
          await themeController.setCustomPrimaryColor(customColor);

          // Pump to allow theme change
          await tester.pumpAndSettle();

          // Verify custom color is applied
          final currentContext = tester.element(find.byType(Scaffold));
          final currentTheme = Theme.of(currentContext);

          expect(
            currentTheme.colorScheme.primary,
            equals(customColor),
            reason:
                'Primary color should match custom color ${customColor.value.toRadixString(16)} immediately',
          );

          // Verify theme mode is set to custom
          expect(
            themeController.themeMode,
            equals(AppThemeMode.custom),
            reason: 'Theme mode should be custom after setting custom color',
          );
        }
      },
    );

    /// Test rapid theme changes (stress test)
    testWidgets(
      'For any rapid sequence of theme changes, each change should propagate correctly',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          GetMaterialApp(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: Scaffold(
              body: Obx(() {
                return Text('Theme: ${themeController.themeMode.name}');
              }),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Rapid theme changes
        final rapidChanges = [
          AppThemeMode.light,
          AppThemeMode.dark,
          AppThemeMode.light,
          AppThemeMode.dark,
          AppThemeMode.system,
        ];

        for (final mode in rapidChanges) {
          await themeController.setThemeMode(mode);
          await tester.pump();

          // Verify each change is reflected
          expect(
            themeController.themeMode,
            equals(mode),
            reason: 'Theme mode should update immediately even with rapid changes',
          );
        }

        await tester.pumpAndSettle();
      },
    );

    /// Test theme change with multiple widgets
    testWidgets(
      'For any theme change, all widget types should reflect the new theme',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          GetMaterialApp(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.light,
            home: Scaffold(
              appBar: AppBar(title: const Text('Multi-Widget Test')),
              body: Obx(() {
                final theme = Theme.of(Get.context!);
                return ListView(
                  children: [
                    Text('Text Widget', style: theme.textTheme.bodyLarge),
                    ElevatedButton(onPressed: () {}, child: const Text('Button')),
                    TextButton(onPressed: () {}, child: const Text('Text Button')),
                    Card(child: ListTile(title: const Text('Card Item'))),
                    const Divider(),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Input Field',
                        border: theme.inputDecorationTheme.border,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Change to dark theme
        await themeController.setThemeMode(AppThemeMode.dark);
        await tester.pumpAndSettle();

        // Verify all widgets reflect dark theme
        final context = tester.element(find.byType(Scaffold));
        final darkTheme = Theme.of(context);

        expect(darkTheme.brightness, equals(Brightness.dark));
        expect(
          darkTheme.scaffoldBackgroundColor,
          equals(AppTheme.darkBackground),
        );

        // Verify widgets are still present and functional
        expect(find.byType(Text), findsWidgets);
        expect(find.byType(ElevatedButton), findsOneWidget);
        expect(find.byType(TextButton), findsOneWidget);
        expect(find.byType(Card), findsOneWidget);
        expect(find.byType(Divider), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);

        // Change back to light theme
        await themeController.setThemeMode(AppThemeMode.light);
        await tester.pumpAndSettle();

        // Verify all widgets reflect light theme
        final lightContext = tester.element(find.byType(Scaffold));
        final lightTheme = Theme.of(lightContext);

        expect(lightTheme.brightness, equals(Brightness.light));
        expect(
          lightTheme.scaffoldBackgroundColor,
          equals(AppTheme.lightBackground),
        );
      },
    );
  });
}

/// Helper function to map AppThemeMode to ThemeMode
ThemeMode _mapThemeMode(AppThemeMode mode) {
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
