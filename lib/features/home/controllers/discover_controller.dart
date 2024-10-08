import 'package:flutter/material.dart';
import 'package:swype/routes/api_routes.dart';
import 'package:swype/utils/dio/dio_client.dart';
import 'package:swype/utils/helpers/helper_functions.dart';

class DiscoverController {
  DioClient dioClient = DioClient();

  Future<List<Map<String, dynamic>>?> fetchPotentialMatches(
      BuildContext context) async {
    try {
      final response = await dioClient.get(ApiRoutes.potentialMatches);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status_code'] == 200) {
          final List<dynamic> rawMatches = data['data'];
          final List<Map<String, dynamic>> matches =
              rawMatches.map((match) => match as Map<String, dynamic>).toList();
          return matches;
        } else {
          return null;
        }
      } else {
        CHelperFunctions.showToaster(context, response.statusMessage!);
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
