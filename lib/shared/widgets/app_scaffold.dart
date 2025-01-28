// lib/shared/widgets/app_scaffold.dart

import 'package:flutter/material.dart';
import 'package:seventy_five_hard/features/calendar/presentation/pages/calendar_page.dart';
import 'package:seventy_five_hard/features/profile/ui/profile_page.dart';
import 'package:seventy_five_hard/features/social/presentation/pages/social_page.dart';
import 'package:seventy_five_hard/features/home/ui/home_page.dart';
import 'package:seventy_five_hard/core/themes/app_colors.dart';

class AppScaffold extends StatefulWidget {
  final int initialIndex;
  
  const AppScaffold({
    Key? key,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  late int _currentIndex;
  late PageController _pageController;

  final List<Widget> _pages = [
    const HomePage(),
    const CalendarPage(),
    const EnhancedSocialPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: SFColors.neutral.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
              _pageController.jumpToPage(index);
            });
          },
          backgroundColor: SFColors.surface,
          indicatorColor: SFColors.primary.withOpacity(0.2),
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: SFColors.textSecondary),
              selectedIcon: Icon(Icons.home, color: SFColors.primary),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_today_outlined, color: SFColors.textSecondary),
              selectedIcon: Icon(Icons.calendar_today, color: SFColors.primary),
              label: 'Calendar',
            ),
            NavigationDestination(
              icon: Icon(Icons.people_outline, color: SFColors.textSecondary),
              selectedIcon: Icon(Icons.people, color: SFColors.primary),
              label: 'Social',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline, color: SFColors.textSecondary),
              selectedIcon: Icon(Icons.person, color: SFColors.primary),
              label: 'Profile',
            ),
          ],
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        ),
      ),
    );
  }
}