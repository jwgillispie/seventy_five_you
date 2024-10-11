import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seventy_five_hard/features/presentation/users/bloc/user_bloc.dart';
import 'package:seventy_five_hard/features/presentation/widgets/nav_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  Timer? _scrollTimer;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  final UserBloc userBloc = UserBloc();
  final List<String> lineItems = [
    'Great job',
    "Give up and you're a quitter",
    'One day at a time',
    'Keep going',
    'You’re crushing it',
  ];

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _startScrolling() {
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      _scrolllineItems();
    });
  }

  void _scrolllineItems() {
    if (_scrollController.hasClients) {
      final double maxWidth = _scrollController.position.maxScrollExtent;
      final double currentOffset = _scrollController.offset;
      final double newOffset = (currentOffset) % (maxWidth);
      _scrollController.jumpTo(newOffset + 1);
    }
  }

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    if (user != null) {
      userBloc.add(FetchUserName(user!.uid));
    }
    _startScrolling();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: BlocConsumer<UserBloc, UserState>(
          bloc: userBloc,
          listenWhen: (previous, current) => current is UserError,
          listener: (context, state) {
            if (state is UserError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          buildWhen: (previous, current) =>
              current is UserLoaded || current is UserInitial,
          builder: (context, state) {
            if (state is UserLoaded) {
              return Text(
                "75 ${state.username}",
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimary,
                ),
              );
            }
            return Text(
              "75 ---",
              style: theme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimary,
              ),
            );
          },
        ),
        backgroundColor: theme.primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.primaryColor.withOpacity(0.1),
              theme.colorScheme.secondary.withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            SizedBox(
              height: 50, // Height for the ticker container
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                itemCount: lineItems.length * 2, // Create continuous scrolling
                itemBuilder: (context, index) {
                  final itemIndex = index % lineItems.length;
                  return _buildTickerItem(lineItems[itemIndex], context);
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // 2 columns in the grid
                shrinkWrap: true,
                children: [
                  "Diet",
                  "Outside Workout",
                  "Second Workout",
                  "Water",
                  "Alcohol",
                  "10 Pages",
                ].map((title) {
                  return _buildGridItem(context, title);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }

Widget _buildTickerItem(String text, BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20), // Add padding for readability
    margin: const EdgeInsets.symmetric(horizontal: 5), // Margin between items
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
      borderRadius: BorderRadius.circular(10),  // Rounded corners for a modern look
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 5,
          spreadRadius: 1,
        ),
      ],
    ),
    child: Center(
      child: FittedBox(  // Ensure the text fits within the available space
        fit: BoxFit.scaleDown,  // Scale down the text if needed
        child: Text(
          text,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    ),
  );
}


  // Grid items with icon and text, styled with shadows and borders
  Widget _buildGridItem(BuildContext context, String title) {
    final theme = Theme.of(context);
    Map<String, IconData> iconMap = {
      "Diet": Icons.restaurant,
      "Outside Workout": Icons.directions_run,
      "Second Workout": Icons.fitness_center,
      "Water": Icons.local_drink,
      "Alcohol": Icons.no_drinks,
      "10 Pages": Icons.menu_book,
    };
    IconData? iconData = iconMap[title];

    return GestureDetector(
      onTap: () => _navigateToPage(context, title),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.all(10),
        elevation: 8,
        shadowColor: theme.primaryColor.withOpacity(0.2),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.primaryColor.withOpacity(0.1),
                theme.colorScheme.secondary.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 50,
                color: theme.primaryColor,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Navigate to respective pages based on title
  void _navigateToPage(BuildContext context, String title) {
    switch (title) {
      case "Diet":
        Navigator.pushNamed(context, "/diet");
        break;
      case "Outside Workout":
        Navigator.pushNamed(context, "/workout1");
        break;
      case "Second Workout":
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
        break;
    }
  }
}
