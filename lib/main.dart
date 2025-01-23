// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:seventy_five_hard/core/constants/route_constants.dart';
import 'features/user/presentation/bloc/user_bloc.dart';
import 'core/di/injection_container.dart' as di;
import 'core/navigation/app_router.dart';
import 'core/themes/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UserBloc(),
        ),
        BlocProvider(
          create: (_) => di.sl<AuthBloc>(),
        ),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AuthProvider(),
          ),
        ],
        child: MaterialApp(
          title: '75 Hard',
          debugShowCheckedModeBanner: false,
          theme: SFThemes.lightTheme,
          darkTheme: SFThemes.darkTheme,
          themeMode: ThemeMode.system,
          onGenerateRoute: AppRouter.onGenerateRoute,
          initialRoute: RouteConstants.home, // Update initial route to home page
        ),
      ),
    );
  }
}