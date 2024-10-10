import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swype/features/matches/models/matches_dummy_data.dart';
import 'package:swype/features/matches/models/matches_modal.dart';
import 'package:swype/features/matches/provider/matches_provider.dart';
import 'package:swype/routes/api_routes.dart';
import 'package:swype/utils/dio/dio_client.dart';
import 'package:swype/utils/helpers/helper_functions.dart';

class MatchScreenController {
  final DioClient dioClient;

  MatchScreenController({DioClient? dioClient})
      : dioClient = dioClient ?? DioClient();

  Future<MatchModal?> fetchMatchUsers(BuildContext context) async {
    try {
      final response = await dioClient.get(ApiRoutes.myMatches);
      final data = response.data;

      print('Data $data');

      if (data['status_code'] == 200) {
        // CHelperFunctions.showToaster(context, data['message']);

        return MatchModal.fromJson(data['data']);
      } else {
        print(data['message']);
        CHelperFunctions.showToaster(context, data['message']);

        return null;
      }

      // return dummyMatchModal;
    } catch (e) {
      print("Error: $e");

      return null;
    }
  }

  Future<bool> swipeUser(BuildContext context, WidgetRef ref, FormData formData,
      MatchModalItem match) async {
    try {
      final response =
          await dioClient.postWithFormData(ApiRoutes.swipe, formData);

      final data = response.data;

      print('Data $data');

      if (data['status_code'] == 200) {
        CHelperFunctions.showToaster(context, data['message']);

        String likedValue =
            formData.fields.firstWhere((entry) => entry.key == 'liked').value;
        if (!match.isMatch) {
          if (likedValue == 'like') {
            ref.read(matchesProvider.notifier).addMatch(match);
            ref.read(matchesProvider.notifier).removeSwipeReceived(match.id);
          } else {
            ref.read(matchesProvider.notifier).removeSwipeReceived(match.id);
          }
        }
        return true;
      } else {
        print(data['message']);
        CHelperFunctions.showToaster(context, data['message']);
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }
}
