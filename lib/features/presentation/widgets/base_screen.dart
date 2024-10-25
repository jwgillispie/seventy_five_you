import 'package:flutter/material.dart';
import 'package:seventy_five_hard/features/presentation/widgets/new_navbar.dart';

class BaseScreen extends StatelessWidget {
  final Widget child;
  final NewnavBar navBar = NewnavBar();

  BaseScreen({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(  // Wrap the body with SafeArea
        child: child,
      ),
      bottomNavigationBar: navBar.build(context), // Your custom NavBar
    );
  }
}
