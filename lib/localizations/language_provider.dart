import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swype/utils/preferences/preferences_provider.dart';

final langProvider =
    StateNotifierProvider<LanguageNotifier, Map<String, Map<String, String>>?>(
  (ref) {
    return LanguageNotifier(ref);
  },
);

class LanguageNotifier
    extends StateNotifier<Map<String, Map<String, String>>?> {
  final Ref ref;

  LanguageNotifier(this.ref) : super({'en': {}, 'iw': {}});

  void setTranslations(Map<String, String> englishTranslation,
      Map<String, String> hebrewTranslation) {
    state = {
      'en': englishTranslation,
      'iw': hebrewTranslation,
    };
  }

  Map<String, String>? getTranslation() {
    final langCode = ref.read(preferencesProvider).preferredLanguage;

    return state?[langCode == "" || langCode == "iw" ? "iw" : "en"];
  }
}
