import 'package:flutter/material.dart';
import 'package:swype/routes/api_routes.dart';
import 'package:swype/utils/dio/dio_client.dart';
import 'package:swype/utils/helpers/helper_functions.dart';

class DiscoverController {
  DioClient dioClient = DioClient();

  Future<bool> fetchPotentialMatches(BuildContext context) async {
    try {
      final response = await dioClient.get(ApiRoutes.potentialMatches);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status_code'] != 200) {
          CHelperFunctions.showToaster(context, data['message']);
          return false;
        }
        return true;
      } else {
        CHelperFunctions.showToaster(context, response.statusMessage!);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
