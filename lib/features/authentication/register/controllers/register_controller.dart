import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_animation_transition/animations/fade_animation_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:swype/features/authentication/providers/register_provider.dart';
import 'package:swype/features/authentication/register/screens/otp_verification_screen.dart';
import 'package:swype/features/authentication/register/screens/register_screen.dart';
import 'package:swype/routes/api_routes.dart';
import 'package:swype/utils/helpers/helper_functions.dart';
import 'package:swype/utils/preferences/preferences_provider.dart';

class RegisterController {
  final Dio _dio = Dio();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

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
    String? socialId,
    String? socialType,
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
        "social_id": socialId ?? "",
        "social_type": socialType ?? ""
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
            context,
            translations[data['message']] ?? data['message'],
          );
        }
      } else {
        CHelperFunctions.showToaster(
          context,
          translations[response.statusMessage ?? "Something went wrong"],
        );
      }
    } catch (e) {
      print(e);
      CHelperFunctions.showToaster(
          context, 'Registration failed. Please try again.');
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
          "email": email,
        });

        if (response.statusCode == 200) {
          final data = response.data;
          if (data["status_code"] == 400) {
            Navigator.push(
              context,
              PageAnimationTransition(
                page: RegistrationScreen(
                  email: email,
                  username: username,
                  socialId: socialId,
                  socialType: "Gmail",
                ),
                pageAnimationType: FadeAnimationTransition(),
              ),
            );
            return false;
          } else {
            CHelperFunctions.showToaster(context, "User already registered");
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
