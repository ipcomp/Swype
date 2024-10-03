import 'package:carousel_slider/carousel_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swype/routes/app_routes.dart';

class OnboardingController {
  final CarouselSliderController carouselController =
      CarouselSliderController();
  final Dio dio = Dio();
  int currentPage = 0;

  // final List<Map<String, String>> onboardingData = [
  //   {
  //     "image": "assets/images/onboarding1.png",
  //     "title": "Algorithm",
  //     "description":
  //         "Uses a vetting process to ensure you meet real matches, not bots."
  //   },
  //   {
  //     "image": "assets/images/onboarding2.png",
  //     "title": "Matches",
  //     "description":
  //         "We match you with people who have a large amount of similar interests."
  //   },
  //   {
  //     "image": "assets/images/onboarding3.png",
  //     "title": "Premium",
  //     "description":
  //         "Sign up today and enjoy the first month of premium benefits on us."
  //   },
  // ];

  void handleRegister(BuildContext context) {
    if (currentPage == 2) {
      Navigator.pushReplacementNamed(context, AppRoutes.registerSelector);
    } else {
      carouselController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void handleLoginButton(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.login);
  }

  // Function to handle page change
  void onPageChanged(int index) {
    currentPage = index;
  }
}
