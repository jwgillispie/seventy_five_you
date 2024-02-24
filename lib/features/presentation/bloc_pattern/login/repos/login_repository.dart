import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import "dart:async";
import 'package:seventy_five_hard/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:flutter/src/widgets/framework.dart';

class LoginRepository {
  static const String baseUrl = 'http://10.0.2.2:8000';
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
  };
  var _isLoading = false;
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> signIn(
      String firebaseUid, String email, String password) async {    try {
      await _auth.signInWithEmailAndPassword(email, password);
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      print("Error during sign in: $e");
    }
    User? user = await _auth.signInWithEmailAndPassword(email, password);

    if (user != null) {
      Fluttertoast.showToast(msg: "Hello motherfucker");
    }
  }


}
