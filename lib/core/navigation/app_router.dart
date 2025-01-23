
// lib/core/navigation/app_router.dart

import 'package:flutter/material.dart';
import 'package:seventy_five_hard/features/home/ui/home_page.dart';
import '../constants/route_constants.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';

class AppRouter {
  static const String initial = RouteConstants.home;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteConstants.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
        
      case RouteConstants.signup:
        return MaterialPageRoute(builder: (_) => const SignupPage());
        
      case RouteConstants.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
        
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
