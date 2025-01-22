// lib/features/auth/presentation/pages/login_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../shared/widgets/app_scaffold.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is AuthAuthenticated) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome Back',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 32),
                  AuthForm(
                    isLogin: true,
                    isLoading: state is AuthLoading,
                    onSubmit: (email, password, _) {
                      context.read<AuthBloc>().add(
                        LoginRequested(
                          email: email,
                          password: password,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: const Text('Don\'t have an account? Sign Up'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}