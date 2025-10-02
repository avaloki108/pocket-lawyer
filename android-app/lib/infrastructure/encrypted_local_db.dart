import 'package:hive/hive.dart';

class EncryptedLocalDb {
  static const String _settingsBox = 'settings_box';

  Future<void> init() async {
    // Hive is already initialized in LocalCacheRepository
    // This would be for additional encrypted boxes if needed
    await Hive.openBox<String>(_settingsBox);
  }

  Future<String?> getSetting(String key) async {
    final box = Hive.box<String>(_settingsBox);
    return box.get(key);
  }

  Future<void> saveSetting(String key, String value) async {
    final box = Hive.box<String>(_settingsBox);
    await box.put(key, value);
  }
}
