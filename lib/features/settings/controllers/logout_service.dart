import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_animation_transition/animations/fade_animation_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:swype/features/authentication/login/screens/onboarding/onboarding_screen.dart';
import 'package:swype/features/authentication/providers/auth_provider.dart';
import 'package:swype/features/authentication/providers/register_provider.dart';
import 'package:swype/features/authentication/providers/user_provider.dart';
import 'package:swype/features/home/providers/potential_matches_provider.dart';
import 'package:swype/routes/api_routes.dart';
import 'package:swype/utils/dio/dio_client.dart';

class LogoutService {
  DioClient dioClient = DioClient();

  Future<bool> logoutUser(WidgetRef ref, BuildContext context) async {
    try {
      final response = await dioClient.postWithoutData(ApiRoutes.logout);
      if (response.statusCode == 200) {
        if (response.data['status_code'] == 200) {
          Navigator.pushAndRemoveUntil(
            context,
            PageAnimationTransition(
              page: const OnboardingScreen(),
              pageAnimationType: FadeAnimationTransition(),
            ),
            ModalRoute.withName('/'),
          );
          await ref.read(authProvider.notifier).logout();
          await ref.read(registerProvider.notifier).logout();
          ref.read(potentialMatchesProvider.notifier).clearPotentialMatches();
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
