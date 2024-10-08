import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_animation_transition/animations/fade_animation_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:swype/features/authentication/login/screens/onboarding/onboarding_screen.dart';
import 'package:swype/features/authentication/register/controllers/register_controller.dart';
import 'package:swype/routes/app_routes.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/constants/image_strings.dart';
import 'package:swype/utils/helpers/helper_functions.dart';

class RegistrationSelector extends ConsumerStatefulWidget {
  const RegistrationSelector({super.key});

  @override
  RegistrationSelectorState createState() => RegistrationSelectorState();
}

class RegistrationSelectorState extends ConsumerState<RegistrationSelector> {
  final RegisterController registerController = RegisterController();

  Future<void> _socialLogin(String socialType) async {
    if (socialType == 'google') {
      // final result = await loginController.googleSignInMethod(ref, context);
      await registerController.googleSignInMethod(ref, context);
    } else if (socialType == 'apple') {
      await registerController.appleSignInMethod(ref, context);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translations = CHelperFunctions().getTranslations(ref);
    return PopScope(
      canPop: Platform.isAndroid ? false : true,
      onPopInvokedWithResult: (didPop, result) {
        Platform.isAndroid
            ? Navigator.pushReplacement(
                context,
                PageAnimationTransition(
                  page: const OnboardingScreen(),
                  pageAnimationType: FadeAnimationTransition(),
                ),
              )
            : null;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Image.asset(ImageStrings.mainLogo, height: 137),
                const SizedBox(height: 79),
                Text(
                  translations?['Sign up to continue'] ?? "Sign up to continue",
                  style: TextStyle(
                    color: CColors.secondary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                  ),
                ),
                // Email TextField
                const SizedBox(height: 30),
                // Sign In Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.register);
                    },
                    child: Text(
                      translations?['Continue with email'] ??
                          "Continue with email",
                    ),
                  ),
                ),
                const SizedBox(height: 120),
                Row(
                  children: <Widget>[
                    const Expanded(child: Divider(thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(translations?['or register with'] ??
                          "or register with"),
                    ),
                    const Expanded(child: Divider(thickness: 1)),
                  ],
                ),
                const SizedBox(height: 30),
                // Social Media Sign In Buttons
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20.0,
                  children: [
                    // Facebook Button
                    Container(
                      height: 64,
                      width: 64,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFE8E6EA),
                          width: 1, // Border width
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: InkWell(
                        onTap: () {
                          _socialLogin("facebook");
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        child: SvgPicture.asset(
                          'assets/svg/facebook.svg',
                        ),
                      ),
                    ),

                    // Google Button
                    Container(
                      height: 64,
                      width: 64,
                      padding: const EdgeInsets.all(18.3),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFE8E6EA),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: InkWell(
                        onTap: () {
                          _socialLogin("google");
                        },
                        borderRadius: BorderRadius.circular(15),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: SvgPicture.asset(
                          'assets/svg/google.svg',
                          height: 28,
                          width: 28,
                        ),
                      ),
                    ),

                    // Apple Button
                    if (Platform.isIOS)
                      Container(
                        height: 64,
                        width: 64,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFE8E6EA),
                            width: 1, // Border width
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: InkWell(
                          onTap: () {
                            _socialLogin("apple");
                          },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                          child: SvgPicture.asset(
                            'assets/svg/apple.svg',
                            height: 32,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Navigate to Terms of Use
                      },
                      child: Text(
                        translations?['Terms of use'] ?? 'Terms of use',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(width: 32),
                    TextButton(
                      onPressed: () {
                        // Navigate to Privacy Policy
                      },
                      child: Text(
                        translations?['Privacy Policy'] ?? 'Privacy Policy',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
