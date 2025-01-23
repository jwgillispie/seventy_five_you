// lib/features/auth/presentation/widgets/auth_wrapper.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:seventy_five_hard/features/auth/presentation/bloc/auth_state.dart';
import 'package:seventy_five_hard/features/auth/presentation/pages/login_page.dart';
import '../bloc/auth_bloc.dart';
import '../providers/auth_provider.dart';

class AuthWrapper extends StatelessWidget {
  final Widget child;

  const AuthWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        final authProvider = context.read<AuthProvider>();
        
        if (state is AuthLoading) {
          authProvider.setLoading(true);
        } else {
          authProvider.setLoading(false);
          
          if (state is AuthAuthenticated) {
            authProvider.setUser(state.user);
          } else if (state is AuthError) {
            authProvider.clearUser();
          }
        }
      },
      child: Builder(
        builder: (context) {
          final authProvider = context.watch<AuthProvider>();
          
          if (authProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (!authProvider.isAuthenticated) {
            return const LoginPage();
          }
          
          return child;
        },
      ),
    );
  }
}