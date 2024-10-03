import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swype/features/authentication/providers/auth_provider.dart';
import 'package:swype/features/authentication/providers/register_provider.dart';
import 'package:swype/features/authentication/providers/user_provider.dart';
import 'package:swype/routes/api_routes.dart';
import 'package:swype/utils/dio/dio_client.dart';

class LogoutService {
  DioClient dioClient = DioClient();

  Future<bool> logoutUser(WidgetRef ref, BuildContext context) async {
    try {
      final response = await dioClient.postWithoutData(ApiRoutes.logout);
      if (response.statusCode == 200) {
        if (response.data['status_code'] == 200) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            ModalRoute.withName('/'),
          );
          await ref.read(authProvider.notifier).logout();
          await ref.read(registerProvider.notifier).logout();
          ref.read(userProvider.notifier).clearUser();
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (error) {
      print("Logout API error: $error");
      return false;
    }
  }
}
