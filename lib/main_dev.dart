import 'core/configs/flavor_config.dart';
import 'main.dart';

/// Development environment entry point
/// 
/// Run with: flutter run -t lib/main_dev.dart
/// Or: flutter run --flavor dev
void main() {
  // Initialize development flavor configuration
  FlavorConfig(
    flavor: Flavor.dev,
    apiBaseUrl: 'https://dev-api.example.com',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 15),
    enableDebugLog: true,
    encryptionKey: 'dev-encryption-key-32-chars!!',
  );

  // Run the app
  runEnterpriseApp(FlavorConfig.instance);
}
