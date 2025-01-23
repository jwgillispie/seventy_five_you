// lib/features/auth/data/datasources/auth_remote_datasource.dart

import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../models/user_model.dart';
import '../services/firebase_auth_service.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp(String email, String password, String username);
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Future<void> updateUserProfile(UserModel user);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuthService _firebaseAuth;
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl({
    required FirebaseAuthService firebaseAuth,
    required ApiClient apiClient,
  })  : _firebaseAuth = firebaseAuth,
        _apiClient = apiClient;

  @override
  Future<UserModel> signIn(String email, String password) async {
    try {
      final firebaseUser = await _firebaseAuth.signInWithEmailAndPassword(
        email,
        password,
      );

      final response = await _apiClient.get(
        '/user/${firebaseUser.uid}',
      );

      return UserModel.fromJson(response);
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signUp(String email, String password, String username) async {
    try {
      final firebaseUser = await _firebaseAuth.signUpWithEmailAndPassword(
        email,
        password,
      );

      final userData = UserModel(
        firebaseUid: firebaseUser.uid,
        email: email,
        displayName: username,
      );

      await _apiClient.post(
        '/user',
        body: userData.toJson(),
      );

      return userData;
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final firebaseUser = _firebaseAuth.getCurrentUser();
      if (firebaseUser == null) return null;

      final response = await _apiClient.get(
        '/user/${firebaseUser.uid}',
      );

      return UserModel.fromJson(response);
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<void> updateUserProfile(UserModel user) async {
    try {
      await _apiClient.put(
        '/user/${user.firebaseUid}',
        body: user.toJson(),
      );
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }
}