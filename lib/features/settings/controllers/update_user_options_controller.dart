import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swype/features/authentication/providers/user_provider.dart';
import 'package:swype/routes/api_routes.dart';
import 'package:swype/utils/dio/dio_client.dart';
import 'package:swype/utils/helpers/helper_functions.dart';

class UpdateUserOptionsController {
  DioClient dioClient = DioClient();

  Future<bool> updateUserPreferences(
      formData, BuildContext context, WidgetRef ref) async {
    try {
      final response = await dioClient.postWithFormData(
          ApiRoutes.updatePreferences, formData);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status_code'] == 200) {
          ref.read(userProvider.notifier).setUser(data['data']['user']);
          CHelperFunctions.showToaster(context, data['message']);
          Navigator.pop(context);
          return true;
        } else {
          print(data);
          CHelperFunctions.showToaster(context, data['message']);
          return false;
        }
      } else {
        print(response);
        CHelperFunctions.showToaster(context, response.statusMessage!);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
