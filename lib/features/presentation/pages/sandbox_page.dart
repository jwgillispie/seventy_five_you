import 'package:flutter/material.dart';
import 'package:seventy_five_hard/features/presentation/mongoDBHelper/mongo_db_service.dart';
 // Import your MongoDB service file
class SandboxPage extends StatefulWidget {
  const SandboxPage({Key? key}) : super(key: key);

  @override
  _SandboxPageState createState() => _SandboxPageState();
}

class _SandboxPageState extends State<SandboxPage> {
  final MongoDBService _mongoDBService = MongoDBService(); // Create an instance of MongoDBService

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _mongoDBService.fetchData(), // Fetch data from MongoDB
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final data = snapshot.data ?? [];
                  return ScrollableWidget(data: data); // Pass fetched data to your ScrollableWidget
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}


class ScrollableWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const ScrollableWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the fetched data to populate your ScrollableWidget
    return SizedBox(
      height: 200, // Adjust the height as needed
      child: PageView(
        scrollDirection: Axis.horizontal,
        children: data.map((item) {
          return Container(
            color: Colors.red, // Use data from MongoDB to customize container
            child: Center(
              child: Text(item['space'] ?? 'No title'),
            ),
          );
        }).toList(),
      ),
    );
  }
}
