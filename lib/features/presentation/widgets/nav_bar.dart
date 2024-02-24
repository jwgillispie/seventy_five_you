import 'package:flutter/material.dart';
class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0; // Initial index of the selected tab

  // Define a map to store colors for each tab
  final Map<int, Color> tabColors = {
    0: Colors.blue, // Home
    1: Colors.red, // Calendar
    2: Colors.green, // Profile
    // Add other tabs and colors as needed
  };

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).colorScheme.secondary,

      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        // Handle navigation to different routes based on the selected tab index
        switch (index) {
          case 0:
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
            break;
          case 1:
            Navigator.pushNamedAndRemoveUntil(context, '/calendar', (route) => false);
            break;
          case 2:
            Navigator.pushNamedAndRemoveUntil(context, '/profile', (route) => false);
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
          icon: Icon(Icons.calendar_month_outlined),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.emoji_people_outlined),
          label: 'Profile',
        ),
        // Add other BottomNavigationBarItems for additional tabs
      ],
      selectedItemColor: tabColors[_selectedIndex], // Set the color of the selected tab dynamically
    );
  }
}

