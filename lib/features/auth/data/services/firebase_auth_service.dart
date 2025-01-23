// lib/features/auth/data/services/firebase_auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../../core/errors/exceptions.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth;

  FirebaseAuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  Future<User> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user == null) {
        throw AuthException(message: 'Failed to create user account');
      }
      
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      
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
          errorMessage = 'An error occurred during sign up.';
      }
      
      Fluttertoast.showToast(msg: errorMessage);
      throw AuthException(message: errorMessage);
    } catch (e) {
      const errorMessage = 'An unexpected error occurred';
      Fluttertoast.showToast(msg: errorMessage);
      throw AuthException(message: errorMessage);
    }
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user == null) {
        throw AuthException(message: 'Failed to sign in');
      }
      
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      
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
          errorMessage = 'An error occurred during sign in.';
      }
      
      Fluttertoast.showToast(msg: errorMessage);
      throw AuthException(message: errorMessage);
    } catch (e) {
      const errorMessage = 'An unexpected error occurred';
      Fluttertoast.showToast(msg: errorMessage);
      throw AuthException(message: errorMessage);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      const errorMessage = 'Failed to sign out';
      Fluttertoast.showToast(msg: errorMessage);
      throw AuthException(message: errorMessage);
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}