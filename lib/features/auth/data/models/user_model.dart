// lib/features/auth/data/models/user_model.dart

import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required String firebaseUid,
    required String email,
    required String displayName,
    String? firstName,
    String? lastName,
    List<String>? days,
    List<String>? reminders,
  }) : super(
          firebaseUid: firebaseUid,
          email: email,
          displayName: displayName,
          firstName: firstName,
          lastName: lastName,
          days: days,
          reminders: reminders,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firebaseUid: json['firebase_uid'],
      email: json['email'],
      displayName: json['display_name'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      days: List<String>.from(json['days'] ?? []),
      reminders: List<String>.from(json['reminders'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firebase_uid': firebaseUid,
      'email': email,
      'display_name': displayName,
      'first_name': firstName,
      'last_name': lastName,
      'days': days,
      'reminders': reminders,
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      firebaseUid: user.firebaseUid,
      email: user.email,
      displayName: user.displayName,
      firstName: user.firstName,
      lastName: user.lastName,
      days: user.days,
      reminders: user.reminders,
    );
  }
}