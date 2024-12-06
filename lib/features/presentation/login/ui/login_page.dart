import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seventy_five_hard/features/presentation/home/ui/home_page.dart';
import 'package:seventy_five_hard/features/presentation/login/bloc/login_bloc.dart';
import 'package:seventy_five_hard/features/presentation/login/repos/login_repository.dart';
import 'package:seventy_five_hard/features/presentation/widgets/form_container_widget.dart';
import 'package:seventy_five_hard/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seventy_five_hard/main.dart';
import 'package:seventy_five_hard/navigation_service.dart';
// import 'package:seventy_five_you/lib/features/presentation/profile/ui/profile.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _isLoading = false;
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginBloc loginBloc = LoginBloc();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      bloc: loginBloc,
      listener: (context, state) {
        if (state is LoginSuccessState) {
          Fluttertoast.showToast(msg: "Login successful");
          loginBloc.add(LoginNavigateToHomeEvent(
              firebaseUid: FirebaseAuth.instance.currentUser!.uid));
          NavigationService.navigateToHome(context);
        } else if (state is LoginFailureState) {
          Fluttertoast.showToast(msg: state.message);
        } else if (state is LoginNavigateToSignupState) {
          NavigationService.navigateToSignup(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Login"),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: state is LoginLoadingState
              ? const Center(child: CircularProgressIndicator())
              : _buildLoginForm(context),
        );
      },
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Login",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            FormContainerWidget(
              controller: _emailController,
              hintText: "Email",
              isPasswordField: false,
            ),
            const SizedBox(height: 10),
            FormContainerWidget(
              controller: _passwordController,
              hintText: "Password",
              isPasswordField: true,
            ),
            const SizedBox(height: 30),
            _buildLoginButton(),
            const SizedBox(height: 10),
            _buildSignupLink(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return GestureDetector(
      onTap: _handleLogin,
      child: Container(
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
        ),
      ),
    );
  }

  Widget _buildSignupLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?"),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: () => loginBloc.add(LoginNavigateToSignupEvent()),
          child: Text(
            "Sign Up",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void _handleLogin() async {
    loginBloc.add(LoginButtonPressedEvent(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    ));

    // Wait for authentication to complete
    await Future.delayed(const Duration(seconds: 2));

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Create new day object
      final loginRepo = LoginRepository();
      final dayExists = await loginRepo.checkIfDayExists(user.uid);

      if (!dayExists) {
        await loginRepo.createNewDay(user.uid);
      }

      loginBloc.add(LoginNavigateToHomeEvent(firebaseUid: user.uid));
    } else {
      if (mounted) {
        Fluttertoast.showToast(msg: 'User not logged in. Please try again.');
      }
    }
  }
}
