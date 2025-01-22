//lib/features/auth/presentation/widgets/logout_button.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/themes/app_colors.dart';
import '../bloc/auth_bloc.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(LogoutRequested());
                  Navigator.pushReplacementNamed(context, '/login');
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.error,
                ),
                child: const Text('Logout'),
              ),
            ],
          ),
        );
      },
      icon: const Icon(Icons.logout),
    );
  }
}