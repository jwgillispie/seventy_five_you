// lib/core/navigation/app_router.dart

import 'package:flutter/material.dart';
import 'package:seventy_five_hard/features/auth/presentation/pages/login_page.dart';
import 'package:seventy_five_hard/features/auth/presentation/pages/signup_page.dart';
import 'package:seventy_five_hard/shared/widgets/app_scaffold.dart';
import '../constants/route_constants.dart';

class AppRouter {
  static const String initial = RouteConstants.login;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteConstants.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
        
      case RouteConstants.signup:
        return MaterialPageRoute(builder: (_) => const SignupPage());
        
      case RouteConstants.home:
        return MaterialPageRoute(builder: (_) => const AppScaffold());
      
      case RouteConstants.profile:
        return MaterialPageRoute(builder: (_) => const AppScaffold(initialIndex: 3));
        
      case RouteConstants.settings:
        return MaterialPageRoute(builder: (_) => const AppScaffold(initialIndex: 3));
        
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