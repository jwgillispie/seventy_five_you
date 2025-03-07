// lib/features/auth/data/services/firebase_auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../../core/errors/exceptions.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth;

  FirebaseAuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  Future<User> signUpWithEmailAndPassword(String email, String password) async {
    print("FirebaseAuthService: Attempting signUp with email: $email");
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user == null) {
        print("FirebaseAuthService: Failed to create user account - user is null");
        throw AuthException(message: 'Failed to create user account');
      }
      
      print("FirebaseAuthService: Successfully created user: ${credential.user!.uid}");
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      
      print("FirebaseAuthService: Firebase Auth Exception: ${e.code} - ${e.message}");
      
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          errorMessage = 'The account already exists for that email.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled.';
          break;
        default:
          errorMessage = 'An error occurred during sign up: ${e.message}';
      }
      
      print("FirebaseAuthService: Throwing AuthException with message: $errorMessage");
      Fluttertoast.showToast(msg: errorMessage);
      throw AuthException(message: errorMessage);
    } catch (e) {
      const errorMessage = 'An unexpected error occurred';
      print("FirebaseAuthService: Unexpected error during signUp: $e");
      Fluttertoast.showToast(msg: errorMessage);
      throw AuthException(message: errorMessage);
    }
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    print("FirebaseAuthService: Attempting signIn with email: $email");
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user == null) {
        print("FirebaseAuthService: Failed to sign in - user is null");
        throw AuthException(message: 'Failed to sign in');
      }
      
      print("FirebaseAuthService: Successfully signed in user: ${credential.user!.uid}");
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      
      print("FirebaseAuthService: Firebase Auth Exception: ${e.code} - ${e.message}");
      
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided for that user.';
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        default:
          errorMessage = 'An error occurred during sign in: ${e.message}';
      }
      
      print("FirebaseAuthService: Throwing AuthException with message: $errorMessage");
      Fluttertoast.showToast(msg: errorMessage);
      throw AuthException(message: errorMessage);
    } catch (e) {
      const errorMessage = 'An unexpected error occurred';
      print("FirebaseAuthService: Unexpected error during signIn: $e");
      Fluttertoast.showToast(msg: errorMessage);
      throw AuthException(message: errorMessage);
    }
  }

  Future<void> signOut() async {
    print("FirebaseAuthService: Attempting to sign out");
    try {
      await _auth.signOut();
      print("FirebaseAuthService: Successfully signed out");
    } catch (e) {
      const errorMessage = 'Failed to sign out';
      print("FirebaseAuthService: Error during signOut: $e");
      Fluttertoast.showToast(msg: errorMessage);
      throw AuthException(message: errorMessage);
    }
  }

  User? getCurrentUser() {
    final user = _auth.currentUser;
    print("FirebaseAuthService: getCurrentUser: ${user?.uid ?? 'No current user'}");
    return user;
  }

  Stream<User?> get authStateChanges {
    print("FirebaseAuthService: Listening to authStateChanges");
    return _auth.authStateChanges();
  }
}