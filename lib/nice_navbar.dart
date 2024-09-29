import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:seventy_five_hard/features/presentation/home/ui/home_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/calendar.dart';
import 'package:seventy_five_hard/features/presentation/pages/gallery.dart';
import 'package:seventy_five_hard/features/presentation/profile/ui/profile_page.dart';



class NavBar{
  late PersistentTabController _controller;

  List<Widget> _buildScreens() {
    return [
      HomePage(),
      CalendarPage(),
      GalleryPage(),
      ProfilePage(),
    ];
  }

  Widget build(BuildContext context){
    _controller = PersistentTabController(initialIndex: 0);
    return PersistentTabView(context,
      controller: _controller,
      screens: _buildScreens(),
      items: <PersistentBottomNavBarItem>[
        PersistentBottomNavBarItem(
            icon: Icon(Icons.home),
            title: 'Home',
            inactiveColorPrimary: Theme.of(context).brightness == Brightness.light ? Colors.black87: Colors.white,
            activeColorPrimary: Theme.of(context).colorScheme.primary
        ),
        PersistentBottomNavBarItem(
            icon: Icon(Icons.analytics),
            title: 'Analytics',
            inactiveColorPrimary: Theme.of(context).brightness == Brightness.light ? Colors.black87: Colors.white,
            activeColorPrimary: Theme.of(context).colorScheme.primary
        ),
        PersistentBottomNavBarItem(
            icon: Icon(Icons.add_circle_outline_sharp),
            title: 'Create',
            inactiveColorPrimary: Theme.of(context).brightness == Brightness.light ? Colors.black87: Colors.white,
            activeColorPrimary: Theme.of(context).colorScheme.primary
        ),

        PersistentBottomNavBarItem(
            icon: Icon(Icons.account_circle),
            title: 'Profile',
            inactiveColorPrimary: Theme.of(context).brightness == Brightness.light ? Colors.black87: Colors.white,
            activeColorPrimary:Theme.of(context).colorScheme.primary
        ),
      ],
      confineInSafeArea: true,
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: const NavBarDecoration(
        borderRadius: BorderRadius.zero,
        colorBehindNavBar: Colors.black87,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties( // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style14,);

  }
}