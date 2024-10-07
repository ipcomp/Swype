import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:swype/features/authentication/providers/all_users_provider.dart';
import 'package:swype/features/authentication/providers/auth_provider.dart';
import 'package:swype/features/authentication/providers/register_provider.dart';
import 'package:swype/features/authentication/providers/user_provider.dart';
import 'package:swype/features/authentication/register/screens/otp_verification_screen.dart';
import 'package:swype/features/authentication/register/screens/profile_details_screen.dart';
import 'package:swype/routes/api_routes.dart';
import 'package:swype/utils/helpers/helper_functions.dart';

class LoginController {
  final Dio _dio = Dio();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  Future<bool> signInWithEmail(String email, String password, WidgetRef ref,
      BuildContext context) async {
    try {
      final response = await _dio.post(ApiRoutes.login, data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status_code'] == 200) {
          final user = data['data']['user'];
          final token = data['data']['access_token'];
          final id = user['id'];
          final name = user['username'];
          final phone = user['phone'];
          ref
              .read(registerProvider.notifier)
              .saveUserInfo(token, '$id', name, email, '$phone');
          if (user['phone_verified'] == 0) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => OtpVerificationScreen(
                  phoneNumber: user['phone'],
                ),
              ),
              (Route<dynamic> route) => false,
            );
            return false;
          } else if (user['first_name'] == null) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileDetailsScreen(),
              ),
              (Route<dynamic> route) => false,
            );
            return false;
          } else {
            final authToken = data['data']['access_token'];
            ref.read(authProvider.notifier).login(authToken, '${user['id']}');
            ref.read(userProvider.notifier).setUser(user);
            ref.read(allUsersProvider.notifier).fetchUserList();
            CHelperFunctions.showToaster(context, data['message']);
            return true;
          }
        } else {
          print('Login failed: ${data['message'] ?? 'Unknown error'}');
          CHelperFunctions.showToaster(context, data['message']);
          return false;
        }
      } else {
        print('HTTP error: ${response.statusCode} - ${response.statusMessage}');
        CHelperFunctions.showToaster(context, response.statusMessage!);
        return false;
      }
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  Future<bool> googleSignInMethod(WidgetRef ref, BuildContext context) async {
    try {
      await _googleSignIn.signOut();
      var result = await _googleSignIn.signIn();
      if (result != null) {
        String socialId = result.id;
        String email = result.email;
        String? username = result.displayName;
        final response = await _dio.post(ApiRoutes.socialLogin, data: {
          "social_type": 'Gmail',
          "social_id": "'$socialId'",
          "username": username,
          "email": email
        });

        if (response.statusCode == 200) {
          final data = response.data;
          if (data["status_code"] == 400) {
            CHelperFunctions.showToaster(
              context,
              "User not found with this email",
            );
            return false;
          } else if (data['status_code'] == 200) {
            final authToken = data['data']['access_token'];
            final userId = data['data']['user']['id'];
            ref.read(authProvider.notifier).login(authToken, '$userId');
            ref.read(userProvider.notifier).setUser(data['data']['user']);
            CHelperFunctions.showToaster(context, data['message']);
            return true;
          } else {
            print(data);
            CHelperFunctions.showToaster(context, data['message']);
            return false;
          }
        } else {
          print(response);
          CHelperFunctions.showToaster(context, response.data['message']);
          return false;
        }
      } else {
        print(result);
        return false;
      }
    } catch (error) {
      print(error);
      return false;
    }
  }
}
