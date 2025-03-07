// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:seventy_five_hard/core/themes/theme_provider.dart';
import 'package:seventy_five_hard/features/auth/presentation/bloc/auth_state.dart';
import 'firebase_options.dart';
import 'core/di/injection_container.dart' as di;
import 'core/themes/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'shared/widgets/app_scaffold.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("Main: Application starting");
  
  try {
    print("Main: Initializing Firebase");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Main: Firebase initialized successfully");
  } catch (e) {
    print("Main: Error initializing Firebase: $e");
  }
  
  try {
    print("Main: Initializing dependency injection");
    await di.init();
    print("Main: Dependency injection initialized successfully");
  } catch (e) {
    print("Main: Error initializing dependency injection: $e");
  }
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("Main: Building MyApp");
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (_) {
            print("Main: Creating AuthBloc");
            return di.sl<AuthBloc>();
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            print("Main: Creating AuthProvider");
            return AuthProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            print("Main: Creating ThemeProvider");
            return ThemeProvider();
          },
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          print("Main: Building MaterialApp with theme");
          return MaterialApp(
            title: '75 Hard',
            debugShowCheckedModeBanner: false,
            theme: SFThemes.lightTheme,
            darkTheme: SFThemes.darkTheme,
            themeMode: ThemeMode.system,
            initialRoute: '/',
            routes: {
              '/': (context) => _buildHomeOrLogin(context),
              '/login': (context) => const LoginPage(),
              '/signup': (context) => const SignupPage(),
              '/home': (context) => const AppScaffold(),
            },
          );
        }
      ),
    );
  }
  
  Widget _buildHomeOrLogin(BuildContext context) {
    print("Main: Determining home or login page");
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          print("Main: User is authenticated, showing AppScaffold");
          return const AppScaffold();
        }
        print("Main: User is not authenticated, showing LoginPage");
        return const LoginPage();
      },
    );
  }
}