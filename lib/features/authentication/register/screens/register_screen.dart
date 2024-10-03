import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:swype/features/authentication/register/controllers/register_controller.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/constants/image_strings.dart';
import 'package:swype/utils/helpers/helper_functions.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _username, _email, _password, _confirmPassword, _phone;
  bool _agreedToTerms = true;
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String appSignature = "";
  final RegisterController _registerController = RegisterController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
    _usernameController.dispose();
    super.dispose();
  }

  void _registerUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _registerController.registerUser(
          context,
          ref,
          utf8.encode(_username!) as String,
          _email!,
          _password!,
          _confirmPassword!,
          _phone!,
          _agreedToTerms,
          appSignature,
        );
      } catch (e) {
        CHelperFunctions.showToaster(context, 'Registration failed: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final translations = CHelperFunctions().getTranslations(ref);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  ImageStrings.mainLogo,
                  height: 100,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                translations['User Registration'] ?? 'User Registration',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 29),

              // Username Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: translations['User Name'] ?? "User Name",
                ),
                textCapitalization: TextCapitalization.words,
                onChanged: (value) {
                  setState(() {
                    _username = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return translations['Please enter your username'] ??
                        'Please enter your username';
                  }
                  return null;
                },
                onSaved: (value) => _username = value,
              ),

              const SizedBox(height: 16),

              // Email Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: translations['Email'] ?? "Email",
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return translations['Please enter your email'] ??
                        'Please enter your email';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return translations['Please enter a valid email address'] ??
                        'Please enter a valid email address';
                  }
                  return null;
                },
                onSaved: (value) => _email = value,
              ),
              const SizedBox(height: 16),

              // Phone Number Field
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText:
                              translations['Phone Number'] ?? "Phone Number",
                          prefixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Country flag
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 21,
                                  right: 8,
                                ),
                                child: SvgPicture.asset(
                                  'assets/svg/country_flag.svg',
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 8.0,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '(+972)',
                                      style: TextStyle(
                                        color: CColors.secondary,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Text(
                                      " | ",
                                      style: TextStyle(
                                        color: Color.fromRGBO(21, 33, 31, .2),
                                        fontSize: 16,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return translations[
                                    'Please enter the phone number.'] ??
                                'Please enter the phone number.';
                          }
                          return null;
                        },
                        onSaved: (value) => _phone = value,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Password Field
              TextFormField(
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
                        splashFactory: NoSplash.splashFactory),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return translations['Please enter your password'] ??
                        'Please enter your password';
                  } else if (value.length < 6) {
                    return translations[
                            'Password must be at least 6 characters long.'] ??
                        'Password must be at least 6 characters long.';
                  }
                  return null;
                },
                onSaved: (value) => _password = value,
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Confirm Password Field
              TextFormField(
                decoration: InputDecoration(
                  labelText:
                      translations['Confirm Password'] ?? "Confirm Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    iconSize: 21,
                    color: CColors.borderColor,
                    style: const ButtonStyle(
                        splashFactory: NoSplash.splashFactory),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isConfirmPasswordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return translations['Please confirm your password'] ??
                        'Please confirm your password';
                  } else if (value != _password) {
                    return translations["Password doesn't match"] ??
                        "Password doesn't match";
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _confirmPassword = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Terms and Conditions Checkbox
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _agreedToTerms = !_agreedToTerms;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _agreedToTerms
                              ? CColors.primary
                              : CColors.textOpacity,
                          width: 1.2, // Border width
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      width: 20.0,
                      height: 20.0,
                      child: _agreedToTerms
                          ? Icon(
                              Icons.check,
                              size: 18.0,
                              color: CColors.primary,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Text(
                      translations[
                              "These terms and conditions outline the rules and regulations for the use of swype App, located at https://swype.co.il/"] ??
                          'These terms and conditions outline the rules and regulations for the use of swype App, located at https://swype.co.il/',
                      style: TextStyle(
                        color: CColors.textOpacity,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Submit Button
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
                          FocusScope.of(context).unfocus();
                          if (_formKey.currentState!.validate()) {
                            if (!_agreedToTerms) {
                              CHelperFunctions.showToaster(
                                context,
                                translations[
                                        'You must agree to the terms and conditions.'] ??
                                    "You must agree to the terms and conditions",
                              );
                            } else {
                              _formKey.currentState!.save();
                              _registerUser();
                            }
                          }
                        },
                        child: Text(translations['Register'] ?? "Register"),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
