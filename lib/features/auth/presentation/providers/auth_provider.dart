// lib/features/auth/presentation/providers/auth_provider.dart

import 'package:flutter/foundation.dart';
import 'package:seventy_five_hard/features/auth/domain/entities/user.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  User? _user;

  // Getters
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  User? get user => _user;

  // Methods
  void setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }

  void setUser(User? user) {
    if (_user != user) {
      _user = user;
      notifyListeners();
    }
  }

  void clearUser() {
    if (_user != null) {
      _user = null;
      notifyListeners();
    }
  }

  // Convenience method to update user data
  void updateUserData({
    String? displayName,
    String? firstName,
    String? lastName,
    List<String>? days,
    List<String>? reminders,
  }) {
    if (_user != null) {
      _user = _user!.copyWith(
        displayName: displayName,
        firstName: firstName,
        lastName: lastName,
        days: days,
        reminders: reminders,
      );
      notifyListeners();
    }
  }
}