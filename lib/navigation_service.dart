// lib/services/navigation_service.dart
import 'package:flutter/material.dart';

class NavigationService {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static const List<String> pagesWithoutNavBar = [
    '/login',
    '/signup',
  ];

  static void navigateToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }

  static void navigateToSignup(BuildContext context) {
    Navigator.pushNamed(context, '/signup');
  }

  static void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
      (route) => false,
    );
  }
}
