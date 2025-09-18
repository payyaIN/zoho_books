import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static late SharedPreferences _prefs;

  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save a string value
  static Future<void> saveString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  // Get a string value
  static String? getString(String key) {
    return _prefs.getString(key);
  }

  // Save an integer value
  static Future<void> saveInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  // Get an integer value
  static int? getInt(String key) {
    return _prefs.getInt(key);
  }

  // Save a boolean value
  static Future<void> saveBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  // Get a boolean value
  static bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  // Save a double value
  static Future<void> saveDouble(String key, double value) async {
    await _prefs.setDouble(key, value);
  }

  // Get a double value
  static double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  // Save a list of strings
  static Future<void> saveStringList(String key, List<String> value) async {
    await _prefs.setStringList(key, value);
  }

  // Get a list of strings
  static List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  // Save an image as a Base64 string
  static Future<void> saveImage(String key, Uint8List imageData) async {
    final imageString = base64Encode(imageData);
    await _prefs.setString(key, imageString);
  }

  // Get an image as Uint8List
  static Uint8List? getImage(String key) {
    final imageString = _prefs.getString(key);
    if (imageString != null) {
      return base64Decode(imageString);
    }
    return null;
  }

  // Remove a value
  static Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  // Clear all data
  static Future<void> clear() async {
    await _prefs.clear();
  }
}
final sharedPreferencesProvider = Provider<SharedPreferencesHelper>((ref) {
  final service = SharedPreferencesHelper();
  SharedPreferencesHelper.init(); // Ensure initialization
  return service;
});