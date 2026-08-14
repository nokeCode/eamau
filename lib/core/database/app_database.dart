// Minimal AppDatabase skeleton for Offline-First architecture
// TODO: implement with Drift tables and migrations

class AppDatabase {
  AppDatabase._();

  static final AppDatabase _instance = AppDatabase._();

  factory AppDatabase() => _instance;

  /// Initialize the database (Drift) -- to be implemented
  static Future<AppDatabase> init() async {
    // TODO: open connection using Drift + sqlite3_flutter_libs
    return _instance;
  }

  /// Placeholder close
  Future<void> close() async {}
}
