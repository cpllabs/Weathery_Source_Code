import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

class CacheManager {
  CacheManager._privateConstructor();

  static final CacheManager instance = CacheManager._privateConstructor();

  late Box _box;

  static const String _boxName = 'weatherCache';

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
  }

  Future<void> saveWeather(String latlong, Map<String, dynamic> jsonMap) async {
    try {
      jsonMap['created'] = DateTime.now().toIso8601String();
      final String jsonString = jsonEncode(jsonMap);
      await _box.put(latlong, jsonString);
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic>? getWeather(String latlong) {
    try {
      if (_box.containsKey(latlong)) {
        final Map<String, dynamic> jsonString = jsonDecode(_box.get(latlong));
        if (DateTime.now()
                .difference(DateTime.parse(jsonString['created']))
                .inSeconds >
            300) {
          _box.delete(latlong);
          return null;
        }
        return jsonString;
      }
      return null;
    } catch (e) {
      return null;
    }
  }


  Future<void> clearAll() async {
    _box.clear();
  }
}
