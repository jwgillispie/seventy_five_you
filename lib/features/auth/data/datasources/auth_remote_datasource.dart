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
    print("AuthRemoteDataSource: Attempting to sign in with email: $email");
    try {
      // Step 1: Authenticate with Firebase
      print("AuthRemoteDataSource: Calling Firebase signIn");
      final firebaseUser = await _firebaseAuth.signInWithEmailAndPassword(
        email,
        password,
      );
      
      print("AuthRemoteDataSource: Firebase authentication successful for user: ${firebaseUser.uid}");

      // Step 2: Try to get user from API
      try {
        print("AuthRemoteDataSource: Attempting to get user data from API for uid: ${firebaseUser.uid}");
        final response = await _apiClient.get(
          '/user/${firebaseUser.uid}',
        );
        print("AuthRemoteDataSource: API response successful: $response");
        return UserModel.fromJson(response);
      } catch (apiError) {
        // If API fails, return a basic user model
        print("AuthRemoteDataSource: API request failed: $apiError, creating basic user model");
        return UserModel(
          firebaseUid: firebaseUser.uid,
          email: email,
          displayName: firebaseUser.displayName ?? email.split('@')[0],
        );
      }
    } catch (e) {
      print("AuthRemoteDataSource: Authentication failed: $e");
      throw AuthException(message: 'Authentication failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signUp(String email, String password, String username) async {
    print("AuthRemoteDataSource: Attempting to sign up with email: $email, username: $username");
    try {
      // Step 1: Create user with Firebase
      print("AuthRemoteDataSource: Calling Firebase signUp");
      final firebaseUser = await _firebaseAuth.signUpWithEmailAndPassword(
        email,
        password,
      );
      
      print("AuthRemoteDataSource: Firebase user creation successful for uid: ${firebaseUser.uid}");

      final userData = UserModel(
        firebaseUid: firebaseUser.uid,
        email: email,
        displayName: username,
      );

      // Step 2: Create user in API
      try {
        print("AuthRemoteDataSource: Attempting to create user in API: ${userData.toJson()}");
        await _apiClient.post(
          '/user',
          body: userData.toJson(),
        );
        print("AuthRemoteDataSource: API user creation successful");
      } catch (apiError) {
        // If API fails, just log the error but continue
        print("AuthRemoteDataSource: Failed to create user in API: $apiError");
      }
      
      return userData;
    } catch (e) {
      print("AuthRemoteDataSource: Sign up failed: $e");
      throw AuthException(message: 'Sign up failed: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    print("AuthRemoteDataSource: Attempting to sign out");
    try {
      await _firebaseAuth.signOut();
      print("AuthRemoteDataSource: Sign out successful");
    } catch (e) {
      print("AuthRemoteDataSource: Sign out failed: $e");
      throw AuthException(message: 'Sign out failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    print("AuthRemoteDataSource: Getting current user");
    try {
      final firebaseUser = _firebaseAuth.getCurrentUser();
      if (firebaseUser == null) {
        print("AuthRemoteDataSource: No current user found in Firebase");
        return null;
      }

      print("AuthRemoteDataSource: Current Firebase user: ${firebaseUser.uid}");
      
      try {
        print("AuthRemoteDataSource: Attempting to get user data from API");
        final response = await _apiClient.get(
          '/user/${firebaseUser.uid}',
        );
        print("AuthRemoteDataSource: API response successful");
        return UserModel.fromJson(response);
      } catch (apiError) {
        // If API fails, return a basic user model
        print("AuthRemoteDataSource: API request failed: $apiError, creating basic user model");
        return UserModel(
          firebaseUid: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName ?? 'User',
        );
      }
    } catch (e) {
      print("AuthRemoteDataSource: Get current user failed: $e");
      throw AuthException(message: 'Get current user failed: ${e.toString()}');
    }
  }

  @override
  Future<void> updateUserProfile(UserModel user) async {
    print("AuthRemoteDataSource: Updating user profile for uid: ${user.firebaseUid}");
    try {
      print("AuthRemoteDataSource: Making API request with data: ${user.toJson()}");
      await _apiClient.put(
        '/user/${user.firebaseUid}',
        body: user.toJson(),
      );
      print("AuthRemoteDataSource: Profile update successful");
    } catch (e) {
      print("AuthRemoteDataSource: Update profile failed: $e");
      throw AuthException(message: 'Update profile failed: ${e.toString()}');
    }
  }
}