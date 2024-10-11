import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0; // Initial index of the selected tab

  // Define a map to store colors for each tab

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).primaryColor,
      type: BottomNavigationBarType.fixed, // Explicitly set the type to fixed
      selectedItemColor:
          Theme.of(context).colorScheme.onSecondary, // Set selected item color
      unselectedItemColor: Colors.grey, // Set unselected item color
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        // Handle navigation to different routes based on the selected tab index
        switch (index) {
          case 0:
            Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false);
            break;
          case 1:
            Navigator.pushNamedAndRemoveUntil(
                context, '/social', (route) => false);
            break;
          case 2:
            Navigator.pushNamedAndRemoveUntil(
                context, '/calendar', (route) => false);
            break;
          case 3:
            Navigator.pushNamedAndRemoveUntil(
                context, '/gallery', (route) => false);
            break;
          case 4:
            Navigator.pushNamedAndRemoveUntil(
                context, '/profile', (route) => false);
            break;
          // Add other cases for different tabs as needed
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.park),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_2_sharp),
          label: 'Squad75',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          label: 'Calendar',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt_outlined),
          label: 'Gallery',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.emoji_people_outlined),
          label: 'Profile',
        )
        // Add other BottomNavigationBarItems for additional tabs
      ],
    );
  }
}
