import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swype/routes/api_routes.dart';
import 'package:swype/utils/dio/dio_client.dart';

// Update the provider to expect a List of maps
final allUsersProvider =
    StateNotifierProvider<AllUsersNotifier, List<Map<String, dynamic>>?>((ref) {
  return AllUsersNotifier();
});

// Change the state type to List<Map<String, dynamic>>?
class AllUsersNotifier extends StateNotifier<List<Map<String, dynamic>>?> {
  AllUsersNotifier() : super(null);

  DioClient dioClient = DioClient();

  Future<void> fetchUserList() async {
    try {
      final response = await dioClient.get(ApiRoutes.allUserList);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status_code'] == 200) {
          // Explicitly cast to List<Map<String, dynamic>>
          final List<Map<String, dynamic>> userList =
              List<Map<String, dynamic>>.from(data['data']);

          state = userList;
        } else {
          throw Exception(
              'Failed to load user list, status code: ${data['status_code']}');
        }
      } else {
        throw Exception(
            'Failed to load user list, response code: ${response.statusCode}');
      }
      print(response);
    } catch (e) {
      print('Error fetching user list: $e');
      state = null; // Optionally reset the state to null on error
    }
  }
}
