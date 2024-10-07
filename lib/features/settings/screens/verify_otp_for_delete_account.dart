import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swype/features/authentication/providers/auth_provider.dart';
import 'package:swype/features/authentication/providers/register_provider.dart';
import 'package:swype/features/authentication/providers/user_provider.dart';
import 'package:swype/routes/api_routes.dart';
import 'package:swype/routes/app_routes.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/dio/dio_client.dart';
import 'package:swype/utils/helpers/helper_functions.dart';

class VerifyOtpForDeleteAccount extends ConsumerStatefulWidget {
  final String phoneNumber;

  const VerifyOtpForDeleteAccount({super.key, required this.phoneNumber});

  @override
  VerifyOtpForDeleteAccountState createState() =>
      VerifyOtpForDeleteAccountState();
}

class VerifyOtpForDeleteAccountState
    extends ConsumerState<VerifyOtpForDeleteAccount> with CodeAutoFill {
  String _otpCode = "";
  bool _isLoading = false; // Loader for OTP verification
  bool _isResendingOtp = false; // Loader for resending OTP
  final _formKey = GlobalKey<FormState>();
  DioClient dioClient = DioClient();
  String appSignature = "";

  @override
  void initState() {
    super.initState();
    listenForCode();
    generateAppSignature();
  }

  void generateAppSignature() async {
    final code = await SmsAutoFill().getAppSignature;
    setState(() {
      appSignature = code;
    });
  }

  @override
  void dispose() {
    cancel();
    super.dispose();
  }

  @override
  void codeUpdated() {
    setState(() {
      _otpCode = code ?? '';
    });

    if (_otpCode.length == 6) {
      _submitOtp(_otpCode);
    }
  }

  Future<void> _submitOtp(String otp) async {
    FocusScope.of(context).unfocus();
    if (_otpCode.length != 6) {
      CHelperFunctions.showToaster(context, 'Please enter a valid 6-digit OTP');
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      final formData = FormData.fromMap({
        'otp': otp,
        'phone_number': widget.phoneNumber,
      });
      final response = await dioClient.postWithFormData(
        ApiRoutes.otpVerifyForDelete,
        formData,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status_code'] == 200) {
          CHelperFunctions.showToaster(context, data['message']);
          ref.read(authProvider.notifier).logout();
          ref.read(userProvider.notifier).clearUser();
          ref.read(registerProvider.notifier).logout();
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.onboarding,
            (route) => false,
          );
        } else {
          CHelperFunctions.showToaster(context, data['message']);
        }
      } else {
        CHelperFunctions.showToaster(context, response.statusMessage!);
      }
    } catch (e) {
      CHelperFunctions.showToaster(context, 'Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> resendOtp() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _isResendingOtp = true;
    });

    FormData formData = FormData.fromMap({
      'phone_number': widget.phoneNumber,
      'hash_string': appSignature,
    });

    try {
      // Send the POST request
      final response = await dioClient.postWithFormData(
        ApiRoutes.resendOtpForDelete,
        formData,
      );

      // Check if the response status is successful
      if (response.statusCode == 200) {
        final data = response.data;

        if (data['status_code'] == 200) {
          CHelperFunctions.showToaster(context, '${data['message']}');
          print('OTP sent successfully: ${data['message']}');
        } else {
          CHelperFunctions.showToaster(context, '${data['message']}');
        }
      } else {
        // Handle non-200 status codes
        CHelperFunctions.showToaster(context,
            'Error: Failed to send OTP, status code: ${response.statusCode}');
      }
    } catch (e) {
      // Catch any errors during the API call
      print('Error occurred while sending OTP: $e');
      CHelperFunctions.showToaster(
          context, 'An error occurred while sending OTP.');
    } finally {
      setState(() {
        _isResendingOtp = false; // Hide resend OTP loader
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Text(
            'General Settings',
            style: TextStyle(
              color: CColors.secondary,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.5,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
              ),
              child: Text(
                'Back',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: CColors.primary,
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 150,
              ),
              Text(
                "Verification Code",
                style: TextStyle(
                  color: CColors.secondary,
                  fontSize: 20,
                  height: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: PinFieldAutoFill(
                  codeLength: 6,
                  currentCode: _otpCode,
                  onCodeChanged: (code) {
                    setState(() {
                      _otpCode = code ?? '';
                    });
                  },
                  decoration: BoxLooseDecoration(
                    textStyle: TextStyle(
                      fontSize: 24,
                      color: CColors.secondary,
                    ),
                    strokeColorBuilder: FixedColorBuilder(CColors.primary),
                  ),
                  onCodeSubmitted: (code) {
                    if (code.length == 6) {
                      _submitOtp(code);
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    resendOtp();
                  },
                  child: _isResendingOtp
                      ? SizedBox(
                          width: 24.0,
                          height: 24.0,
                          child: CircularProgressIndicator(
                            color: CColors.primary,
                            strokeWidth: 3.0,
                          ),
                        )
                      : Text(
                          "Resend OTP",
                          style: TextStyle(
                            color: CColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            height: 1.5,
                            decoration: TextDecoration.underline,
                            decorationColor: CColors.primary,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 26),
              SizedBox(
                width: double.infinity,
                child: _isLoading
                    ? ElevatedButton(
                        onPressed: () {},
                        child: const SizedBox(
                          width: 24.0,
                          height: 24.0,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3.0,
                          ),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          _submitOtp(_otpCode);
                        },
                        child: const Text('Delete Account'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
