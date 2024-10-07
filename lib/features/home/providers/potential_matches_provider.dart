import 'package:flutter_riverpod/flutter_riverpod.dart';

final potentialMatchesProvider = StateNotifierProvider<PotentialMatchesProvider,
    List<Map<String, dynamic>>?>((ref) {
  return PotentialMatchesProvider();
});

class PotentialMatchesProvider
    extends StateNotifier<List<Map<String, dynamic>>?> {
  PotentialMatchesProvider() : super(null);

  void setPotentialMatches(List<Map<String, dynamic>> matches) {
    state = matches;
  }

  void addMatch(Map<String, dynamic> match) {
    state = [...?state, match];
  }

  void removeMatch(Map<String, dynamic> match) {
    state = state?.where((existingMatch) => existingMatch != match).toList();
  }

  void clearPotentialMatches() {
    state = null;
  }
}
