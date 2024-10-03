import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swype/features/authentication/providers/user_provider.dart';
import 'package:swype/features/settings/controllers/profile_edit_controller.dart';
import 'package:swype/features/settings/screens/edit_profile_bottom_sheet.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/helpers/helper_functions.dart';
import 'package:swype/utils/helpers/loader_screen.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final ProfileEditController profileEditController = ProfileEditController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController policalController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController currentCityController = TextEditingController();
  late AnimationController _controller;
  Map<String, dynamic> selectedOptions = {};
  bool isLoading = false;
  int _repeatCount = 0;
  final int _maxRepeatCount = 5;
  XFile? _profileImage;

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
    final user = ref.read(userProvider);
    _setInitialValues(user);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setInitialValues(user) {
    userNameController.text = user['username'] ?? '';
    emailController.text = user['email'] ?? '';
    firstNameController.text = user['first_name'] ?? '';
    lastNameController.text = user['last_name'] ?? '';
    phoneNumberController.text = user['phone'] ?? '';
    bioController.text = user['bio'] ?? '';
    heightController.text = user['height'] ?? '';
    professionController.text = user['profession'] ?? '';
    policalController.text = user['political_views'] ?? "";
    currentCityController.text = user['current_city'] ?? '';
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

  void _submitProfileDetails() async {
    FocusScope.of(context).unfocus();
    setState(() {
      isLoading = true;
    });

    // Create a FormData object to store the form fields and files
    final formData = FormData();

    // Add text fields to FormData
    formData.fields.add(MapEntry('username', userNameController.text));
    formData.fields.add(MapEntry('email', emailController.text));
    formData.fields.add(MapEntry('first_name', firstNameController.text));
    formData.fields.add(MapEntry('last_name', lastNameController.text));
    formData.fields.add(MapEntry('phone', phoneNumberController.text));
    formData.fields.add(MapEntry('bio', bioController.text));
    formData.fields.add(MapEntry('height', heightController.text));
    formData.fields.add(MapEntry('political_views', policalController.text));
    formData.fields.add(MapEntry('profession', professionController.text));
    formData.fields.add(MapEntry('current_city', currentCityController.text));

    selectedOptions.forEach((key, value) {
      formData.fields.add(MapEntry(key, value.toString()));
    });

    if (_profileImage != null) {
      try {
        final profileImageFile = await MultipartFile.fromFile(
          _profileImage!.path,
          filename: _profileImage!.path.split('/').last,
        );
        formData.files.add(MapEntry('profile_picture', profileImageFile));
      } catch (e) {
        print('Error while adding image: $e');
        CHelperFunctions.showToaster(
            context, "Failed to attach image. Try again.");
      }
    }

    // Call the controller to handle profile update request
    final result =
        await profileEditController.editProfile(formData, ref, context);

    if (result) {
      selectedOptions.clear();
      bioController.clear();
      heightController.clear();
      policalController.clear();
      professionController.clear();
    }
    setState(() {
      isLoading = true;
    });
  }

  void _showEditBottomSheet() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileBottomSheet(
          selectedOptions: selectedOptions,
          bioController: bioController,
          heightController: heightController,
          policalController: policalController,
          professionController: professionController,
          currentCityController: currentCityController,
          onUpdate: _submitProfileDetails,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return PopScope(
      canPop: true,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      "Update Profile",
                      style: TextStyle(
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
                                      as ImageProvider
                                  : NetworkImage(user?['profile_picture_url']),
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
                    // User Name Field
                    TextField(
                      controller: userNameController,
                      decoration: const InputDecoration(
                        labelText: "User Name",
                      ),
                    ),
                    const SizedBox(height: 21),
                    // Email Field
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                      ),
                    ),
                    const SizedBox(height: 21),
                    // First Name Field
                    TextField(
                      controller: firstNameController,
                      decoration: const InputDecoration(
                          labelText: "First Name",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'Enter First Name'),
                    ),
                    const SizedBox(height: 21),
                    // Last Name Field
                    TextField(
                      controller: lastNameController,
                      decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: "Last Name",
                          hintText: 'Enter Last Name'),
                    ),
                    const SizedBox(height: 21),

                    // Phone Number Field
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: phoneNumberController,
                            decoration: InputDecoration(
                              labelText: "Phone Number",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              hintText: 'Enter Phone Number',
                              prefixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 21, right: 8),
                                    child: SvgPicture.asset(
                                      'assets/svg/country_flag.svg',
                                      width: 24,
                                      height: 24,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          '(+972)',
                                          style: TextStyle(
                                            color: CColors.secondary,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        const Text(
                                          " | ",
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(21, 33, 31, .2),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 21),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _showEditBottomSheet,
                        child: const Text('Next'),
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
      ),
    );
  }
}
