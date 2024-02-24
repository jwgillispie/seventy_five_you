import 'package:flutter/material.dart';
import 'package:seventy_five_hard/features/app/splash_screen/splash_screen.dart';
import 'package:seventy_five_hard/features/presentation/pages/calendar.dart';
import 'package:seventy_five_hard/features/presentation/pages/login_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/profile_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/sign_up_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/home_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/diet_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/sys_home_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/w1_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/w2_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/water_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/alcohol_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/ten_pages_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/error_page.dart';

class Routes {
  static const String splashScreen = '/';
  static const String login = '/login';
  static const String signUp = '/signUp';
  static const String home = '/home';
  static const String diet = '/diet';
  static const String workout1 = '/workout1';
  static const String workout2 = '/workout2';
  static const String water = '/water';
  static const String alcohol = '/alcohol';
  static const String tenPages = '/tenpages';
  static const String profile = '/profile';
  static const String calendar = '/calendar';
  static const String sysHomePage = '/sys_home_page';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case signUp:
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case diet:
        return MaterialPageRoute(builder: (_) => const DietPage());
      case workout1:
        return MaterialPageRoute(builder: (_) => const WorkoutOnePage());
      case workout2:
        return MaterialPageRoute(builder: (_) => const WorkoutTwoPage());
      case water:
        return MaterialPageRoute(builder: (_) => const WaterPage());
      case alcohol:
        return MaterialPageRoute(builder: (_) => const AlcoholPage());
      case tenPages:
        return MaterialPageRoute(builder: (_) => const TenPagesPage());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case calendar:
        return MaterialPageRoute(builder: (_) => const CalendarPage());
      case sysHomePage:
        return MaterialPageRoute(builder: (_) => const SysHomePage());
      default:
        // If there is no such named route, return an error page or a default page
        return MaterialPageRoute(builder: (_) => const ErrorPage());
    }
  }
}
