import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swype/routes/api_routes.dart';
import 'package:swype/utils/dio/dio_client.dart';

class MatchScreenController {
  DioClient dioClient = DioClient();

  Future<bool> fetchMyMatches(WidgetRef ref) async {
    try {
      final response = await dioClient.get(ApiRoutes.myMatches);
      final data = response.data;
      if (data['status_code'] == 200) {
        if (data['data'].isNotEmpty) {
          // final MatchesData myMatches = MatchesData.fromJson(data['data']);
          // print(myMatches.matches['id']!);
          // ref.read(matchesProvider.notifier).setMyMatches(myMatches);
        }
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
