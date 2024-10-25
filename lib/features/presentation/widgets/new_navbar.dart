import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart'
    as new_nav_bar;
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:seventy_five_hard/features/presentation/home/ui/home_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/calendar.dart';
import 'package:seventy_five_hard/features/presentation/pages/gallery.dart';
import 'package:seventy_five_hard/features/presentation/pages/social_page.dart';
import 'package:seventy_five_hard/features/presentation/profile/ui/profile_page.dart';
import 'package:seventy_five_hard/features/presentation/widgets/custom_navbar.dart';

class NewnavBar {
  late PersistentTabController _controller;

  List<Widget> _buildScreens() {
    return [
      HomePage(),
      SocialPage(),
      CalendarPage(),
      GalleryPage(),
      ProfilePage(),
    ];
  }

  Widget build(BuildContext context) {
    return new_nav_bar.PersistentTabView(
      resizeToAvoidBottomInset: true,
      navBarHeight: 55,
      tabs: [
        PersistentTabConfig(
          screen: HomePage(),
          item: ItemConfig(
            icon: Icon(Icons.home),
            title: "home",
            activeForegroundColor: Theme.of(context).colorScheme.primary,
            inactiveForegroundColor:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
            activeColorSecondary: Theme.of(context).colorScheme.primary,
          ),
        ),
        PersistentTabConfig(
          screen: SocialPage(),
          item: ItemConfig(
            icon: Icon(Icons.newspaper_outlined),
            title: "people",
            activeForegroundColor: Theme.of(context).colorScheme.primary,
            inactiveForegroundColor:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
            activeColorSecondary: Theme.of(context).colorScheme.primary,
          ),
        ),
        PersistentTabConfig(
          screen: CalendarPage(),
          item: ItemConfig(
            // Use ImageIcon to display the correct logo based on the theme
            icon: Icon(Icons.calendar_today_outlined),
            // Adjust size according to your preference
            title: "Systems",
            activeForegroundColor: Theme.of(context).colorScheme.primary,
            inactiveForegroundColor:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
            activeColorSecondary: Theme.of(context).colorScheme.primary,
            // iconSize:,
          ),
        ),
        PersistentTabConfig(
          screen: GalleryPage(),
          item: ItemConfig(
            icon: Icon(Icons.photo_camera),
            title: "Analytics",
            activeForegroundColor: Theme.of(context).colorScheme.primary,
            inactiveForegroundColor:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
          ),
        ),
        PersistentTabConfig(
          screen: ProfilePage(),
          item: ItemConfig(
            icon: Icon(Icons.person_off),
            title: "Social",
            activeForegroundColor: Theme.of(context).colorScheme.primary,
            inactiveForegroundColor:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
            activeColorSecondary: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
      avoidBottomPadding: true,
      navBarBuilder: (navBarConfig) => CustomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: new_nav_bar.NavBarDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
          borderRadius: BorderRadius.zero,
          border: Border(
            top: BorderSide(
              width: 0.38,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).colorScheme.primary
                  : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
