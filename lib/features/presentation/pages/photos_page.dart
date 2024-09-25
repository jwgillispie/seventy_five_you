import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:seventy_five_hard/features/presentation/pages/photo_view_page.dart';

class FoodPhotosPage extends StatelessWidget {
  final List<String> photos = [
    "assets/images/food1.jpeg",
    "assets/images/food2.jpeg",
    "assets/images/food3.jpeg",
    "assets/images/food4.jpeg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Food"), backgroundColor: Theme.of(context).primaryColor,),
      body: GridView.builder(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.all(1),
        itemCount:
            photos.length, // Make sure 'photos' contains local asset paths
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PhotoViewPage(photos: photos, index: index),
              ),
            ),
            child: Hero(
              tag: photos[index],
              child: Image.asset(
                // Changed to Image.asset
                photos[index], // Update this to the local asset path
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}

class DailyProgressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daily Progress"), backgroundColor: Theme.of(context).primaryColor,),
      body: Center(child: Text("Daily Progress")),
    );
  }
}

class WorkoutPhotosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Workout Photos"), backgroundColor: Theme.of(context).primaryColor,),
      body: Center(child: Text("Workout Photos")),
    );
  }
}
