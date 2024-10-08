import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swype/commons/widgets/custom_drop_down.dart';
import 'package:swype/features/authentication/providers/user_provider.dart';
import 'package:swype/features/authentication/register/screens/user_preferences.dart';
import 'package:swype/features/settings/controllers/profile_edit_controller.dart';
import 'package:swype/features/settings/providers/user_options_provider.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/helpers/loader_screen.dart';

class AddAdditionalProfileData extends ConsumerStatefulWidget {
  const AddAdditionalProfileData({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddAdditionalProfileDataState();
}

class _AddAdditionalProfileDataState
    extends ConsumerState<AddAdditionalProfileData> {
  final TextEditingController bioController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController politicalController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController currentCityController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final ProfileEditController profileEditController = ProfileEditController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  Map<String, int> selectedOptions = {};

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);

    usernameController.text = user?['username'] ?? '';
    emailController.text = user?['email'] ?? '';
    phoneController.text = user?['phone'] ?? '';
    firstNameController.text = user?['first_name'] ?? '';
    lastNameController.text = user?['last_name'] ?? '';
  }

  @override
  void dispose() {
    bioController.dispose();
    heightController.dispose();
    politicalController.dispose();
    professionController.dispose();
    currentCityController.dispose();
    super.dispose();
  }

  Future<void> submitAdditionalData() async {
    try {
      setState(() {
        isLoading = true;
      });
      final formData = FormData();

      formData.fields.add(MapEntry('username', usernameController.text));
      formData.fields.add(MapEntry('email', emailController.text));
      formData.fields.add(MapEntry('phone', phoneController.text));
      formData.fields.add(MapEntry('first_name', firstNameController.text));
      formData.fields.add(MapEntry('last_name', lastNameController.text));
      formData.fields.add(MapEntry('bio', bioController.text));
      formData.fields.add(MapEntry('height', heightController.text));
      formData.fields.add(MapEntry(
        'political_views',
        politicalController.text,
      ));
      formData.fields.add(MapEntry('profession', professionController.text));
      formData.fields.add(MapEntry('current_city', currentCityController.text));

      selectedOptions.forEach((key, value) {
        formData.fields.add(MapEntry(key, value.toString()));
      });

      final result = await profileEditController.editProfile(
        formData,
        ref,
        context,
      );

      if (result) {
        selectedOptions.clear();
        bioController.clear();
        heightController.clear();
        politicalController.clear();
        professionController.clear();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const UserPreferences(),
          ),
          (Route<dynamic> route) => false,
        );
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final options = ref.watch(profileOptionsProvider);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 12),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment
                          .center, // This ensures vertical alignment
                      children: [
                        const Text(
                          "Profile Data",
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const UserPreferences(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 0),
                            ),
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                  fontSize: 16, color: CColors.primary),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 20.0,
                              ),
                              child: TextFormField(
                                controller: bioController,
                                maxLines: 3,
                                decoration: const InputDecoration(
                                  labelText: 'Bio',
                                  contentPadding: EdgeInsets.all(20.0),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 20.0,
                              ),
                              child: TextFormField(
                                controller: heightController,
                                decoration: const InputDecoration(
                                  labelText: 'Height',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 20.0,
                              ),
                              child: TextFormField(
                                controller: politicalController,
                                decoration: const InputDecoration(
                                  labelText: 'Political Views',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 20.0,
                              ),
                              child: TextFormField(
                                controller: professionController,
                                decoration: const InputDecoration(
                                  labelText: 'Profession',
                                ),
                              ),
                            ),
                            ...options.entries.map((entry) {
                              if (entry.key == "pet_preference" ||
                                  entry.key == "relationship_goals") {
                                return const SizedBox.shrink();
                              }
                              return buildDropdownSection(
                                  entry.key, entry.value);
                            }).toList(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 20.0,
                              ),
                              child: TextFormField(
                                controller: currentCityController,
                                decoration: const InputDecoration(
                                  labelText: 'Current City',
                                  hintText: "Enter Current City",
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      submitAdditionalData();
                                    }
                                  },
                                  child: const Text('Submit'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Overlay for loader
            if (isLoading) const LoaderScreen(gifPath: 'assets/gif/loader.gif'),
          ],
        ),
      ),
    );
  }

  Widget buildDropdownSection(String title, List<Map<String, dynamic>> items) {
    // No need to retrieve user data; simply provide a new selection.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: CustomDropdownBottomSheet(
        title: formatTitle(title),
        items: items,
        onItemSelected: (int newSelectedId) {
          setState(() {
            selectedOptions[title] = newSelectedId; // Update selectedOptions
          });
        },
      ),
    );
  }

  String formatTitle(String title) {
    return title
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) =>
            word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' ');
  }
}
