//lib/features/auth/domain/entities/user.dart

class User {
  final String firebaseUid;
  final String email;
  final String displayName;
  final String? firstName;
  final String? lastName;
  final List<String>? days;
  final List<String>? reminders;

  const User({
    required this.firebaseUid,
    required this.email,
    required this.displayName,
    this.firstName,
    this.lastName,
    this.days,
    this.reminders,
  });

  User copyWith({
    String? firebaseUid,
    String? email,
    String? displayName,
    String? firstName,
    String? lastName,
    List<String>? days,
    List<String>? reminders,
  }) {
    return User(
      firebaseUid: firebaseUid ?? this.firebaseUid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      days: days ?? this.days,
      reminders: reminders ?? this.reminders,
    );
  }
}