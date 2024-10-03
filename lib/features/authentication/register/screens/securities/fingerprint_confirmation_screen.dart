import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:swype/routes/app_routes.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/helpers/helper_functions.dart';
import 'package:swype/utils/preferences/preferences_provider.dart'; // Assuming your color constants

class FingerprintConfirmationScreen extends ConsumerStatefulWidget {
  const FingerprintConfirmationScreen({Key? key}) : super(key: key);

  @override
  _FingerprintConfirmationScreenState createState() =>
      _FingerprintConfirmationScreenState();
}

class _FingerprintConfirmationScreenState
    extends ConsumerState<FingerprintConfirmationScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticating = false;
  String _authorized = "Not authorized";

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = "Authenticating...";
      });

      authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate with your fingerprint to confirm',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      setState(() {
        _isAuthenticating = false;
        _authorized = authenticated ? "Authorized" : "Not authorized";
      });

      if (authenticated) {
        ref.read(preferencesProvider.notifier).setLocalAuth(authenticated);
        CHelperFunctions.showToaster(context, "Authentication Success");
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.home,
          ModalRoute.withName(AppRoutes.splash),
        );
      } else {
        CHelperFunctions.showToaster(context, "Authentication Failed");
      }
    } catch (e) {
      setState(() {
        _isAuthenticating = false;
        _authorized = "Error - ${e.toString()}";
      });
      CHelperFunctions.showToaster(context, "Authentication Failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // App logo
              const SizedBox(height: 30),
              const Image(
                image: AssetImage('assets/images/main_logo.png'),
                height: 90,
              ),
              const SizedBox(height: 60),
              Text(
                "Use Your FInger",
                style: TextStyle(
                  color: CColors.secondary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 45),

              // Fingerprint icon
              SvgPicture.asset(
                'assets/svg/fingerprint_icon.svg',
                height: 155,
              ),
              const SizedBox(height: 60),

              // Confirmation Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isAuthenticating ? null : _authenticate,
                  child: const Text(
                    'Confirm',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Show the authentication result
              if (_authorized != 'Not authorized')
                Text(
                  _authorized,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
