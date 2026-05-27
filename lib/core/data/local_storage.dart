import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences _prefs;

  /// Initialize SharedPreferences - call this in main()
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save data
  static Future<void> write(String key, dynamic value) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    }
  }

  // Read data
  static String? readString(String key) => _prefs.getString(key);
  static int? readInt(String key) => _prefs.getInt(key);
  static bool? readBool(String key) => _prefs.getBool(key) ?? false;
  static double? readDouble(String key) => _prefs.getDouble(key);
  static List<String>? readStringList(String key) => _prefs.getStringList(key);

  // Remove data
  static Future<void> remove(String key) async => await _prefs.remove(key);

  // Clear all data
  static Future<void> clearAll() async => await _prefs.clear();
  
  // Check if key exists
  static bool hasKey(String key) => _prefs.containsKey(key);
}
