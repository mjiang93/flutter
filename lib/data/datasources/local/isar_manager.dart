import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'models/user_isar_model.dart';
import 'models/message_isar_model.dart';
import 'models/cached_request_isar_model.dart';

/// Isar database manager
/// 
/// Manages Isar database instance and lifecycle
class IsarManager {
  static Isar? _instance;

  /// Get Isar instance (singleton)
  static Future<Isar> get instance async {
    if (_instance != null) return _instance!;

    final dir = await getApplicationDocumentsDirectory();
    _instance = await Isar.open(
      [
        UserIsarModelSchema,
        MessageIsarModelSchema,
        CachedRequestIsarModelSchema,
      ],
      directory: dir.path,
      inspector: true, // Enable Isar Inspector in debug mode
    );

    return _instance!;
  }

  /// Close Isar instance
  static Future<void> close() async {
    await _instance?.close();
    _instance = null;
  }

  /// Clear all data
  static Future<void> clearAll() async {
    final isar = await instance;
    await isar.writeTxn(() async {
      await isar.clear();
    });
  }
}
