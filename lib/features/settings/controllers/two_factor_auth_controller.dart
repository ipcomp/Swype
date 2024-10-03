import 'package:dio/dio.dart';
import 'package:swype/routes/api_routes.dart';
import 'package:swype/utils/dio/dio_client.dart';
import 'package:swype/utils/helpers/helper_functions.dart';

class TwoFactorAuthController {
  final DioClient dioClient = DioClient();

  Future<bool> enableTwoFactorAuth(context) async {
    try {
      final response = await dioClient.postWithoutData(
        ApiRoutes.enableTwoFactor,
      );

      // Handle the response
      if (response.statusCode == 200) {
        print(response.data['message'] ?? '2FA updated successfully');

        CHelperFunctions.showToaster(
          context,
          response.data['message'] ?? '2FA updated successfully',
        );
        return true; // Success
      } else {
        CHelperFunctions.showToaster(
          context,
          response.data['message'] ?? 'Invalid verification code',
        );
        return false;
      }
    } on DioException catch (e) {
      print('Error: ${e.response?.statusCode} - ${e.message}');
      return false;
    } catch (e) {
      print('An error occurred: $e');
      return false; // Failure due to generic errors
    }
  }

  Future<bool> verifyTwoFactorAuth(data, context) async {
    for (var field in data.fields) {
      print('Field name: ${field.key}, Value: ${field.value}');
    }
    try {
      final response = await dioClient.postWithFormData(
        ApiRoutes.verifyTwoFactor,
        data,
      );
      // Handle the response
      if (response.statusCode == 200) {
        print(response.data);
        if (response.data['status_code'] == 200) {
          CHelperFunctions.showToaster(
            context,
            response.data['message'] ?? '2FA updated successfully',
          );
          print('Two-factor authentication enabled successfully.');
          return true;
        } else {
          print('Failed to enable two-factor authentication.');

          CHelperFunctions.showToaster(
            context,
            response.data['message'] ?? 'Invalid verification code',
          );
          return false;
        }
      } else {
        print('Failed to enable two-factor authentication.');

        CHelperFunctions.showToaster(
          context,
          response.data['message'] ?? 'Invalid verification code',
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

  Future<bool> disableTwoFactorAuth(context) async {
    try {
      final response = await dioClient.postWithoutData(
        ApiRoutes.disableTwoFactor,
      );
      // Handle the response
      if (response.statusCode == 200) {
        CHelperFunctions.showToaster(
          context,
          response.data['message'] ?? '2FA Disabled successfully',
        );
        print('Two-factor authentication disabled successfully.');
        return true;
      } else {
        print('Failed to disable two-factor authentication.');
        CHelperFunctions.showToaster(
          context,
          response.data['message'] ?? 'Error while disabling!',
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
