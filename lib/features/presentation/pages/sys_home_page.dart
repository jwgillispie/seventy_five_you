import 'package:flutter/material.dart';
import 'dart:async';

import 'package:seventy_five_hard/features/presentation/widgets/nav_bar.dart';

class SysHomePage extends StatefulWidget {
  const SysHomePage({super.key});

  @override
  State<SysHomePage> createState() => _SysHomePageState();
}

class _SysHomePageState extends State<SysHomePage> {
  // Define your list of ticker items
  final List<String> tickerItems = [
    "Ticker Item 1",
    "Ticker Item 2",
    "Ticker Item 3",
    "Ticker Item 4",
    // Add more ticker items as needed
  ];
  final List<String> box1Items = [
    'Box 1 Text 1',
    'Box 1 Text 2',
    'Box 1 Text 3',
    'Box 1 Text 4',
    'Box 1 Text 5',
    'Box 1 Text 6',
    'Box 1 Text 7',
  ];

  final List<String> box2Items = [
    'Box 2 Text 1',
    'Box 2 Text 2',
    'Box 2 Text 3',
  ];

  final List<String> box3Items = [
    'Box 3 Text 1',
    'Box 3 Text 2',
    'Box 3 Text 3',
  ];

  final List<String> box4Items = [
    'Box 4 Text 1',
    'Box 4 Text 2',
    'Box 4 Text 3',
  ];
  // Define a ScrollController to control scrolling
  final ScrollController _scrollController = ScrollController();
  Timer? _scrollTimer;

  @override
  void initState() {
    super.initState();
    // Start the automatic scrolling when the widget is initialized
    _startScrolling();
  }

  @override
  void dispose() {
    // Dispose the timer and scroll controller when the widget is disposed
    _scrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  // Method to start automatic scrolling
  void _startScrolling() {
    // Cancel any existing timer
    _scrollTimer?.cancel();
    // Start a new timer to scroll every 3 seconds
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 60), (timer) {
      _scrollTickerItems();
    });
  }

  // Method to scroll ticker items
  // Method to scroll ticker items
  void _scrollTickerItems() {
    if (_scrollController.hasClients) {
      final double maxWidth = _scrollController.position.maxScrollExtent;
      final double currentOffset = _scrollController.offset;
      final double newOffset = (currentOffset + 1) %
          (maxWidth + 1); // Adjust speed by increment value
      _scrollController.jumpTo(newOffset);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Home",
            style: TextStyle(color: Colors.lightGreenAccent)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Center(
            child: SizedBox(
              height: 50, // Adjust height as needed
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tickerItems.length * 2, // Set a large item count
                controller: _scrollController,
                itemBuilder: (context, index) {
                  // Use modulo to loop through ticker items
                  final itemIndex = index % tickerItems.length;
                  return _buildTickerItem(tickerItems[itemIndex]);
                },
              ),
            ),
          ),
          const SizedBox(height: 20), // Spacer between ticker and boxes
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildBox(box1Items, 150, 150, "Leaderboard"),
                    const SizedBox(width: 20), // Spacer between boxes
                    _buildScrollableBox(box2Items, 150, 150, "Your Systems"),
                  ],
                ),
                const SizedBox(height: 20), // Spacer between rows
                _buildScrollableBox(box3Items, 300, 150, "Current Games"),
                const SizedBox(height: 20), // Spacer between rows
                _buildScrollableBox(box4Items, 300, 150, "News Headlines"),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const NavBar(),
    );
  }

  Widget _buildTickerItem(String text) {
    return Container(
      width: 100,
      height: 50,
      color: Colors.lightGreenAccent,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}

Widget _buildScrollableBox(
    List<String> items, double w, double h, String title) {
  return Container(
    width: w,
    height: h,
    decoration: BoxDecoration(
      color: Colors.lightGreenAccent,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: Colors.black,
        width: 3,
      ),
    ),
    alignment: Alignment.topCenter,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  items[index],
                  style: const TextStyle(color: Colors.black),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}
Widget _buildBox(
    List<String> items, double w, double h, String title) {
  return Container(
    width: w,
    height: h,
    decoration: BoxDecoration(
      color: Colors.lightGreenAccent,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: Colors.black,
        width: 3,
      ),
    ),
    alignment: Alignment.topCenter,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ],
    ),
  );
}
