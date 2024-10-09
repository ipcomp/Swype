import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swype/commons/widgets/custom_drop_down.dart';
import 'package:swype/features/authentication/providers/user_provider.dart';
import 'package:swype/features/authentication/register/screens/update_location.dart';
import 'package:swype/features/settings/controllers/profile_edit_controller.dart';
import 'package:swype/features/settings/providers/user_options_provider.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/helpers/helper_functions.dart';
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
    ref.read(profileOptionsProvider.notifier).fetchProfileOptions();
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
        // Navigator.of(context).pushAndRemoveUntil(
        //   MaterialPageRoute(
        //     builder: (context) => const UserPreferences(),
        //   ),
        //   (Route<dynamic> route) => false,
        // );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => UpdateLocationScreen(),
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
    final translations = CHelperFunctions().getTranslations(ref);
    return Scaffold(
      body: SafeArea(
        child: FocusScope(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
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
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment
                              .center, // This ensures vertical alignment
                          children: [
                            Text(
                              translations['Profile Data'] ?? "Profile Data",
                              style: const TextStyle(
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
                                      builder: (context) =>
                                          UpdateLocationScreen(),
                                    ),
                                    (Route<dynamic> route) => false,
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 0),
                                ),
                                child: Text(
                                  translations['Skip'] ?? 'Skip',
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
                                    decoration: InputDecoration(
                                      labelText: translations['Bio'] ?? 'Bio',
                                      contentPadding:
                                          const EdgeInsets.all(20.0),
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
                                    decoration: InputDecoration(
                                      labelText:
                                          translations['Height'] ?? 'Height',
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
                                    decoration: InputDecoration(
                                      labelText:
                                          translations['Political Views'] ??
                                              'Political Views',
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
                                    decoration: InputDecoration(
                                      labelText: translations['Profession'] ??
                                          'Profession',
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
                                    decoration: InputDecoration(
                                      labelText: translations['Current City'] ??
                                          'Current City',
                                      hintText:
                                          translations['Enter Current City'] ??
                                              "Enter Current City",
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
                                      child: Text(
                                          translations['Submit'] ?? 'Submit'),
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
                if (isLoading)
                  const LoaderScreen(gifPath: 'assets/gif/loader.gif'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDropdownSection(String title, List<Map<String, dynamic>> items) {
    // No need to retrieve user data; simply provide a new selection.
    final translations = CHelperFunctions().getTranslations(ref);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: CustomDropdownBottomSheet(
        title: translations[formatTitle(title)] ?? formatTitle(title),
        items: items,
        onItemSelected: (int newSelectedId) {
          setState(() {
            selectedOptions[title] = newSelectedId;
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
