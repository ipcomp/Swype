import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:swype/commons/widgets/custom_drop_down_with_names.dart';
import 'package:swype/features/authentication/providers/auth_provider.dart';
import 'package:swype/features/authentication/providers/register_provider.dart';
import 'package:swype/features/authentication/providers/user_provider.dart';
import 'package:swype/features/authentication/register/screens/user_preferences.dart';
import 'package:swype/routes/api_routes.dart';
import 'package:swype/utils/constants/colors.dart';
import 'dart:io';

import 'package:swype/utils/helpers/helper_functions.dart';
import 'package:swype/utils/preferences/preferences_provider.dart';

class ProfileDetailsScreen extends ConsumerStatefulWidget {
  const ProfileDetailsScreen({super.key});

  @override
  _ProfileDetailsScreenState createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends ConsumerState<ProfileDetailsScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Use FormState
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  late AnimationController _controller;
  String selectedGender = 'Male';
  DateTime? selectedDate;
  XFile? _profileImage;
  Dio dio = Dio();
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

    final currentLang = ref.read(preferencesProvider).preferredLanguage;
    if (currentLang == "en") {
      setState(() {
        selectedGender = "Male";
      });
    } else {
      setState(() {
        selectedGender = "זכר";
      });
    }

    ref.read(registerProvider.notifier);
  }

  // Handle image picker
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _profileImage = pickedImage;
      });
    }
  }

  // Handle date picker for birthday
  Future<void> _selectDate(BuildContext context, translations) async {
    final DateTime today = DateTime.now();
    final DateTime eighteenYearsAgo =
        DateTime(today.year - 18, today.month, today.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: eighteenYearsAgo,
      firstDate: DateTime(1900),
      lastDate: eighteenYearsAgo,
      helpText:
          translations['Select Your Birth Date'] ?? 'Select Your Birth Date',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: CColors.primary,
              onPrimary: Colors.white,
              onSurface: CColors.textOpacity,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Submit profile details
  void _submitProfileDetails() async {
    if (_formKey.currentState!.validate()) {
      if (selectedDate == null) {
        CHelperFunctions.showToaster(
            context, 'Please choose your birthday date');
        return;
      }
      Map<String, String> genderMapping = {
        'זכר': 'male',
        'נקבה': 'female',
        'אחרים': 'others',
      };

      String? genderInEnglish = genderMapping.containsKey(selectedGender)
          ? genderMapping[selectedGender]
          : selectedGender;

      if (_profileImage == null) {
        CHelperFunctions.showToaster(context, 'Please upload a profile image');
        return;
      }

      FocusScope.of(context).unfocus();
      setState(() {
        _isLoading = true;
      });

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
          'gender': genderInEnglish,
          'date_of_birth': selectedDate != null
              ? DateFormat('yyyy-MM-dd').format(selectedDate!)
              : null,
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

        if (response.statusCode == 200) {
          final data = response.data;
          if (data['status_code'] == 200) {
            await registerNotifier.updateIsDetailsFilled(true);
            await authNotifier.login(user['token'], '${user['id']}');
            ref.read(userProvider.notifier).setUser(data['data']['user']);
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const UserPreferences()),
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

  @override
  void dispose() {
    _controller.dispose();
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
              key: _formKey, // Use the form key
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
                        height: 132,
                        width: 132,
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
                    initialValue: selectedGender,
                    onItemSelected: (selectedItem) {
                      setState(() {
                        selectedGender = selectedItem;
                      });
                    },
                  ),
                  const SizedBox(height: 21),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => _selectDate(context, translations),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(
                              color: CColors.primary,
                            )),
                        backgroundColor: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/svg/calender.svg'),
                            const SizedBox(width: 20),
                            Text(
                              selectedDate == null
                                  ? translations["Choose birthday date"] ??
                                      'Choose birthday date*'
                                  : DateFormat('dd/MM/yyyy')
                                      .format(selectedDate!),
                              style: TextStyle(
                                color: CColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
                            onPressed: _submitProfileDetails,
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
}
