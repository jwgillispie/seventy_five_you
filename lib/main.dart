import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:seventy_five_hard/features/presentation/login/bloc/login_bloc.dart';
import 'package:seventy_five_hard/features/presentation/pages/calendar.dart';
import 'package:seventy_five_hard/features/presentation/login/ui/login_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/gallery.dart';
import 'package:seventy_five_hard/features/presentation/pages/reminders_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/social_page.dart';
import 'package:seventy_five_hard/features/presentation/signup/bloc/signup_bloc.dart';
import 'package:seventy_five_hard/features/presentation/signup/ui/sign_up_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/user_metrics.dart';
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
import 'package:seventy_five_hard/features/presentation/widgets/new_navbar.dart';
import 'package:seventy_five_hard/firebase_options.dart';
import 'package:seventy_five_hard/navigation_service.dart';
import 'package:seventy_five_hard/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const App(),
    ),
  );
}
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SignupBloc>(create: (context) => SignupBloc()),
        BlocProvider<UserBloc>(create: (context) => UserBloc()),
        BlocProvider<LoginBloc>(create: (context) => LoginBloc()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: '75 Get Right',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.getTheme(Brightness.light),
            darkTheme: themeProvider.getTheme(Brightness.dark),
            themeMode: ThemeMode.system,
            initialRoute: '/login',  // Set initial route to login
            routes: {
              '/login': (context) => const LoginPage(),
              '/signup': (context) => const SignUpPage(),
              '/user_metrics': (context) => const UserMetricsPage(),
              '/reminders_setup': (context) => const RemindersSetupPage(),
              '/home': (context) => const MainScreenWrapper(
                    child: HomePage(),
                  ),
              "/diet": (context) => const MainScreenWrapper(
                    child: DietPage(),
                  ),
              "/workout1": (context) => const MainScreenWrapper(
                    child: WorkoutOnePage(),
                  ),
              "/workout2": (context) => const MainScreenWrapper(
                    child: WorkoutTwoPage(),
                  ),
              "/water": (context) => const MainScreenWrapper(
                    child: WaterPage(),
                  ),
              "/alcohol": (context) => const MainScreenWrapper(
                    child: AlcoholPage(),
                  ),
              "/tenpages": (context) => const MainScreenWrapper(
                    child: TenPagesPage(),
                  ),
              "/error": (context) => const ErrorPage(),
              "/profile": (context) => const MainScreenWrapper(
                    child: ProfilePage(),
                  ),
              "/calendar": (context) => const MainScreenWrapper(
                    child: CalendarPage(),
                  ),
              "/gallery": (context) => const MainScreenWrapper(
                    child: GalleryPage(),
                  ),
              "/social": (context) => MainScreenWrapper(
                    child: EnhancedSocialPage(),
                  ),
            },
          );
        },
      ),
    );
  }
}
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  Future<String> _checkUserSetupStatus(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/user/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        
        // Check setup state in order
        if (userData['height'] == null || userData['weight'] == null) {
          return '/user_metrics';
        }
        
        if (userData['reminders'] == null || (userData['reminders'] as List).isEmpty) {
          return '/reminders_setup';
        }
        
        return '/home';
      }
      return '/user_metrics'; // Default to start of setup if can't fetch user data
    } catch (e) {
      print('Error checking user setup status: $e');
      return '/user_metrics';
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    
    // First check if there's a current user
    if (auth.currentUser == null) {
      return const LoginPage();
    }

    // If there is a user, check their setup status
    return FutureBuilder<String>(
      future: _checkUserSetupStatus(auth.currentUser!.uid),
      builder: (context, setupSnapshot) {
        if (setupSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final nextRoute = setupSnapshot.data ?? '/user_metrics';
        
        // If we're going to home, use the wrapper
        if (nextRoute == '/home') {
          return const MainScreenWrapper(child: HomePage());
        }
        
        // For setup pages, return the appropriate page directly
        switch (nextRoute) {
          case '/user_metrics':
            return const UserMetricsPage();
          case '/reminders_setup':
            return const RemindersSetupPage();
          default:
            return const UserMetricsPage();
        }
      },
    );
  }
}
class MainScreenWrapper extends StatelessWidget {
  final Widget child;

  const MainScreenWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NewNavBar(),
    );
  }
}