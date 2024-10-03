import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swype/utils/preferences/user_preferences_model.dart';

class UserPreferencesNotifier extends StateNotifier<UserPreferencesModel> {
  UserPreferencesNotifier()
      : super(UserPreferencesModel(
          localAuthEnabled: false,
          preferredLanguage: '',
        )) {
    _loadPreferences();
  }

  // Load preferences from SharedPreferences
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    bool localAuthEnabled = prefs.getBool('localAuthEnabled') ?? false;
    String? preferredLanguage = prefs.getString('preferredLanguage') ?? '';

    state = UserPreferencesModel(
      localAuthEnabled: localAuthEnabled,
      preferredLanguage: preferredLanguage,
    );
  }

  // Update and save local authentication preference
  Future<void> setLocalAuth(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('localAuthEnabled', isEnabled);
    state = state.copyWith(localAuthEnabled: isEnabled);
  }

  // Update and save preferred language
  Future<void> setPreferredLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('preferredLanguage', language);
    state = state.copyWith(preferredLanguage: language);
  }
}

final preferencesProvider =
    StateNotifierProvider<UserPreferencesNotifier, UserPreferencesModel>((ref) {
  return UserPreferencesNotifier();
});
