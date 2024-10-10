import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swype/features/matches/models/matches_modal.dart';

class MatchModalNotifier extends StateNotifier<MatchModal> {
  MatchModalNotifier() : super(MatchModal(mergedItems: []));

  void loadMatchModal(MatchModal matchModal) {
    state = matchModal;
  }

  void addSwipeReceived(MatchModalItem swipe) {
    List<MatchModalItem> updatedMergedItems = [
      MatchModalItem(
        id: swipe.id,
        userId: swipe.userId,
        swipedAt: swipe.swipedAt,
        status: swipe.status,
        username: swipe.username,
        firstName: swipe.firstName,
        lastName: swipe.lastName,
        profilePictureUrl: swipe.profilePictureUrl,
        age: swipe.age,
        isMatch: false, // false since it's a received swipe
      ),
      ...state.mergedItems,
    ];

    state = MatchModal(mergedItems: updatedMergedItems);
  }

  void addMatch(MatchModalItem match) {
    List<MatchModalItem> updatedMergedItems = [
      MatchModalItem(
        id: match.id,
        userId: match.userId,
        swipedAt: match.swipedAt,
        status: match.status,
        username: match.username,
        firstName: match.firstName,
        lastName: match.lastName,
        profilePictureUrl: match.profilePictureUrl,
        age: match.age,
        isMatch: true, // true since it's a match
      ),
      ...state.mergedItems,
    ];

    state = MatchModal(mergedItems: updatedMergedItems);
  }

  void removeSwipeReceived(int id) {
    List<MatchModalItem> updatedMergedItems = state.mergedItems
        .where((item) =>
            !(item.id == id && !item.isMatch)) // Remove only swipes received
        .toList();

    state = MatchModal(mergedItems: updatedMergedItems);
  }

  void removeMatch(int id) {
    List<MatchModalItem> updatedMergedItems = state.mergedItems
        .where(
            (item) => !(item.id == id && item.isMatch)) // Remove only matches
        .toList();

    state = MatchModal(mergedItems: updatedMergedItems);
  }

  void clearMatchModal() {
    state = MatchModal(mergedItems: []);
  }
}

final matchesProvider = StateNotifierProvider<MatchModalNotifier, MatchModal>(
  (ref) => MatchModalNotifier(),
);
