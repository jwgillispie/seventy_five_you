//lib/features/auth/data/datasources/auth_remote_datasource.dart

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp(String email, String password, String username);
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Future<void> updateUserProfile(UserModel user);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl({
    required firebase_auth.FirebaseAuth firebaseAuth,
    required ApiClient apiClient,
  }) : _firebaseAuth = firebaseAuth,
       _apiClient = apiClient;

  @override
  Future<UserModel> signIn(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw AuthException(message: 'Sign in failed');
      }

      final response = await _apiClient.get(
        '/user/${userCredential.user!.uid}',
      );

      return UserModel.fromJson(response);
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signUp(String email, String password, String username) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw AuthException(message: 'Sign up failed');
      }

      final userData = UserModel(
        firebaseUid: userCredential.user!.uid,
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
      final firebaseUser = _firebaseAuth.currentUser;
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