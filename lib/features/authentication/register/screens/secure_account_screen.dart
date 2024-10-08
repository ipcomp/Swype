import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:page_animation_transition/animations/fade_animation_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:swype/features/authentication/register/screens/securities/face_id_confirmation_screen.dart';
import 'package:swype/features/authentication/register/screens/securities/fingerprint_confirmation_screen.dart';
import 'package:swype/routes/app_routes.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/helpers/helper_functions.dart';

class SecureAccountScreen extends ConsumerStatefulWidget {
  const SecureAccountScreen({super.key});

  @override
  _SecureAccountScreenState createState() => _SecureAccountScreenState();
}

class _SecureAccountScreenState extends ConsumerState<SecureAccountScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isBiometricSupported = false;
  bool _hasEnrolledBiometrics = false;
  bool _hasFingerprint = false;
  bool _hasFaceID = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    bool isSupported = await auth.isDeviceSupported();
    bool hasEnrolled = await auth.canCheckBiometrics;
    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    setState(() {
      _isBiometricSupported = isSupported;
      _hasEnrolledBiometrics = hasEnrolled;
      _hasFingerprint = availableBiometrics.contains(BiometricType.weak);
      _hasFaceID = availableBiometrics.contains(BiometricType.strong);
    });
  }

  @override
  Widget build(BuildContext context) {
    final translations = CHelperFunctions().getTranslations(ref);
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        const Image(
                          image: AssetImage('assets/images/main_logo.png'),
                          height: 90,
                        ),
                        const SizedBox(height: 25),
                        Text(
                          translations['Secure Your Account'] ??
                              "Secure Your Account",
                          style: TextStyle(
                            color: CColors.secondary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Conditionally render biometric buttons
                        if (_isBiometricSupported &&
                            _hasEnrolledBiometrics) ...[
                          if (_hasFingerprint) ...[
                            SvgPicture.asset('assets/svg/fingerprint_icon.svg'),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => {
                                  Navigator.of(context).push(
                                    PageAnimationTransition(
                                      page:
                                          const FingerprintConfirmationScreen(),
                                      pageAnimationType:
                                          FadeAnimationTransition(),
                                    ),
                                  )
                                },
                                child: Text(
                                  translations['Setup Fingerprint'] ??
                                      'Setup Fingerprint',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                          if (_hasFingerprint && _hasFaceID)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const Expanded(
                                  child: Divider(
                                    thickness: 1,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Center(
                                    child: Text(
                                      translations['Or'] ?? "Or",
                                      style: TextStyle(
                                        color: CColors.borderColor,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                const Expanded(
                                  child: Divider(
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 30),
                        ],

                        if (_hasFaceID) ...[
                          SvgPicture.asset('assets/svg/face_id_secure.svg'),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => {
                                Navigator.of(context).push(
                                  PageAnimationTransition(
                                    page: const FaceIdConfirmationScreen(),
                                    pageAnimationType:
                                        FadeAnimationTransition(),
                                  ),
                                )
                              },
                              child: Text(
                                translations['Setup Face ID'] ??
                                    'Setup Face ID',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoutes.home,
                              ModalRoute.withName(AppRoutes.splash),
                            );
                          },
                          child: Text(
                            translations['Skip'] ?? 'Skip',
                            style:
                                TextStyle(fontSize: 16, color: CColors.primary),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
