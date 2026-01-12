import 'package:isar/isar.dart';
import '../models/cached_request_isar_model.dart';

/// DAO for managing cached network requests in Isar
class CachedRequestIsarDao {
  final Isar _isar;

  CachedRequestIsarDao(this._isar);

  /// Save a failed request to cache
  Future<void> cacheRequest(CachedRequestIsarModel request) async {
    await _isar.writeTxn(() async {
      await _isar.cachedRequestIsarModels.put(request);
    });
  }

  /// Get all cached requests ordered by cached time (FIFO)
  Future<List<CachedRequestIsarModel>> getAllCachedRequests() async {
    return await _isar.cachedRequestIsarModels
        .where()
        .sortByCachedAt()
        .findAll();
  }

  /// Get cached requests that haven't exceeded max retries
  Future<List<CachedRequestIsarModel>> getRetryableRequests() async {
    final allRequests = await getAllCachedRequests();
    return allRequests
        .where((req) => req.retryCount < req.maxRetries)
        .toList();
  }

  /// Update retry count for a request
  Future<void> incrementRetryCount(String requestId) async {
    await _isar.writeTxn(() async {
      final request = await _isar.cachedRequestIsarModels
          .filter()
          .requestIdEqualTo(requestId)
          .findFirst();

      if (request != null) {
        request.retryCount++;
        await _isar.cachedRequestIsarModels.put(request);
      }
    });
  }

  /// Delete a cached request
  Future<void> deleteCachedRequest(String requestId) async {
    await _isar.writeTxn(() async {
      await _isar.cachedRequestIsarModels
          .filter()
          .requestIdEqualTo(requestId)
          .deleteAll();
    });
  }

  /// Clear all cached requests
  Future<void> clearAll() async {
    await _isar.writeTxn(() async {
      await _isar.cachedRequestIsarModels.clear();
    });
  }

  /// Get count of cached requests
  Future<int> getCount() async {
    return await _isar.cachedRequestIsarModels.count();
  }
}
