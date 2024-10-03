import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swype/features/authentication/providers/user_provider.dart';
import 'package:swype/features/settings/screens/verify_otp_for_delete_account.dart';
import 'package:swype/routes/api_routes.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/dio/dio_client.dart';
import 'package:swype/utils/helpers/helper_functions.dart';
import 'package:swype/utils/helpers/loader_screen.dart';

class DeleteAccountScreen extends ConsumerStatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  _DeleteAccountScreenState createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
  final TextEditingController passwordController = TextEditingController();
  final DioClient dioClient = DioClient();
  bool isLoading = false;

  // Function to send OTP
  Future<void> sendOtp(String phone) async {
    if (phone.isEmpty) {
      CHelperFunctions.showToaster(
          context, "Please Update your mobile Number!");
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Create FormData and add the phone number
    FormData formData = FormData.fromMap({
      'phone_number': phone,
    });

    try {
      // Send the POST request
      final response = await dioClient.postWithFormData(
          ApiRoutes.otpSendForDelete, formData);

      // Check if the response status is successful
      if (response.statusCode == 200) {
        final data = response.data;

        if (data['status_code'] == 200) {
          CHelperFunctions.showToaster(context, '${data['message']}');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyOtpForDeleteAccount(
                phoneNumber: phone,
              ),
            ),
          );
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
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final translations = CHelperFunctions().getTranslations(ref);
    return Scaffold(
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
            padding: const EdgeInsets.symmetric(horizontal: 5),
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
        child: isLoading
            ? SizedBox(
                height: MediaQuery.of(context)
                    .size
                    .height, // or another fixed height
                child: const LoaderScreen(gifPath: 'assets/gif/loader.gif'),
              )
            : Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      color: const Color(0xFFFDECEE),
                      margin: const EdgeInsets.only(top: 70),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'Delete Account',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: CColors.secondary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 70),
                    Center(
                      child: Text(
                        'Are You Sure ?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: CColors.secondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Center(
                        child: Text(
                          'If you want to delete this account. All the data will be erased.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: CColors.secondary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          sendOtp('${user?['phone']}');
                        },
                        child: Text(
                          "Send OTP",
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
                  ],
                ),
              ),
      ),
    );
  }
}
