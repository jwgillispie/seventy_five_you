// lib/features/auth/presentation/widgets/auth_state_listener.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seventy_five_hard/features/auth/presentation/bloc/auth_state.dart';
import '../bloc/auth_bloc.dart';

class AuthStateListener extends StatelessWidget {
  final Widget child;

  const AuthStateListener({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      child: child,
    );
  }
}