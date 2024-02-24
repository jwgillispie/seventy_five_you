import 'package:mongo_dart/mongo_dart.dart';
import 'package:seventy_five_hard/features/presentation/mongoDBHelper/mongo_db_constants.dart';

class MongoDBService {
  late Db _db;
  late DbCollection _collection;

  MongoDBService() {
    _connectToDatabase();
  }

  Future<void> _connectToDatabase() async {
    try {
      _db = await Db.create(CONNECTION_URL);
      await _db.open();
      _collection = _db.collection(USER_COLLECTION);
    } catch (e) {
      print('Failed to connect to MongoDB: $e');
    }
  }

Future<List<Map<String, dynamic>>> fetchData() async {
  try {
    final query = SelectorBuilder();
    final data = await _collection.find(query).toList();
    return data.map((doc) => doc).toList();
  } catch (e) {
    print('Error fetching data from MongoDB: $e');
    return [];
  }
}


  // Add other methods for CRUD operations, etc.
}
