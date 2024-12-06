// import 'package:flutter/material.dart';

// class Observer extends NavigatorObserver {
//   bool _hideNavBar = false;

//   bool get hideNavBar => _hideNavBar;

//   void _updateNavBarVisibility(Route<dynamic>? route) {
//     // Check if the route is for login or signup
//     if (route != null) {
//       String? routeName = route.settings.name;
//       _hideNavBar = routeName == '/login' || routeName == '/signup';

//       // Print the current page's route name
//       print('Current page: $routeName');
//     } else {
//       _hideNavBar = false;
//     }
//   }

//   @override
//   void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
//     super.didPush(route, previousRoute);
//     _updateNavBarVisibility(route);
//   }

//   @override
//   void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
//     super.didPop(route, previousRoute);
//     _updateNavBarVisibility(previousRoute);
//   }
// }
