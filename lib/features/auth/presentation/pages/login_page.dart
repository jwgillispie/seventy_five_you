// lib/features/auth/presentation/pages/login_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seventy_five_hard/features/auth/presentation/bloc/auth_event.dart';
import 'package:seventy_five_hard/features/auth/presentation/bloc/auth_state.dart';
import 'package:seventy_five_hard/navigation_service.dart';
import '../../../../../core/themes/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: SFColors.error,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else if (state is AuthAuthenticated) {
                  Navigator.pushNamedAndRemoveUntil(
                    context, 
                    '/home',
                    (route) => false,
                  );
                }
              },
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 48),
                    _buildHeader(context),
                    const SizedBox(height: 48),
                    _buildLoginForm(context, state),
                    const SizedBox(height: 24),
                    _buildSignupLink(context),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Text(
          '75 HARD',
          style: GoogleFonts.orbitron(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: SFColors.primary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Welcome Back',
          style: GoogleFonts.inter(
            fontSize: 18,
            color: SFColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(BuildContext context, AuthState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: SFColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: SFColors.surface.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: SFColors.neutral.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: AuthForm(
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
    );
  }

  Widget _buildSignupLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?",
          style: GoogleFonts.inter(
            color: SFColors.textSecondary,
          ),
        ),
        TextButton(
          // onPressed: () => Navigator.pushNamed(context, '/signup'),
          onPressed: () => NavigationService.navigateToSignup(context),
          child: Text(
            'Sign Up',
            style: GoogleFonts.inter(
              color: SFColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}