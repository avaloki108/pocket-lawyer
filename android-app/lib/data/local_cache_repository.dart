import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../core/constants.dart';

class CacheEntry {
  final String data;
  final DateTime timestamp;

  CacheEntry(this.data, this.timestamp);

  factory CacheEntry.fromJson(String json) {
    final map = jsonDecode(json);
    return CacheEntry(map['data'], DateTime.parse(map['timestamp']));
  }

  String toJson() =>
      jsonEncode({'data': data, 'timestamp': timestamp.toIso8601String()});

  bool get isExpired =>
      DateTime.now().difference(timestamp) > AppConstants.cacheExpiration;
}

class LocalCacheRepository {
  static const String _cacheBox = 'cache_box';

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<String>(_cacheBox);
  }

  Future<String?> get(String key) async {
    final box = Hive.box<String>(_cacheBox);
    final cached = box.get(key);
    if (cached == null) return null;

    final entry = CacheEntry.fromJson(cached);
    if (entry.isExpired) {
      await delete(key);
      return null;
    }
    return entry.data;
  }

  Future<void> put(String key, String value) async {
    final box = Hive.box<String>(_cacheBox);
    final entry = CacheEntry(value, DateTime.now());
    await box.put(key, entry.toJson());
  }

  Future<void> delete(String key) async {
    final box = Hive.box<String>(_cacheBox);
    await box.delete(key);
  }

  Future<void> clearAll() async {
    final box = Hive.box<String>(_cacheBox);
    await box.clear();
  }

  Future<void> clearExpired() async {
    final box = Hive.box<String>(_cacheBox);
    final keysToDelete = <String>[];

    for (final key in box.keys) {
      final cached = box.get(key);
      if (cached != null) {
        final entry = CacheEntry.fromJson(cached);
        if (entry.isExpired) {
          keysToDelete.add(key);
        }
      }
    }

    for (final key in keysToDelete) {
      await box.delete(key);
    }
  }

  Future<int> getCacheSize() async {
    final box = Hive.box<String>(_cacheBox);
    return box.length;
  }
}
