import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swype/features/authentication/providers/user_provider.dart';
import 'package:swype/routes/api_routes.dart';
import 'package:swype/utils/dio/dio_client.dart';
import 'package:swype/utils/helpers/helper_functions.dart';

class ProfileEditController {
  DioClient dioClient = DioClient();

  Future<bool> editProfile(
      formData, WidgetRef ref, BuildContext context) async {
    try {
      final response =
          await dioClient.postWithFormData(ApiRoutes.updateUser, formData);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status_code'] == 200) {
          final user = data['data']['user'];
          ref.read(userProvider.notifier).setUser(user);
          CHelperFunctions.showToaster(context, data['message']);
          Navigator.pop(context);
          return true;
        } else {
          print(data['message']);
          CHelperFunctions.showToaster(context, data['message']);
          return false;
        }
      } else {
        print(response);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
