import 'package:flutter/material.dart';
import 'package:seventy_five_hard/features/presentation/pages/photos_page.dart';
import 'package:seventy_five_hard/features/presentation/widgets/nav_bar.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TabBar(
              indicatorColor: Theme.of(context).primaryColor,
              labelColor: Theme.of(context).primaryColor,
              controller: _tabController,
              tabs: [
                Tab(text: 'Food', icon: Icon(Icons.fastfood)),
                Tab(text: 'Progress', icon: Icon(Icons.ssid_chart_rounded)),
                Tab(text: 'Workouts', icon: Icon(Icons.fitness_center)),
              ],
            ),
            SizedBox(height: 5),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  FoodPhotosPage(),
                  DailyProgressPage(),
                  WorkoutPhotosPage(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
