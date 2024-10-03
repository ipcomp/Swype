import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:swype/routes/api_routes.dart';
import 'package:swype/utils/dio/dio_client.dart';
import 'package:swype/utils/helpers/helper_functions.dart';

class ChangePasswordController {
  DioClient dioClient = DioClient();

  Future<bool> changePassword(formdata, BuildContext context) async {
    try {
      final response = await dioClient.postWithFormData(
        ApiRoutes.updatePassword,
        formdata,
      );
      if (response.statusCode == 200) {
        if (response.data['status_code'] == 200) {
          CHelperFunctions.showToaster(
            context,
            response.data['message'],
          );
          return true;
        } else {
          CHelperFunctions.showToaster(
            context,
            response.data['message'],
          );
          return false;
        }
      } else {
        CHelperFunctions.showToaster(
          context,
          response.data['message'] ?? "Something went wrong!",
        );
        return false;
      }
    } on DioException catch (e) {
      // Handle Dio errors
      print('Error: ${e.response?.statusCode} - ${e.message}');
      return false;
    } catch (e) {
      // Handle any other errors
      print('An error occurred: $e');
      return false;
    }
  }
}
