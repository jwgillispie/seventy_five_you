// ignore_for_file: prefer_const_constructors
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:seventy_five_hard/features/app/splash_screen/splash_screen.dart';
import 'package:seventy_five_hard/features/presentation/pages/calendar.dart';
import 'package:seventy_five_hard/features/presentation/pages/login_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/sandbox_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/sign_up_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/home_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/diet_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/ten_pages_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/w1_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/w2_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/water_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/alcohol_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/error_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/profile_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/sys_home_page.dart';
import 'package:seventy_five_hard/themes.dart';
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyBw3n69amusSnUqB1rzDOkv-MXw6ac01e8',
      appId: '1:493196103679:web:bc0eca400fc3279cfc21ca',
      messagingSenderId: '493196103679',
      projectId: 'seventyfiveyou',
      // storageBucket: 'seventyfiveyou.appspot.com',
    ),
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: SFThemes.lightTheme,
      darkTheme: SFThemes.darkTheme,
      themeMode: ThemeMode.light,
      title: '75 Get Right',
      routes: {
        '/': (context) => SplashScreen(
              // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
              child: LoginPage(),
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
        "/sandbox": (context) => SandboxPage(),
        "/calendar": (context) => CalendarPage(),
        "/sys_home_page": (context) => const SysHomePage(),
      },
      
    );

  }
}
