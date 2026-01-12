import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import '../../../core/utils/log_util.dart';
import '../../datasources/local/dao/cached_request_isar_dao.dart';
import '../../datasources/local/models/cached_request_isar_model.dart';

/// Service for caching and retrying failed network requests
class RequestCacheService {
  final CachedRequestIsarDao _dao;
  final Dio _dio;

  RequestCacheService(this._dao, this._dio);

  /// Cache a failed request
  Future<void> cacheFailedRequest(RequestOptions options) async {
    try {
      final cachedRequest = CachedRequestIsarModel()
        ..requestId = const Uuid().v4()
        ..method = options.method
        ..url = options.uri.toString()
        ..headers = jsonEncode(options.headers)
        ..body = options.data != null ? jsonEncode(options.data) : null
        ..cachedAt = DateTime.now()
        ..retryCount = 0
        ..maxRetries = 3;

      await _dao.cacheRequest(cachedRequest);
      LogUtil.i('Cached failed request: ${options.method} ${options.uri}');
    } catch (e) {
      LogUtil.e('Failed to cache request', e);
    }
  }

  /// Retry all cached requests
  /// 
  /// Returns the number of successfully retried requests
  Future<int> retryAllCachedRequests() async {
    try {
      final requests = await _dao.getRetryableRequests();
      if (requests.isEmpty) {
        return 0;
      }

      LogUtil.i('Retrying ${requests.length} cached requests');
      int successCount = 0;

      // Retry requests in order (FIFO)
      for (final request in requests) {
        final success = await _retryRequest(request);
        if (success) {
          successCount++;
          await _dao.deleteCachedRequest(request.requestId);
        } else {
          await _dao.incrementRetryCount(request.requestId);
        }
      }

      LogUtil.i('Successfully retried $successCount/${requests.length} requests');
      return successCount;
    } catch (e) {
      LogUtil.e('Failed to retry cached requests', e);
      return 0;
    }
  }

  /// Retry a single cached request
  Future<bool> _retryRequest(CachedRequestIsarModel request) async {
    try {
      final options = Options(
        method: request.method,
        headers: request.headers != null
            ? Map<String, dynamic>.from(jsonDecode(request.headers!))
            : null,
      );

      final response = await _dio.request(
        request.url,
        options: options,
        data: request.body != null ? jsonDecode(request.body!) : null,
      );

      return response.statusCode == 200;
    } catch (e) {
      LogUtil.w('Failed to retry request: ${request.method} ${request.url}', e);
      return false;
    }
  }

  /// Get count of cached requests
  Future<int> getCachedRequestCount() async {
    return await _dao.getCount();
  }

  /// Clear all cached requests
  Future<void> clearAllCachedRequests() async {
    await _dao.clearAll();
  }
}
