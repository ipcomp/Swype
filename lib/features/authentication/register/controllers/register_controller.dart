import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swype/features/authentication/providers/register_provider.dart';
import 'package:swype/features/authentication/register/screens/otp_verification_screen.dart';
import 'package:swype/routes/api_routes.dart';
import 'package:swype/utils/helpers/helper_functions.dart';
import 'package:swype/utils/preferences/preferences_provider.dart';

class RegisterController {
  final Dio _dio = Dio();

  // Function to register the user via API
  Future<void> registerUser(
    BuildContext context,
    WidgetRef ref,
    String username,
    String email,
    String password,
    String passwordConfirmation,
    String phone,
    bool agreedToTerms,
    String appSignature,
  ) async {
    final translations = CHelperFunctions().getTranslations(ref);
    try {
      final response = await _dio.post(ApiRoutes.register, data: {
        "username": username,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation,
        "phone": phone,
        "agreed_to_terms": agreedToTerms,
        "hash_string": appSignature,
      });

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['status_code'] == 200) {
          final userNotifier = ref.read(registerProvider.notifier);
          final token = data['data']['access_token'];
          final id = data['data']['user']['id'];
          final name = data['data']['user']['username'];
          final email = data['data']['user']['email'];
          final phone = data['data']['user']['phone'];
          await userNotifier.saveUserInfo(token, '$id', name, email, phone);
          await userNotifier.updateIsRegistered(true);
          ref.read(preferencesProvider.notifier).setLocalAuth(false);
          CHelperFunctions.showToaster(
              context, translations[data['message']] ?? data['message']);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerificationScreen(phoneNumber: phone),
            ),
          );
        } else {
          CHelperFunctions.showToaster(
              context, translations[data['message']] ?? data['message']);
        }
      } else {
        CHelperFunctions.showToaster(context,
            translations[response.statusMessage ?? "Something went wrong"]);
      }
    } catch (e) {
      print(e);
      CHelperFunctions.showToaster(
          context, 'Registration failed. Please try again.');
    }
  }
}
