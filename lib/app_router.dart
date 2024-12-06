// lib/navigation/app_router.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:seventy_five_hard/features/presentation/login/bloc/login_bloc.dart';
import 'package:seventy_five_hard/features/presentation/pages/calendar.dart';
import 'package:seventy_five_hard/features/presentation/login/ui/login_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/gallery.dart';
import 'package:seventy_five_hard/features/presentation/pages/social_page.dart';
import 'package:seventy_five_hard/features/presentation/signup/bloc/signup_bloc.dart';
import 'package:seventy_five_hard/features/presentation/signup/ui/sign_up_page.dart';
import 'package:seventy_five_hard/features/presentation/home/ui/home_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/diet_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/ten_pages_page.dart';
import 'package:seventy_five_hard/features/presentation/outside_workout/ui/w1_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/w2_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/water_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/alcohol_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/error_page.dart';
import 'package:seventy_five_hard/features/presentation/profile/ui/profile_page.dart';
import 'package:seventy_five_hard/features/presentation/users/bloc/user_bloc.dart';
import 'package:seventy_five_hard/firebase_options.dart';
import 'package:seventy_five_hard/main.dart';
import 'package:seventy_five_hard/navigation_service.dart';
import 'package:seventy_five_hard/themes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seventy_five_hard/features/presentation/widgets/new_navbar.dart';

class AppRouter {
  static final navigatorKey = GlobalKey<NavigatorState>();
  
  static const String initialRoute = '/';
  
  // Route names as static constants to prevent typos
  static const String home = '/home';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String profile = '/profile';
  static const String diet = '/diet';
  static const String workout1 = '/workout1';
  static const String workout2 = '/workout2';
  static const String water = '/water';
  static const String alcohol = '/alcohol';
  static const String tenPages = '/tenpages';
  static const String calendar = '/calendar';
  static const String gallery = '/gallery';
  static const String social = '/social';
  static const String error = '/error';

  // Routes that should not display the bottom navigation bar
  static final Set<String> pagesWithoutNavBar = {
    login,
    signup,
    error,
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return _buildRoute(const HomePage(), settings);
      case login:
        return _buildRoute(const LoginPage(), settings);
      case signup:
        return _buildRoute(const SignUpPage(), settings);
      case profile:
        return _buildRoute(const ProfilePage(), settings);
      case diet:
        return _buildRoute(const DietPage(), settings);
      case workout1:
        return _buildRoute(const WorkoutOnePage(), settings);
      case workout2:
        return _buildRoute(const WorkoutTwoPage(), settings);
      // ... other routes
      default:
        return _buildRoute(const ErrorPage(), settings);
    }
  }

  static MaterialPageRoute _buildRoute(Widget page, RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => _wrapWithNavBar(page, settings.name ?? ''),
      settings: settings,
    );
  }

  static Widget _wrapWithNavBar(Widget page, String routeName) {
    if (pagesWithoutNavBar.contains(routeName)) {
      return page;
    }
    return MainScreenWrapper(child: page);
  }

  // Navigation methods
  static Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  static Future<T?> pushReplacementNamed<T>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushReplacementNamed(routeName, arguments: arguments);
  }

  static void pop<T>([T? result]) {
    return navigatorKey.currentState!.pop(result);
  }

  static Future<T?> pushNamedAndRemoveUntil<T>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }
}