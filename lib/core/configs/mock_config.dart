/// Mock configuration for development/testing
/// 
/// Controls whether to use mock data or real API calls
class MockConfig {
  MockConfig._();

  /// Enable mock mode globally
  /// Set to true to use mock data instead of real API calls
  static const bool enableMockMode = true;

  /// Simulated network delay in milliseconds
  /// Helps test loading states and animations
  static const int mockNetworkDelayMs = 800;

  /// Enable mock data for user API
  static const bool enableUserMock = enableMockMode;

  /// Enable mock data for message API
  static const bool enableMessageMock = enableMockMode;
}
