import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swype/features/authentication/login/controllers/splash_controller.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/constants/image_strings.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:swype/utils/preferences/preferences_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _scaleAnimation;
  late SplashController _splashController;
  String _version = '';

  @override
  void initState() {
    super.initState();

    _splashController = SplashController(ref);

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _getAppVersion();

    _controller.forward();
    _splashController.navigationHandler(context);
  }

  Future<void> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(preferencesProvider).preferredLanguage;
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: FadeTransition(
                    opacity: _animation,
                    child: Image.asset(
                      ImageStrings.mainLogo,
                      height: 150,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                FadeTransition(
                  opacity: _animation,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        lang == "en" ? "Welcome to" : 'ברוך הבא',
                        style: TextStyle(
                          color: CColors.secondary,
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Text(
                        lang == "en" ? "SWYPE" : 'לסוויפי',
                        style: TextStyle(
                          color: CColors.primary,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 120,
                )
              ],
            ),
          ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  Text(
                    lang == "en" ? "App Version" : "גרסת האפליקציה",
                    style: TextStyle(color: CColors.borderColor),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _version,
                    style: TextStyle(
                      color: CColors.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
