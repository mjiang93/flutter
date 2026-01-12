import 'package:isar/isar.dart';

part 'cached_request_isar_model.g.dart';

/// Isar model for caching failed network requests
/// 
/// Stores request information to retry when network is restored
@collection
class CachedRequestIsarModel {
  Id id = Isar.autoIncrement;

  /// Unique request ID
  @Index(unique: true)
  late String requestId;

  /// HTTP method (GET, POST, PUT, DELETE, etc.)
  late String method;

  /// Request URL
  late String url;

  /// Request headers as JSON string
  String? headers;

  /// Request body as JSON string
  String? body;

  /// Timestamp when request was cached
  @Index()
  late DateTime cachedAt;

  /// Number of retry attempts
  late int retryCount;

  /// Maximum retry attempts
  late int maxRetries;
}
