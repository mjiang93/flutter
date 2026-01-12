import 'core/configs/flavor_config.dart';
import 'main.dart';

/// Staging environment entry point
/// 
/// Run with: flutter run -t lib/main_staging.dart
/// Or: flutter run --flavor staging
void main() {
  // Initialize staging flavor configuration
  FlavorConfig(
    flavor: Flavor.staging,
    apiBaseUrl: 'https://staging-api.example.com',
    connectTimeout: const Duration(seconds: 3),
    receiveTimeout: const Duration(seconds: 10),
    enableDebugLog: true,
    encryptionKey: 'staging-encryption-key-32-ch',
  );

  // Run the app
  runEnterpriseApp(FlavorConfig.instance);
}
