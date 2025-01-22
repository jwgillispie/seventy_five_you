// lib/features/auth/presentation/widgets/auth_form.dart

import 'package:flutter/material.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../shared/widgets/app_text_field.dart';
import '../../../../../shared/widgets/app_button.dart';

class AuthForm extends StatelessWidget {
  final bool isLogin;
  final void Function(String email, String password, String? username) onSubmit;
  final bool isLoading;

  AuthForm({
    Key? key,
    required this.isLogin,
    required this.onSubmit,
    this.isLoading = false,
  }) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          if (!isLogin) ...[
            AppTextField(
              controller: _usernameController,
              label: 'Username',
              validator: (value) => Validators.validateRequired(value, 'Username'),
            ),
            const SizedBox(height: 16),
          ],
          AppTextField(
            controller: _emailController,
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _passwordController,
            label: 'Password',
            isPassword: true,
            validator: Validators.validatePassword,
          ),
          const SizedBox(height: 24),
          AppButton(
            onPressed: _handleSubmit,
            label: isLogin ? 'Login' : 'Sign Up',
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      onSubmit(
        _emailController.text,
        _passwordController.text,
        isLogin ? null : _usernameController.text,
      );
    }
  }
}