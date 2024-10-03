import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final registerProvider =
    StateNotifierProvider<RegisterStateNotifier, Map<String, dynamic>>((ref) {
  return RegisterStateNotifier();
});

class RegisterStateNotifier extends StateNotifier<Map<String, dynamic>> {
  RegisterStateNotifier()
      : super({
          'token': null,
          'id': null,
          'name': null,
          'email': null,
          'phone': null,
          'isRegistered': false,
          'isOtpVerified': false,
          'isDetailsFilled': false,
          'isPreferencesUpdated': false,
        }) {
    loadUser();
  }

  // Load user data from SharedPreferences
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final id = prefs.getString('id');
    final name = prefs.getString('userName');
    final email = prefs.getString('userEmail');
    final phone = prefs.getString('userPhone');
    final isRegistered = prefs.getBool('isRegistered') ?? false;
    final isOtpVerified = prefs.getBool('isOtpVerified') ?? false;
    final isDetailsFilled = prefs.getBool('isDetailsFilled') ?? false;
    final isPreferencesUpdated = prefs.getBool('isPreferencesUpdated') ?? false;

    state = {
      'token': token,
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'isRegistered': isRegistered,
      'isOtpVerified': isOtpVerified,
      'isDetailsFilled': isDetailsFilled,
      'isPreferencesUpdated': isPreferencesUpdated, // Set in state
    };
  }

  // Save user information (including token, name, email, and phone)
  Future<void> saveUserInfo(
      String token, String id, String name, String email, String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('id', id);
    await prefs.setString('userName', name);
    await prefs.setString('userEmail', email);
    await prefs.setString('userPhone', phone);

    state = {
      ...state,
      'token': token,
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }

  // Update isRegistered
  Future<void> updateIsRegistered(bool isRegistered) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRegistered', isRegistered);
    state = {
      ...state,
      'isRegistered': isRegistered,
    };
  }

  // Update isOtpVerified
  Future<void> updateIsOtpVerified(bool isOtpVerified) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOtpVerified', isOtpVerified);
    state = {
      ...state,
      'isOtpVerified': isOtpVerified,
    };
  }

  // Update isDetailsFilled
  Future<void> updateIsDetailsFilled(bool isDetailsFilled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDetailsFilled', isDetailsFilled);
    state = {
      ...state,
      'isDetailsFilled': isDetailsFilled,
    };
  }

  // Update isPreferencesUpdated
  Future<void> updateIsPreferencesUpdated(bool isPreferencesUpdated) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPreferencesUpdated', isPreferencesUpdated);
    state = {
      ...state,
      'isPreferencesUpdated': isPreferencesUpdated, // Update state
    };
  }

  // Clear user data (logout)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('name');
    await prefs.remove('email');
    await prefs.remove('phone');
    await prefs.remove('isRegistered');
    await prefs.remove('isOtpVerified');
    await prefs.remove('isDetailsFilled');
    await prefs.remove('isPreferencesUpdated');
    state = {
      'token': null,
      'name': null,
      'email': null,
      'phone': null,
      'isRegistered': false,
      'isOtpVerified': false,
      'isDetailsFilled': false,
      'isPreferencesUpdated': false,
    };
  }
}
