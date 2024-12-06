import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:seventy_five_hard/features/presentation/widgets/new_navbar.dart';
import 'package:seventy_five_hard/firebase_options.dart';
import 'package:seventy_five_hard/navigation_service.dart';
import 'package:seventy_five_hard/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SignupBloc>(
          create: (context) => SignupBloc(),
        ),
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(),
        ),
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(),
        ),
      ],
      child: MaterialApp(
        title: '75 Get Right',
        debugShowCheckedModeBanner: false,
        theme: SFThemes.lightTheme,
        darkTheme: SFThemes.darkTheme,
        themeMode: ThemeMode.dark,
        home: const AuthWrapper(),
        routes: {
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignUpPage(),
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
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const MainScreenWrapper(child: HomePage());
          }
          return const LoginPage();
        },
      ),
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
      bottomNavigationBar: NewNavBar(), // Remove the conditional here
    );
  }
}
