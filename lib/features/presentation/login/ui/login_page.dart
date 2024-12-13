import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seventy_five_hard/features/presentation/login/bloc/login_bloc.dart';
import 'package:seventy_five_hard/themes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final LoginBloc loginBloc = LoginBloc();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      bloc: loginBloc,
      listener: (context, state) {
        if (state is LoginSuccessState) {
          loginBloc.add(LoginNavigateToHomeEvent(
            firebaseUid: FirebaseAuth.instance.currentUser!.uid,
          ));
          Navigator.pushReplacementNamed(context, "/home");
        } else if (state is LoginFailureState) {
          _showErrorSnackBar(context, state.message);
        } else if (state is LoginNavigateToSignupState) {
          Navigator.pushReplacementNamed(context, "/signup");
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  SFColors.neutral,
                  SFColors.tertiary,
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 48),
                      _buildHeader(),
                      const SizedBox(height: 48),
                      _buildLoginForm(context, state),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          Text(
            '75 HARD',
            style: GoogleFonts.orbitron(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: SFColors.surface,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Welcome back, warrior!',
            style: GoogleFonts.inter(
              fontSize: 18,
              color: SFColors.surface.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, LoginState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: SFColors.surface.withOpacity(0.1),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextField(
            controller: _emailController,
            label: 'Email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _passwordController,
            label: 'Password',
            icon: Icons.lock_outline,
            isPassword: true,
            isPasswordVisible: _isPasswordVisible,
            onVisibilityToggle: () {
              setState(() => _isPasswordVisible = !_isPasswordVisible);
            },
          ),
          const SizedBox(height: 24),
          _buildLoginButton(state),
          const SizedBox(height: 24),
          _buildSignUpLink(),
          const SizedBox(height: 36),
          _buildAdditionalLinks(),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool isPassword = false,
    bool? isPasswordVisible,
    VoidCallback? onVisibilityToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: SFColors.surface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: SFColors.surface.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: SFColors.surface.withOpacity(0.1),
            ),
          ),
          child: TextField(
            controller: controller,
            style: GoogleFonts.inter(color: SFColors.surface),
            keyboardType: keyboardType,
            obscureText: isPassword && !(_isPasswordVisible),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: SFColors.surface.withOpacity(0.7)),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: SFColors.surface.withOpacity(0.7),
                      ),
                      onPressed: onVisibilityToggle,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(LoginState state) {
    return ElevatedButton(
      onPressed: state is LoginLoadingState
          ? null
          : () {
              loginBloc.add(LoginButtonPressedEvent(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim(),
              ));
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: SFColors.primary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      child: state is LoginLoadingState
          ? SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(SFColors.surface),
              ),
            )
          : Text(
              'Login',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: SFColors.surface,
              ),
            ),
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?",
          style: GoogleFonts.inter(
            color: SFColors.surface.withOpacity(0.8),
          ),
        ),
        TextButton(
          onPressed: () => loginBloc.add(LoginNavigateToSignupEvent()),
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

  Widget _buildAdditionalLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {},
          child: Text(
            'Privacy Policy',
            style: GoogleFonts.inter(
              color: SFColors.surface.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
        ),
        Text(
          '•',
          style: TextStyle(
            color: SFColors.surface.withOpacity(0.6),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'Terms of Service',
            style: GoogleFonts.inter(
              color: SFColors.surface.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFB23B3B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}