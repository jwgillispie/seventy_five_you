//lib/features/auth/presentation/pages/signup_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../shared/widgets/app_scaffold.dart';
import '../../../../../core/themes/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_form.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
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
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 48),
                    _buildHeader(context),
                    const SizedBox(height: 48),
                    _buildSignupForm(context, state),
                    const SizedBox(height: 24),
                    _buildLoginLink(context),
                  ],
                ),
              ),
            ),
          );
        },
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
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Create your account',
          style: GoogleFonts.inter(
            fontSize: 18,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSignupForm(BuildContext context, AuthState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.surface.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: AuthForm(
        isLogin: false,
        isLoading: state is AuthLoading,
        onSubmit: (email, password, username) {
          context.read<AuthBloc>().add(
                SignupRequested(
                  email: email,
                  password: password,
                  username: username ?? '',
                ),
              );
        },
      ),
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account?",
          style: GoogleFonts.inter(
            color: AppColors.textSecondary,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          child: Text(
            'Login',
            style: GoogleFonts.inter(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}