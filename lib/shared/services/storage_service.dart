
// lib/shared/services/storage_service.dart
import 'package:shared_preferences.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  static SharedPreferences? _prefs;

  factory StorageService() {
    return _instance;
  }

  StorageService._internal();

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> setString(String key, String value) async {
    return await _prefs?.setString(key, value) ?? false;
  }

  String? getString(String key) {
    return _prefs?.getString(key);
  }

  Future<bool> setBool(String key, bool value) async {
    return await _prefs?.setBool(key, value) ?? false;
  }

  bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  Future<bool> remove(String key) async {
    return await _prefs?.remove(key) ?? false;
  }

  Future<bool> clear() async {
    return await _prefs?.clear() ?? false;
  }
}