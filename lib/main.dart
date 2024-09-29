// ignore_for_file: prefer_const_constructors
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:seventy_five_hard/features/app/splash_screen/splash_screen.dart';
import 'package:seventy_five_hard/features/presentation/pages/calendar.dart';
import 'package:seventy_five_hard/features/presentation/login/ui/login_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/gallery.dart';
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
import 'package:seventy_five_hard/firebase_options.dart';
import 'package:seventy_five_hard/themes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seventy_five_hard/features/presentation/login/bloc/login_bloc.dart';
import 'package:seventy_five_hard/features/presentation/signup/bloc/signup_bloc.dart';
import 'package:seventy_five_hard/features/presentation/users/bloc/user_bloc.dart';
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
      debugShowCheckedModeBanner: false,
      theme: SFThemes.lightTheme,
      darkTheme: SFThemes.darkTheme,
      themeMode: ThemeMode.dark,
      title: '75 Get Right',
      routes: {
        '/': (context) => SplashScreen(
              // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
              child: SignUpPage(),
            ),
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        "/diet": (context) => DietPage(),
        "/workout1": (context) => WorkoutOnePage(),
        "/workout2": (context) => WorkoutTwoPage(),
        "/water": (context) => WaterPage(),
        "/alcohol": (context) => AlcoholPage(),
        "/tenpages": (context) => TenPagesPage(),
        "/error": (context) => ErrorPage(),
        "/profile": (context) => ProfilePage(),
        "/calendar": (context) => CalendarPage(),
        "/gallery": (context) => GalleryPage(),
      },
    ));
  }
}
