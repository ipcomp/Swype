import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swype/routes/api_routes.dart';
import 'package:swype/utils/dio/dio_client.dart';

// Define the provider
final profileOptionsProvider = StateNotifierProvider<ProfileOptionsNotifier,
    Map<String, List<Map<String, dynamic>>>>(
  (ref) => ProfileOptionsNotifier(),
);

// StateNotifier to manage the profile options
class ProfileOptionsNotifier
    extends StateNotifier<Map<String, List<Map<String, dynamic>>>> {
  ProfileOptionsNotifier() : super({});

  DioClient dioClient = DioClient();

  Future<void> fetchProfileOptions() async {
    try {
      final response = await dioClient.get(ApiRoutes.userOptions);

      if (response.statusCode == 200) {
        final result = response.data;
        if (result['status_code'] == 200) {
          final data = response.data['data'] as Map<String, dynamic>;

          Map<String, List<Map<String, dynamic>>> parsedData = {};
          data.forEach((key, value) {
            if (value is List) {
              parsedData[key] = List<Map<String, dynamic>>.from(value);
            }
          });

          state = parsedData;
        } else {
          throw Exception('Failed to load profile options');
        }
      } else {
        throw Exception('Failed to load profile options');
      }
    } catch (e) {
      print('Error fetching profile options: $e');
      state = {};
    }
  }
}
