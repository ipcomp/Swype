import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:swype/commons/widgets/custom_drop_down_with_names.dart';
import 'package:swype/features/authentication/providers/auth_provider.dart';
import 'package:swype/features/authentication/providers/register_provider.dart';
import 'package:swype/features/authentication/providers/user_provider.dart';
import 'package:swype/features/authentication/register/screens/add_additional_profile_data.dart';
import 'package:swype/features/authentication/register/screens/images_screen.dart';
import 'package:swype/features/settings/providers/user_options_provider.dart';
import 'package:swype/routes/api_routes.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/dio/dio_client.dart';
import 'dart:io';

import 'package:swype/utils/helpers/helper_functions.dart';

class ProfileDetailsScreen extends ConsumerStatefulWidget {
  const ProfileDetailsScreen({super.key});

  @override
  _ProfileDetailsScreenState createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends ConsumerState<ProfileDetailsScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  late AnimationController _controller;
  String selectedGender = 'Male';
  XFile? _profileImage;
  List<XFile?> _remainingImages = [];
  Dio dio = Dio();
  DioClient dioClient = DioClient();
  bool _isLoading = false;
  int _repeatCount = 0;
  final int _maxRepeatCount = 6;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _dateController.addListener(_onDateChanged);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _repeatCount++;
        if (_repeatCount < _maxRepeatCount) {
          _controller.reverse();
        } else {
          _controller.stop();
        }
      } else if (status == AnimationStatus.dismissed &&
          _repeatCount < _maxRepeatCount) {
        _controller.forward();
      }
    });
    _controller.forward();

    ref.read(profileOptionsProvider.notifier).fetchProfileOptions();
    Future.microtask(() async {
      final translations = await CHelperFunctions().getTranslations(ref);
      setState(() {
        selectedGender = translations['Male'];
      });
    });

    ref.read(registerProvider.notifier);
  }

  // Handle image picker
  Future<void> _pickImage() async {
    final List<XFile?> selectedImages = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MediaScreen(),
      ),
    );

    if (selectedImages.isNotEmpty) {
      setState(() {
        _profileImage = selectedImages.first;
        _remainingImages =
            selectedImages.sublist(1).where((image) => image != null).toList();
      });
    }
  }

  // // Submit profile details
  void _submitProfileDetails(translations) async {
    if (_formKey.currentState!.validate()) {
      if (_profileImage == null) {
        CHelperFunctions.showToaster(context, 'Please upload a profile image');
        return;
      }

      FocusScope.of(context).unfocus();
      setState(() {
        _isLoading = true;
      });

      String reversedDate =
          '${_dateController.text.split('/')[2]}-${_dateController.text.split('/')[1]}-${_dateController.text.split('/')[0]}';

      try {
        final registerNotifier = ref.read(registerProvider.notifier);
        final authNotifier = ref.read(authProvider.notifier);
        final user = ref.read(registerProvider);
        FormData formData = FormData.fromMap({
          'username': user['name'],
          'email': user['email'],
          'phone': user['phone'],
          'first_name': firstNameController.text,
          'last_name': lastNameController.text,
          'gender': selectedGender == translations['Male']
              ? "male"
              : selectedGender == translations['Female']
                  ? "female"
                  : "other",
          'date_of_birth': reversedDate,
          'profile_picture': await MultipartFile.fromFile(_profileImage!.path),
        });

        final response = await dio.post(
          ApiRoutes.updateUser,
          data: formData,
          options: Options(
            contentType: 'multipart/form-data',
            headers: {
              'Authorization': 'Bearer ${user['token']}',
            },
          ),
        );

        FormData imageData = FormData();

        for (int i = 0; i < _remainingImages.length; i++) {
          final file = File(_remainingImages[i]!.path);
          imageData.files.add(
            MapEntry('images[]', await MultipartFile.fromFile(file.path)),
          );
        }

        final result = await dio.post(
          ApiRoutes.uploadImages,
          data: imageData,
          options: Options(
            contentType: 'multipart/form-data',
            headers: {
              'Authorization': 'Bearer ${user['token']}',
            },
          ),
        );

        if (response.statusCode == 200 && result.statusCode == 200) {
          final data = response.data;
          if (data['status_code'] == 200) {
            await registerNotifier.updateIsDetailsFilled(true);
            await authNotifier.login(user['token'], '${user['id']}');
            ref.read(userProvider.notifier).setUser(data['data']['user']);
            // Navigator.of(context).pushAndRemoveUntil(
            //   MaterialPageRoute(builder: (context) => const UserPreferences()),
            //   (Route<dynamic> route) => false,
            // );
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const AddAdditionalProfileData(),
              ),
              (Route<dynamic> route) => false,
            );
          } else {
            CHelperFunctions.showToaster(context, data['message']);
          }
        } else {
          CHelperFunctions.showToaster(context, 'Error updating profile');
        }
      } catch (e) {
        print('Error: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  bool isAgeLessThan18(String dateOfBirth) {
    final birthDate = DateFormat('dd/MM/yyyy').parse(dateOfBirth);
    final today = DateTime.now();

    final eighteenYearsAgo = DateTime(today.year - 18, today.month, today.day);

    return birthDate.isAfter(eighteenYearsAgo);
  }

  @override
  void dispose() {
    _controller.dispose();
    _dateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translations = CHelperFunctions().getTranslations(ref);
    return PopScope(
      canPop: true,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    translations['Profile Details'] ?? "Profile Details",
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(26),
                          border: Border.all(
                            color: Colors.white,
                            width: 10,
                          ),
                        ),
                        height: 150,
                        width: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image(
                            image: _profileImage != null
                                ? FileImage(File(_profileImage!.path))
                                : const AssetImage('assets/images/blank.png')
                                    as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: ScaleTransition(
                          scale: Tween(begin: 1.0, end: 1.2).animate(
                            CurvedAnimation(
                              parent: _controller,
                              curve: Curves.easeInOut,
                            ),
                          ),
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: CColors.primary,
                              borderRadius: BorderRadius.circular(26),
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                            ),
                            child: TextButton(
                              onPressed: _pickImage,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(26),
                                ),
                              ),
                              child: SvgPicture.asset(
                                'assets/svg/camera.svg',
                                height: 19,
                                width: 19,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: firstNameController,
                    decoration: InputDecoration(
                        labelText: translations["First Name"] ?? "First Name*"),
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return translations["Please enter your first name"] ??
                            'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 21),
                  TextFormField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                        labelText: translations["Last Name"] ?? "Last Name*"),
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return translations["Please enter your last name"] ??
                            'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 21),
                  CustomDropdownBottomSheetWithNames(
                    title: translations["I am a"] ?? "I am a*",
                    items: [
                      translations["Male"] ?? "Male",
                      translations["Female"] ?? "Female",
                      translations["Others"] ?? "Others",
                    ],
                    initialValue: translations['Male'],
                    onItemSelected: (selectedItem) {
                      setState(() {
                        selectedGender = selectedItem;
                      });
                    },
                  ),
                  const SizedBox(height: 21),
                  birthDateField(translations),
                  const SizedBox(height: 60),
                  _isLoading
                      ? SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Center(
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              _submitProfileDetails(translations);
                            },
                            child: Text(translations["Confirm"] ?? 'Confirm'),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget birthDateField(translations) {
    return TextFormField(
      controller: _dateController,
      keyboardType: TextInputType.datetime,
      textInputAction: TextInputAction.done,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(8),
        DateInputFormatter(),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return translations["Please choose your birthday date"] ??
              'Please choose your birthday date';
        }
        if (isAgeLessThan18(_dateController.text.trim())) {
          return translations["You need to be 18+ to sign up!"] ??
              " You need to be 18+ to sign up!";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: translations['Date Of Birth'] ?? 'Date of Birth',
        hintText: translations['dd/mm/yyyy'] ?? 'dd/mm/yyyy',
        suffixIcon: _dateController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => _dateController.clear(),
              )
            : Padding(
                padding: const EdgeInsets.all(19.0),
                child: SvgPicture.asset(
                  'assets/svg/calender.svg',
                ),
              ),
      ),
    );
  }

  void _onDateChanged() {
    setState(() {}); // Trigger a rebuild to update the icon
  }
}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    if (newText.isEmpty) {
      return newValue;
    }

    newText = newText.replaceAll('/', '');

    if (newText.length >= 1 && int.tryParse(newText.substring(0, 1))! > 3) {
      return oldValue;
    }
    if (newText.length >= 2) {
      int day = int.tryParse(newText.substring(0, 2)) ?? 0;
      if (day > 31) {
        return oldValue;
      }
    }

    if (newText.length >= 3 && int.tryParse(newText.substring(2, 3))! > 1) {
      return oldValue;
    }
    if (newText.length >= 4) {
      int month = int.tryParse(newText.substring(2, 4)) ?? 0;
      if (month > 12) {
        return oldValue;
      }
    }

    if (newText.length > 2 && newText.length <= 4) {
      newText = '${newText.substring(0, 2)}/${newText.substring(2)}';
    } else if (newText.length > 4) {
      newText =
          '${newText.substring(0, 2)}/${newText.substring(2, 4)}/${newText.substring(4)}';
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
