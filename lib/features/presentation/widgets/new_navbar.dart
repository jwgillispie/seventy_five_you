import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seventy_five_hard/features/presentation/home/ui/home_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/calendar.dart';
import 'package:seventy_five_hard/features/presentation/pages/gallery.dart';
import 'package:seventy_five_hard/features/presentation/pages/social_page.dart';
import 'package:seventy_five_hard/features/presentation/profile/ui/profile_page.dart';
import 'package:seventy_five_hard/features/presentation/widgets/custom_navbar.dart';
import 'package:seventy_five_hard/themes.dart';

class NewNavBar extends StatelessWidget {
  final PersistentTabController _controller;

  NewNavBar({super.key}) : _controller = PersistentTabController(initialIndex: 0);

  List<PersistentTabConfig> _buildTabs(BuildContext context) {
    return [
      _createTabConfig(
        context: context,
        screen: const HomePage(),
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        title: "Today",
      ),
      _createTabConfig(
        context: context,
        screen: SocialPage(),
        icon: Icons.people_outline,
        activeIcon: Icons.people,
        title: "Community",
      ),
      _createTabConfig(
        context: context,
        screen: CalendarPage(),
        icon: Icons.calendar_today_outlined,
        activeIcon: Icons.calendar_today,
        title: "Progress",
      ),
      _createTabConfig(
        context: context,
        screen: GalleryPage(),
        icon: Icons.photo_library_outlined,
        activeIcon: Icons.photo_library,
        title: "Gallery",
      ),
      _createTabConfig(
        context: context,
        screen: ProfilePage(),
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        title: "Profile",
      ),
    ];
  }

  PersistentTabConfig _createTabConfig({
    required BuildContext context,
    required Widget screen,
    required IconData icon,
    required IconData activeIcon,
    required String title,
  }) {
    return PersistentTabConfig(
      screen: screen,
      item: ItemConfig(
        icon: Icon(activeIcon),
        inactiveIcon: Icon(icon),
        title: title,
        textStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        activeForegroundColor: SFColors.primary,
        inactiveForegroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.7)
            : Colors.black54,
        activeColorSecondary: SFColors.primary,
        iconSize: 24,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PersistentTabView(
      controller: _controller,
      backgroundColor: Colors.transparent,
      navBarHeight: 65,
      tabs: _buildTabs(context),
      navBarBuilder: (navBarConfig) => CustomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: NavBarDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.05),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, -5),
            ),
          ],
        ),
      ),
    );
  }
}