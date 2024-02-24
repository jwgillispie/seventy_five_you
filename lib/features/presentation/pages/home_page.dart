// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seventy_five_hard/features/presentation/bloc_pattern/users/bloc/user_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:seventy_five_hard/features/presentation/widgets/nav_bar.dart';
import 'package:seventy_five_hard/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int daysPassed = 0;
  bool started = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  String username = '';
  String currentDate = '';
  String displayDate = '';
  final UserBloc userBloc = UserBloc();

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    // print("User ID: ${user?.uid}"); // Debug print
    if (user != null) {
      userBloc.add(FetchUserName(user!.uid));
    }
    fetchDate();
  }
  // Update days passed and start the timer
  // void _updateDaysPassed() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   DateTime lastDate = DateTime.parse(prefs.getString('lastDate') ?? '');

  //   DateTime currentDate = DateTime.now();
  //   if (currentDate.difference(lastDate).inDays > 0) {
  //     setState(() {
  //       daysPassed += 1;
  //     });
  //     prefs.setString('lastDate', DateTime.now().toString());
  //   }
  // }

  // Timer to check and update days passed every midnight
  // void _startTimer() {
  //   Timer.periodic(const Duration(hours: 1), (timer) {
  //     DateTime now = DateTime.now();
  //     if (now.hour == 0 && now.minute == 0) {
  //       _updateDaysPassed();
  //     }
  //   });
  // }

// void _getCurrentUser() {
//   User? user = FirebaseAuth.instance.currentUser;
//   setState(() {
//     _currentUser = user;
//   });
// }
  // Future<void> fetchUsername() async {
  //   try {
  //     if (user != null) {
  //       print("user not null: " + (user?.uid ?? ''));
  //       final response = await http.get(
  //         Uri.parse('http://10.0.2.2:8000/user/${user?.uid}'),
  //       );

  //       if (response.statusCode == 200) {
  //         final data = jsonDecode(response.body);
  //         final fetchedUsername = data['display_name'];
  //         setState(() {
  //           username = fetchedUsername;
  //         });
  //       } else {
  //         setState(() {
  //           username = 'Error retrievingggg username';
  //         });
  //       }
  //     } else {
  //       setState(() {
  //         username = 'User not authenticated';
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       username = 'Error retrievingrrrr username';
  //     });
  //   }
  // }

  Future<void> fetchDate() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/day/${user?.uid}'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          displayDate = data['date'];
        });
      } else {
        print("Firebase UID: " + (user?.uid ?? ''));
        print('Failed to fetch date: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching date: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: BlocConsumer<UserBloc, UserState>(
          bloc: userBloc,
          listenWhen: (previous, current) {
            // Only listen to state changes if it's an error state
            return current is UserError;
          },
          listener: (context, state) {
            // This will now only be triggered when listenWhen condition is true
            if (state is UserError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          buildWhen: (previous, current) {
            // Rebuild only for UserLoaded and UserInitial states
            return current is UserLoaded || current is UserInitial;
          },
          builder: (context, state) {
            if (state is UserLoaded) {
              return Text("Don't be a bitch today ${state.username}",
                  style: Theme.of(context).textTheme.bodyLarge);
            }
            return Text("Don't be a bitch today ---",
                style: Theme.of(context).textTheme.bodyLarge);
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2, // Number of columns in the grid
              shrinkWrap: true,
              children: [
                "Diet",
                "Outside Workout",
                "Second Workout",
                "Water",
                "Alcohol",
                "10 Pages",
                "Sandbox",
                "sys_home_page"
              ].map((title) {
                return buildGridItem(context, title);
              }).toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const NavBar(),
    );
  }

  Widget buildGridItem(BuildContext context, String title) {
    // Map words to corresponding icons
    Map<String, IconData> iconMap = {
      "Diet": Icons.restaurant,
      "Outside Workout": Icons.directions_run,
      "Second Workout": Icons.fitness_center,
      "Water": Icons.local_drink,
      "Alcohol": Icons.no_drinks,
      "10 Pages": Icons.menu_book,
      "Sandbox": Icons.beach_access,
      "sys_home_page": Icons.home,
    };

    // Get the icon for the given title
    IconData? iconData =
        iconMap.containsKey(title) ? iconMap[title] : Icons.error;

    return GestureDetector(
      onTap: () {
        if (title == "Outside Workout") {
          title = "Workout 1";
        } else if (title == "Second Workout") {
          title = "Workout 2";
        }
        navigateToPage(context, title);
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary, // White background
          borderRadius: BorderRadius.circular(10), // Rounded corners
          border: Border.all(color: Colors.black), // Black border
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon representing the title
            Icon(
              iconData,
              size: 40, // Adjust the size of the icon as needed
              color: Colors.black, // Adjust the color of the icon as needed
            ),
            const SizedBox(height: 10), // Spacer between icon and text
            // Text describing the title
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  void navigateToPage(BuildContext context, String title) {
    // Define the navigation logic based on the title
    switch (title) {
      case "Diet":
        Navigator.pushNamed(context, "/diet");
        break;
      case "Workout 1":
        Navigator.pushNamed(context, "/workout1");
        break;
      case "Workout 2":
        Navigator.pushNamed(context, "/workout2");
        break;
      case "Water":
        Navigator.pushNamed(context, "/water");
        break;
      case "Alcohol":
        Navigator.pushNamed(context, "/alcohol");
        break;
      case "10 Pages":
        Navigator.pushNamed(context, "/tenpages");
      case "Sandbox":
        Navigator.pushNamed(context, "/sandbox");
        break;
      case "sys_home_page":
        Navigator.pushNamed(context, "/sys_home_page");
        break;
      default:
        break;
    }
  }
}
