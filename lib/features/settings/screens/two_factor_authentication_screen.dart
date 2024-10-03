import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:swype/features/authentication/providers/user_provider.dart';
import 'package:swype/features/settings/controllers/two_factor_auth_controller.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/helpers/helper_functions.dart';

class TwoFactorAuthenticationScreen extends ConsumerStatefulWidget {
  const TwoFactorAuthenticationScreen({super.key});

  @override
  _TwoFactorAuthenticationScreenState createState() =>
      _TwoFactorAuthenticationScreenState();
}

class _TwoFactorAuthenticationScreenState
    extends ConsumerState<TwoFactorAuthenticationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TwoFactorAuthController twoFactorAuthController =
      TwoFactorAuthController();
  Map<String, dynamic>? user;
  bool is2FAEnabled = false;
  bool isOtpSended = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  void fetchUser() async {
    final userData = ref.read(userProvider);
    if (userData != null) {
      setState(() {
        user = userData;
      });
    }
  }

  Future<void> toggle2FA(bool isEnabled) async {
    if (!mounted) return;

    setState(() {
      is2FAEnabled = isEnabled;
    });

    if (isEnabled) {
      final response =
          await twoFactorAuthController.enableTwoFactorAuth(context);
      if (response) {
        if (mounted) {
          setState(() {
            isOtpSended = true;
          });
        }
      }
    } else {
      await twoFactorAuthController.disableTwoFactorAuth(context);
      if (mounted) {
        setState(() {
          isOtpSended = false;
        });
      }
    }
  }

  Future<void> verify2FACode() async {
    if (!mounted) return;

    if (_formKey.currentState?.validate() ?? false) {
      final formData = FormData.fromMap({'token': _otpValue});
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      final isVerified =
          await twoFactorAuthController.verifyTwoFactorAuth(formData, context);
      if (mounted) {
        setState(() {
          is2FAEnabled = isVerified;
          isLoading = false;
          isOtpSended = false;
        });
      }
    }
  }

  String _otpValue = '';

  @override
  Widget build(BuildContext context) {
    final translations = CHelperFunctions().getTranslations(ref);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 75,
        title: Text(
          translations['General Settings'] ?? 'General Settings',
          style: TextStyle(
            color: CColors.secondary,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 1.5,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                splashFactory: NoSplash.splashFactory,
                elevation: WidgetStateProperty.all(0),
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                shadowColor: WidgetStateProperty.all(Colors.transparent),
              ),
              child: Container(
                height: 52,
                width: 52,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFFE8E6EA),
                  ),
                ),
                child: SvgPicture.asset(
                  'assets/svg/back_button.svg',
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 54),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Two - Factor Authentication',
                    style: TextStyle(
                      fontSize: 18,
                      color: CColors.secondary,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                    ),
                  ),
                  Switch(
                    value: is2FAEnabled,
                    onChanged: (bool value) {
                      toggle2FA(value);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 70),
              if (isOtpSended) ...[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Two - Factor Authentication',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: CColors.secondary,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        'Enter the Verification code from your authentication app.',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: CColors.secondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: PinCodeTextField(
                    appContext: context,
                    length: 6,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(10),
                      fieldHeight: 48,
                      fieldWidth: 48,
                      activeColor: _otpValue.isNotEmpty
                          ? CColors.primary
                          : const Color(0xFFE8E6EA),
                      inactiveColor: const Color(0xFFE8E6EA),
                      selectedColor: CColors.primary,
                      activeFillColor: _otpValue.isNotEmpty
                          ? CColors.primary
                          : Colors.transparent,
                      inactiveFillColor: Colors.transparent,
                      selectedFillColor: _otpValue.isNotEmpty
                          ? CColors.primary
                          : Colors.transparent,
                    ),
                    keyboardType: TextInputType.number,
                    backgroundColor: Colors.transparent,
                    enableActiveFill: true,
                    textStyle: TextStyle(
                      color: _otpValue.isNotEmpty ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _otpValue = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the OTP';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : verify2FACode,
                    child: isLoading
                        ? const SizedBox(
                            height: 24.0,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3.0,
                            ),
                          )
                        : const Text(
                            'Verify Code',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
