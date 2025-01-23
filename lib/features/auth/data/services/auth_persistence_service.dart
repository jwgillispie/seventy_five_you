// lib/features/auth/data/services/auth_persistence_service.dart

import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';
import 'dart:convert';

abstract class AuthPersistenceService {
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> clearUser();
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
}

class AuthPersistenceServiceImpl implements AuthPersistenceService {
  final SharedPreferences _prefs;
  static const String _userKey = 'user';
  static const String _tokenKey = 'token';

  AuthPersistenceServiceImpl(this._prefs);

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      await _prefs.setString(_userKey, json.encode(user.toJson()));
    } catch (e) {
      throw CacheException(message: 'Failed to save user');
    }
  }

  @override
  Future<UserModel?> getUser() async {
    try {
      final userString = _prefs.getString(_userKey);
      if (userString == null) return null;
      return UserModel.fromJson(json.decode(userString));
    } catch (e) {
      throw CacheException(message: 'Failed to get user');
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      await _prefs.remove(_userKey);
    } catch (e) {
      throw CacheException(message: 'Failed to clear user');
    }
  }

  @override
  Future<void> saveToken(String token) async {
    try {
      await _prefs.setString(_tokenKey, token);
    } catch (e) {
      throw CacheException(message: 'Failed to save token');
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return _prefs.getString(_tokenKey);
    } catch (e) {
      throw CacheException(message: 'Failed to get token');
    }
  }

  @override
  Future<void> clearToken() async {
    try {
      await _prefs.remove(_tokenKey);
    } catch (e) {
      throw CacheException(message: 'Failed to clear token');
    }
  }
}