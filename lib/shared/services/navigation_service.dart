
// lib/shared/services/navigation_service.dart
import 'package:flutter/material.dart';

class NavigationService {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static void pushNamed(String routeName, {Object? arguments}) {
    navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  static void pushReplacementNamed(String routeName, {Object? arguments}) {
    navigatorKey.currentState?.pushReplacementNamed(routeName, arguments: arguments);
  }

  static void pop<T>([T? result]) {
    navigatorKey.currentState?.pop(result);
  }

  static void pushNamedAndRemoveUntil(String routeName, {Object? arguments}) {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }
}
