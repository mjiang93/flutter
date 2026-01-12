import 'core/configs/flavor_config.dart';
import 'main.dart';

/// Production environment entry point
/// 
/// Run with: flutter run -t lib/main_prod.dart --release
/// Or: flutter build apk --flavor prod --release
void main() {
  // Initialize production flavor configuration
  FlavorConfig(
    flavor: Flavor.prod,
    apiBaseUrl: 'https://api.example.com',
    connectTimeout: const Duration(seconds: 3),
    receiveTimeout: const Duration(seconds: 10),
    enableDebugLog: false,
    encryptionKey: 'prod-encryption-key-32-chars',
  );

  // Run the app
  runEnterpriseApp(FlavorConfig.instance);
}
