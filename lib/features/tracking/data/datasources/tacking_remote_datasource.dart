//lib/features/tracking/data/datasources/tracking_remote_datasource.dart

import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../models/water_tracking_model.dart';
import '../models/workout_tracking_model.dart';

abstract class TrackingRemoteDataSource {
  Future<WaterTrackingModel> getWaterTracking(String date);
  Future<WaterTrackingModel> updateWaterTracking(WaterTrackingModel tracking);
  Future<WorkoutTrackingModel> getWorkoutTracking(String date);
  Future<WorkoutTrackingModel> updateWorkoutTracking(WorkoutTrackingModel tracking);
}

class TrackingRemoteDataSourceImpl implements TrackingRemoteDataSource {
  final ApiClient _client;
  final FirebaseAuth _auth;

  TrackingRemoteDataSourceImpl({
    required ApiClient client,
    required FirebaseAuth auth,
  })  : _client = client,
        _auth = auth;

  @override
  Future<WaterTrackingModel> getWaterTracking(String date) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) throw const AuthException(message: 'Not authenticated');

      final response = await _client.get('/day/$uid/$date/water');
      return WaterTrackingModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<WaterTrackingModel> updateWaterTracking(WaterTrackingModel tracking) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) throw const AuthException(message: 'Not authenticated');

      final response = await _client.put(
        '/day/$uid/${tracking.date}/water',
        body: tracking.toJson(),
      );
      return WaterTrackingModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<WorkoutTrackingModel> getWorkoutTracking(String date) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) throw const AuthException(message: 'Not authenticated');

      final response = await _client.get('/day/$uid/$date/workout');
      return WorkoutTrackingModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<WorkoutTrackingModel> updateWorkoutTracking(WorkoutTrackingModel tracking) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) throw const AuthException(message: 'Not authenticated');

      final response = await _client.put(
        '/day/$uid/${tracking.date}/workout',
        body: tracking.toJson(),
      );
      return WorkoutTrackingModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}