import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'Curso.dart';

class SharedPrefUtils {
  // Saves a boolean value with the given key to SharedPreferences
  static Future<bool> saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(key, value);
  }

  // Saves an integer value with the given key to SharedPreferences
  static Future<bool> saveInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setInt(key, value);
  }

  // Saves a double value with the given key to SharedPreferences
  static Future<bool> saveDouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setDouble(key, value);
  }

  // Saves a string value with the given key to SharedPreferences
  static Future<bool> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  // Saves a list of strings with the given key to SharedPreferences
  static Future<bool> saveStringList(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setStringList(key, value);
  }

  // Retrieves a boolean value with the given key from SharedPreferences
  static Future<bool?> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  // Retrieves an integer value with the given key from SharedPreferences
  static Future<int?> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  // Retrieves a double value with the given key from SharedPreferences
  static Future<double?> getDouble(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  // Retrieves a string value with the given key from SharedPreferences
  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // Retrieves a list of strings with the given key from SharedPreferences
  static Future<List<String>?> getStringList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }

  // Removing data from SharedPreferences
  static Future<void> removeData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

// Clearing all data from SharedPreferences
  static Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Prints all key-value pairs stored in SharedPreferences
  static Future<void> printAllValues() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    print('All SharedPreferences values:');
    for (String key in keys) {
      final value = prefs.get(key);
      print('$key: $value');
    }
  }

  // Guarda una lista de Cursos en SharedPreferences
  static Future<bool> saveCourses(String key, List<Curso> courses) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> coursesJson = courses.map((course) => jsonEncode(course.toJson())).toList();
    return prefs.setStringList(key, coursesJson);
  }

  // Recupera una lista de Cursos de SharedPreferences
  static Future<List<Curso>> getCourses(String key) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? coursesJson = prefs.getStringList(key);
    if (coursesJson == null) {
      return [];
    }
    return coursesJson.map((courseJson) => Curso.fromJson(jsonDecode(courseJson))).toList();
  }


}
