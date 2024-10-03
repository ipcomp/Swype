import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swype/features/matches/data/match_data.dart';

final matchesProvider =
    StateNotifierProvider<MatchesNotifier, MatchesData>((ref) {
  return MatchesNotifier(ref);
});

class MatchesNotifier extends StateNotifier<MatchesData> {
  final Ref ref;

  MatchesNotifier(this.ref) : super([] as MatchesData);

  void setMyMatches(
    MatchesData myMatches,
  ) {
    state = myMatches;
  }
}
