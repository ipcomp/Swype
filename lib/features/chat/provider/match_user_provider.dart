import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swype/features/chat/models/matches_use_modal.dart';
import 'package:swype/routes/api_routes.dart';
import 'package:swype/utils/dio/dio_client.dart';

// Define the provider
final matchUserProvider =
    StateNotifierProvider<MatchUserNotifier, MatchesUserModal>(
  (ref) => MatchUserNotifier(),
);

class MatchUserNotifier extends StateNotifier<MatchesUserModal> {
  MatchUserNotifier() : super(MatchesUserModal(matches: []));

  DioClient dioClient = DioClient();

  Future<void> fetchMatchesUser() async {
    try {
      final response = await dioClient.get(ApiRoutes.getMatchesUser);

      if (response.statusCode == 200) {
        final result = response.data;
        if (result['status_code'] == 200) {
          final data = result['data']['matches']; // Extract matches list
          state = MatchesUserModal.fromJson(
              {'matches': data}); // Pass matches to MatchesUserModal

          // print(result['data']['matches']);
        } else {
          throw Exception('Failed to load matches user');
        }
      } else {
        throw Exception('Failed to load matches user');
      }
    } catch (e) {
      print('Error fetching matches user: $e');
      state = MatchesUserModal(matches: []); // Set default empty state
    }
  }
}
