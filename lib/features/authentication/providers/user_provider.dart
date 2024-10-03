import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider =
    StateNotifierProvider<UserNotifier, Map<String, dynamic>?>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<Map<String, dynamic>?> {
  UserNotifier() : super(null);

  // Function to update the user data
  void setUser(Map<String, dynamic> userData) {
    state = userData;
  }

  // Function to clear the user data
  void clearUser() {
    state = null;
  }
}
