import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swype/features/authentication/login/controllers/login_controller.dart';
import 'package:swype/features/authentication/login/screens/onboarding/onboarding_screen.dart';
import 'package:swype/features/home/screens/discover_screen.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/constants/image_strings.dart';
import 'package:swype/utils/helpers/helper_functions.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final LoginController loginController = LoginController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  Future<void> _socialLogin(String socialType) async {
    if (socialType == 'google') {
      setState(() {
        _isLoading = true;
      });
      final result = await loginController.googleSignInMethod(ref, context);
      if (result) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const DiscoverScreen()),
          (Route<dynamic> route) => false,
        );
      }
      setState(() {
        _isLoading = false;
      });
    } else if (socialType == 'facebook') {
      // await ref.read(authServiceProvider).facebookSignInMethod();
    }
  }

  void _signIn() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final result = await loginController.signInWithEmail(
        _emailController.text,
        _passwordController.text,
        ref,
        context,
      );
      if (result) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const DiscoverScreen()),
          (Route<dynamic> route) => false,
        );
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                MaterialPageRoute(
                  builder: (context) => const OnboardingScreen(),
                ),
              )
            : null;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  Image.asset(ImageStrings.mainLogo, height: 137),
                  const SizedBox(height: 12),
                  Text(
                    translations['Sign In'] ?? 'Sign In',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 28),
                  // Email TextField
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: translations['Email'] ?? 'Email',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return translations['Please enter your email'] ??
                            'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Password TextField
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: translations['Password'] ?? "Password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        color: CColors.borderColor,
                        iconSize: 21,
                        style: const ButtonStyle(
                          splashFactory: NoSplash.splashFactory,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return translations['Please enter your password'] ??
                            'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  // Sign In Button
                  SizedBox(
                    width: double.infinity,
                    child: _isLoading
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: CColors.primary,
                            ),
                            height: 56,
                            child: const Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    "Loading...",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        : ElevatedButton(
                            onPressed: _signIn,
                            child: Text(translations['Submit'] ?? 'Submit'),
                          ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: <Widget>[
                      const Expanded(child: Divider(thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(translations['or sign in with'] ??
                            "or sign in with"),
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
                              // Handle apple sign-in
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
                          translations['Terms of use'] ?? 'Terms of use',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(width: 32),
                      TextButton(
                        onPressed: () {
                          // Navigate to Privacy Policy
                        },
                        child: Text(
                          translations['Privacy Policy'] ?? 'Privacy Policy',
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
      ),
    );
  }
}
