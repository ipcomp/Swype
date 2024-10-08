// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:dio/dio.dart';
// import 'package:swype/features/authentication/providers/register_provider.dart';
// import 'package:swype/features/authentication/register/screens/profile_details_screen.dart';
// import 'package:swype/routes/api_routes.dart';
// import 'package:swype/utils/constants/colors.dart';
// import 'package:swype/utils/helpers/helper_functions.dart';
// import 'package:swype/utils/helpers/loader_screen.dart';

// class OtpVerificationScreen extends ConsumerStatefulWidget {
//   final String phoneNumber;

//   const OtpVerificationScreen({super.key, required this.phoneNumber});

//   @override
//   _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
// }

// class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
//   final TextEditingController otpController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   int _timeRemaining = 60;
//   bool _isResendAvailable = false;
//   bool _isLoading = false;
//   Dio dio = Dio();
//   Timer? _timer;
//   int _resendAttempts = 0;
//   final int _maxResendAttempts = 3;

//   @override
//   void initState() {
//     super.initState();
//     startTimer();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel(); // Cancel the timer to prevent memory leaks
//     super.dispose();
//   }

//   // Timer for Resend OTP
//   void startTimer() {
//     _timer?.cancel();
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_timeRemaining > 0) {
//         if (!mounted) return; // Ensure widget is still mounted
//         setState(() {
//           _timeRemaining--;
//         });
//       } else {
//         if (!mounted) return; // Ensure widget is still mounted
//         setState(() {
//           _isResendAvailable = true;
//         });
//         timer.cancel(); // Stop the timer when countdown completes
//       }
//     });
//   }

//   // OTP Submit Handler
//   void _submitOtp() async {
//     FocusScope.of(context).unfocus();
//     if (_formKey.currentState?.validate() ?? false) {
//       setState(() {
//         _isLoading = true;
//       });

//       final user = ref.read(registerProvider);

//       final formData = FormData.fromMap({
//         'phone_number': user['phone'] ?? widget.phoneNumber,
//         'otp': otpController.text,
//       });

//       try {
//         final response = await dio.post(
//           ApiRoutes.verifyOTP,
//           data: formData,
//           options: Options(
//             contentType: 'multipart/form-data',
//           ),
//         );

//         if (response.statusCode == 200) {
//           final data = response.data;

//           if (data != null && data['status_code'] == 200) {
//             print(data);
//             await ref.read(registerProvider.notifier).updateIsOtpVerified(true);
//             CHelperFunctions.showToaster(context, data['message']);
//             Navigator.of(context).pushAndRemoveUntil(
//               MaterialPageRoute(
//                   builder: (context) => const ProfileDetailsScreen()),
//               (Route<dynamic> route) => false,
//             );
//           } else {
//             CHelperFunctions.showToaster(context, data['message']);
//             print('Invalid OTP or server response issue');
//           }
//         } else {
//           CHelperFunctions.showToaster(context, 'Unknown error');
//           print('Failed to verify OTP: ${response.statusCode}');
//         }
//       } catch (e) {
//         CHelperFunctions.showToaster(context, 'Unknown error');
//         print('Error: $e');
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   // Resend OTP Handler
//   void _resendOtp() async {
//     if (!_isResendAvailable || _resendAttempts >= _maxResendAttempts) return;

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final response = await dio.post(
//         ApiRoutes.resendOtpForDelete,
//         data: {'phone_number': widget.phoneNumber},
//       );

//       if (response.statusCode == 200) {
//         final data = response.data;
//         if (data['status_code'] == 200) {
//           setState(() {
//             _timeRemaining = 60; // Reset timer to 1 minute
//             _isResendAvailable = false;
//             _resendAttempts++;
//           });
//           startTimer();
//           CHelperFunctions.showToaster(context, data['message']);
//         } else {
//           CHelperFunctions.showToaster(context, data['message']);
//           print(data);
//         }
//       } else {
//         CHelperFunctions.showToaster(context, 'Failed to resend OTP');
//         print('Failed to resend OTP');
//       }
//     } catch (e) {
//       print('Error: $e');
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     int minutes = _timeRemaining ~/ 60;
//     int seconds = _timeRemaining % 60;

//     return Stack(
//       children: [
//         Scaffold(
//           body: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const SizedBox(height: 50),
//                   Row(
//                     children: [
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.popUntil(context, (route) => route.isFirst);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.transparent,
//                           padding: EdgeInsets.zero,
//                           minimumSize: const Size(52, 52),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           side: const BorderSide(
//                             color: Color(0xFFE8E6EA),
//                             width: 1.0,
//                           ),
//                           shadowColor: Colors.transparent,
//                         ),
//                         child: SvgPicture.asset('assets/svg/back_left.svg'),
//                       )
//                     ],
//                   ),
//                   const SizedBox(height: 42),
//                   Text(
//                     '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
//                     style: TextStyle(
//                       fontSize: 34,
//                       fontWeight: FontWeight.bold,
//                       color: CColors.secondary,
//                       height: 1.5,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   const Center(
//                     child: SizedBox(
//                       width: 215,
//                       child: Text(
//                         'Type the verification code we\'ve sent you',
//                         style: TextStyle(
//                           fontSize: 18,
//                           color: Color.fromRGBO(21, 33, 31, .7),
//                           height: 1.5,
//                           fontWeight: FontWeight.w400,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 102),
//                   const Text(
//                     'OTP via Phone',
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Color.fromRGBO(21, 33, 31, .7),
//                       height: 1.5,
//                       fontWeight: FontWeight.w400,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 13),
//                   Form(
//                     key: _formKey,
//                     child: PinCodeTextField(
//                       appContext: context,
//                       length: 6,
//                       animationType: AnimationType.fade,
//                       controller: otpController,
//                       onChanged: (value) {
//                         setState(() {});
//                       },
//                       pinTheme: PinTheme(
//                         shape: PinCodeFieldShape.box,
//                         borderRadius: BorderRadius.circular(10),
//                         fieldHeight: 48,
//                         fieldWidth: 48,
//                         activeColor: otpController.text.isNotEmpty
//                             ? CColors.primary
//                             : Colors.transparent,
//                         inactiveColor: const Color(0xFFE8E6EA),
//                         selectedColor: otpController.text.isNotEmpty
//                             ? CColors.primary
//                             : CColors.primary,
//                         activeFillColor: otpController.text.isNotEmpty
//                             ? CColors.primary
//                             : Colors.transparent,
//                         inactiveFillColor: Colors.transparent,
//                         selectedFillColor: otpController.text.isNotEmpty
//                             ? CColors.primary
//                             : Colors.transparent,
//                       ),
//                       keyboardType: TextInputType.number,
//                       backgroundColor: Colors.transparent,
//                       enableActiveFill: true,
//                       textStyle: TextStyle(
//                         color: otpController.text.isNotEmpty
//                             ? Colors.white
//                             : Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter the OTP';
//                         }
//                         return null;
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   if (_isResendAvailable)
//                     TextButton(
//                         onPressed: _resendOtp,
//                         child: Text(
//                           "Resend OTP",
//                           style: TextStyle(
//                             color: CColors.primary,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                             height: 1.5,
//                           ),
//                         )),
//                   const SizedBox(height: 40),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: _submitOtp,
//                       child: const Text('Verify OTP'),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//         // Fullscreen Loader
//         if (_isLoading)
//           const Positioned.fill(
//             child: SizedBox(
//               child: Center(
//                 child: LoaderScreen(gifPath: 'assets/gif/loader.gif'),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:dio/dio.dart';
import 'package:swype/features/authentication/providers/register_provider.dart';
import 'package:swype/features/authentication/register/screens/profile_details_screen.dart';
import 'package:swype/routes/api_routes.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/helpers/helper_functions.dart';
import 'package:swype/utils/helpers/loader_screen.dart';
import 'package:sms_autofill/sms_autofill.dart'; // Import sms_autofill package

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen>
    with CodeAutoFill {
  final TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _timeRemaining = 60;
  bool _isResendAvailable = false;
  bool _isLoading = false;
  Dio dio = Dio();
  Timer? _timer;
  int _resendAttempts = 0;
  final int _maxResendAttempts = 3;
  String appSignature = "";

  @override
  void initState() {
    super.initState();
    startTimer();
    generateAppSignature();
    listenForCode();
  }

  void generateAppSignature() async {
    final code = await SmsAutoFill().getAppSignature;
    setState(() {
      appSignature = code;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    cancel();
    super.dispose();
  }

  @override
  void codeUpdated() {
    setState(() {
      if (mounted) {
        otpController.text = code ?? '';
      }
    });
  }

  // Timer for Resend OTP
  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        if (!mounted) return;
        setState(() {
          _timeRemaining--;
        });
      } else {
        if (!mounted) return;
        setState(() {
          _isResendAvailable = true;
        });
        timer.cancel();
      }
    });
  }

  // OTP Submit Handler
  void _submitOtp() async {
    FocusScope.of(context).unfocus();
    if (otpController.text.length != 6) {
      CHelperFunctions.showToaster(context, 'Please enter a valid 6-digit OTP');
      return; // Exit the method if the OTP length is not valid
    }
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final user = ref.read(registerProvider);

      final formData = FormData.fromMap({
        'phone_number': user['phone'] ?? widget.phoneNumber,
        'otp': otpController.text,
      });

      try {
        final response = await dio.post(
          ApiRoutes.verifyOTP,
          data: formData,
          options: Options(
            contentType: 'multipart/form-data',
          ),
        );

        if (response.statusCode == 200) {
          final data = response.data;

          if (data != null && data['status_code'] == 200) {
            print(data);
            await ref.read(registerProvider.notifier).updateIsOtpVerified(true);
            CHelperFunctions.showToaster(context, data['message']);
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => const ProfileDetailsScreen()),
              (Route<dynamic> route) => false,
            );
          } else {
            CHelperFunctions.showToaster(context, data['message']);
            print('Invalid OTP or server response issue');
          }
        } else {
          CHelperFunctions.showToaster(context, 'Unknown error');
          print('Failed to verify OTP: ${response.statusCode}');
        }
      } catch (e) {
        CHelperFunctions.showToaster(context, 'Unknown error');
        print('Error: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Resend OTP Handler
  void _resendOtp() async {
    if (!_isResendAvailable || _resendAttempts >= _maxResendAttempts) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await dio.post(
        ApiRoutes.resendOtpForDelete,
        data: {
          'phone_number': widget.phoneNumber,
          "hash_string": appSignature,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status_code'] == 200) {
          setState(() {
            _timeRemaining = 60; // Reset timer to 1 minute
            _isResendAvailable = false;
            _resendAttempts++;
          });
          startTimer();
          CHelperFunctions.showToaster(context, data['message']);
        } else {
          CHelperFunctions.showToaster(context, data['message']);
          print(data);
        }
      } else {
        CHelperFunctions.showToaster(context, 'Failed to resend OTP');
        print('Failed to resend OTP');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int minutes = _timeRemaining ~/ 60;
    int seconds = _timeRemaining % 60;
    final translations = CHelperFunctions().getTranslations(ref);
    return PopScope(
      canPop: false,
      child: Stack(
        children: [
          Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            SystemNavigator.pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(52, 52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            side: const BorderSide(
                              color: Color(0xFFE8E6EA),
                              width: 1.0,
                            ),
                            shadowColor: Colors.transparent,
                          ),
                          child: SvgPicture.asset('assets/svg/back_left.svg'),
                        )
                      ],
                    ),
                    const SizedBox(height: 42),
                    Text(
                      '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: CColors.secondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: SizedBox(
                        width: 215,
                        child: Text(
                          translations[
                                  "Type the verification code we’ve sent you"] ??
                              "Type the verification code we’ve sent you",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color.fromRGBO(21, 33, 31, .7),
                            height: 1.5,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 102),
                    Text(
                      translations['OTP via Phone'] ?? 'OTP via Phone',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(21, 33, 31, .7),
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 13),
                    Form(
                      key: _formKey,
                      child: PinCodeTextField(
                        appContext: context,
                        length: 6,
                        animationType: AnimationType.fade,
                        controller: otpController,
                        onChanged: (value) {
                          setState(() {});
                        },
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(10),
                          fieldHeight: 48,
                          fieldWidth: 48,
                          activeColor: otpController.text.isNotEmpty
                              ? CColors.primary
                              : Colors.transparent,
                          inactiveColor: const Color(0xFFE8E6EA),
                          selectedColor: otpController.text.isNotEmpty
                              ? CColors.primary
                              : const Color(0xFFE8E6EA),
                        ),
                        animationDuration: const Duration(milliseconds: 300),
                      ),
                    ),
                    Visibility(
                      visible: _isResendAvailable,
                      child: TextButton(
                        onPressed: _resendOtp,
                        child: Text(
                          translations['Resend OTP'] ?? 'Resend OTP',
                          style: TextStyle(
                            color: CColors.primary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitOtp,
                        child: Text(
                          translations['Verify OTP'] ?? 'Verify OTP',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            const LoaderScreen(
              gifPath: "assets/gif/loader.gif",
            ),
        ],
      ),
    );
  }
}
