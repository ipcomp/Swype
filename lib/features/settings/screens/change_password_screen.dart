import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:swype/features/settings/controllers/change_password_controller.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/helpers/helper_functions.dart';
import 'package:swype/utils/helpers/loader_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;

  // Error messages for each field
  String? currentPasswordError;
  String? newPasswordError;
  String? confirmPasswordError;

  ChangePasswordController changePasswordController =
      ChangePasswordController();

  Future<void> updatePassword() async {
    final String currentPassword = currentPasswordController.text.trim();
    final String newPassword = newPasswordController.text.trim();
    final String confirmPassword = confirmPasswordController.text.trim();

    // Clear previous error messages
    setState(() {
      currentPasswordError = null;
      newPasswordError = null;
      confirmPasswordError = null;
    });

    // Validate form
    if (currentPassword.isEmpty) {
      setState(() {
        currentPasswordError = "Current password is required";
      });
      return;
    }

    if (newPassword.isEmpty) {
      setState(() {
        newPasswordError = "New password is required";
      });
      return;
    }

    if (confirmPassword.isEmpty) {
      setState(() {
        confirmPasswordError = "Please confirm your new password";
      });
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() {
        confirmPasswordError = "New password and confirmation do not match";
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    FormData formdata = FormData.fromMap({
      'current_password': currentPassword,
      'new_password': newPassword,
      "new_password_confirmation": confirmPassword,
    });

    try {
      final response =
          await changePasswordController.changePassword(formdata, context);

      if (response) {
        Navigator.pop(context);
      }
    } catch (error) {
      CHelperFunctions.showToaster(
        context,
        'Error: $error',
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          'General Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
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
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 65),
                  const Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Current Password Input
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: currentPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Current Password",
                        ),
                      ),
                      if (currentPasswordError != null)
                        Text(
                          currentPasswordError!,
                          style: const TextStyle(color: Colors.red),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // New Password Input
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: newPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "New Password",
                        ),
                      ),
                      if (newPasswordError != null)
                        Text(
                          newPasswordError!,
                          style: const TextStyle(color: Colors.red),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Confirm Password Input
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Confirm Password",
                        ),
                      ),
                      if (confirmPasswordError != null)
                        Text(
                          confirmPasswordError!,
                          style: const TextStyle(color: Colors.red),
                        ),
                    ],
                  ),
                  const SizedBox(height: 70),
                  // Update Password Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        updatePassword();
                      },
                      child: const Text('Update Password'),
                    ),
                  ),
                ],
              ),
              if (isLoading)
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: const LoaderScreen(gifPath: "assets/gif/loader.gif"),
                )
            ],
          ),
        ),
      ),
    );
  }
}
