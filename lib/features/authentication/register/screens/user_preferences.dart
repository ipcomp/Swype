import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:page_animation_transition/animations/fade_animation_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:swype/commons/widgets/custom_drop_down.dart';
import 'package:swype/features/authentication/providers/all_users_provider.dart';
import 'package:swype/features/authentication/providers/register_provider.dart';
import 'package:swype/features/authentication/providers/user_provider.dart';
import 'package:swype/features/authentication/register/screens/secure_account_screen.dart';
import 'package:swype/features/settings/providers/user_options_provider.dart';
import 'package:swype/routes/api_routes.dart';
import 'package:swype/routes/app_routes.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/dio/dio_client.dart';
import 'package:swype/utils/helpers/helper_functions.dart';
import 'package:swype/utils/helpers/loader_screen.dart';
import 'package:swype/utils/preferences/preferences_provider.dart';

class UserPreferences extends ConsumerStatefulWidget {
  const UserPreferences({super.key});

  @override
  ConsumerState<UserPreferences> createState() => _UserPreferencesState();
}

class _UserPreferencesState extends ConsumerState<UserPreferences> {
  DioClient dioClient = DioClient();
  String selectedGender = 'Girls';
  double distance = 40;
  RangeValues ageRange = const RangeValues(20, 50);
  int? selectedrelationship;
  int? selectedCity;
  bool isLoading = false;
  bool isFetchingCities = true;
  List<Map<String, dynamic>>? cityList;
  final LocalAuthentication auth = LocalAuthentication();
  bool _isBiometricSupported = false;
  bool _hasEnrolledBiometrics = false;

  @override
  void initState() {
    super.initState();

    // ref.read(allUsersProvider.notifier).fetchUserList();
    getAuthToken();
    ref.read(profileOptionsProvider.notifier).fetchProfileOptions();

    final currentLang = ref.read(preferencesProvider).preferredLanguage;
    if (currentLang == "en") {
      setState(() {
        selectedGender = "Girls";
      });
    } else {
      setState(() {
        selectedGender = "נשים";
      });
    }
    fetchCities();
    _checkBiometrics();
  }

  Future<String?> getAuthToken() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();

    String? token = await storage.read(key: 'auth_token');

    if (token != null) {
      print("Token: " + token);
      ref.read(allUsersProvider.notifier).fetchUserList(token);
    } else {
      print("Getting token null");
      ;
    }

    return token;
  }

  Future<void> _checkBiometrics() async {
    bool isSupported = await auth.isDeviceSupported();
    bool hasEnrolled = await auth.canCheckBiometrics;
    setState(() {
      _isBiometricSupported = isSupported;
      _hasEnrolledBiometrics = hasEnrolled;
    });
  }

  Future<void> fetchCities() async {
    setState(() {
      isFetchingCities = true;
    });

    try {
      final response = await dioClient.get(ApiRoutes.getCities);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status_code'] == 200) {
          setState(() {
            cityList = List<Map<String, dynamic>>.from(data['data']);
          });
        } else {
          CHelperFunctions.showToaster(
            context,
            "Failed to load cities. Please try again.",
          );
        }
      } else {
        CHelperFunctions.showToaster(
          context,
          "Server error. Please try again later.",
        );
      }
    } catch (e) {
      CHelperFunctions.showToaster(
        context,
        "An error occurred: $e",
      );
    } finally {
      setState(() {
        isFetchingCities = false; // Hide loader
      });
    }
  }

  Future<void> applyFilter() async {
    setState(() {
      isLoading = true;
    });

    try {
      final formData = FormData.fromMap({
        'relationship_goals': '$selectedrelationship',
        'preferred_city': "$selectedCity",
        'preferred_gender': selectedGender == 'Both'
            ? 'both'
            : selectedGender == 'Girls'
                ? 'female'
                : 'male',
        'max_distance': distance.round(),
        'age_range_min': ageRange.start.round(),
        'age_range_max': ageRange.end.round(),
      });

      final registerNotifier = ref.read(registerProvider.notifier);
      final response = await dioClient.postWithFormData(
        ApiRoutes.updatePreferences,
        formData,
      );

      // Handle the response (check if the request was successful)
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status_code'] == 200) {
          ref.read(userProvider.notifier).setUser(data['data']['user']);
          registerNotifier.updateIsPreferencesUpdated(true);
          CHelperFunctions.showToaster(context, data['message']);
          if (_isBiometricSupported && _hasEnrolledBiometrics) {
            Navigator.of(context).pushAndRemoveUntil(
              PageAnimationTransition(
                page: const SecureAccountScreen(),
                pageAnimationType: FadeAnimationTransition(),
              ),
              (Route<dynamic> route) => false,
            );
          } else {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.home,
              ModalRoute.withName(AppRoutes.splash),
            );
          }
        } else {
          CHelperFunctions.showToaster(context, data['message']);
        }
      } else {
        CHelperFunctions.showToaster(context, response.statusMessage!);
        print("Failed to update preferences: ${response.statusCode}");
      }
    } catch (e) {
      // Handle the error (e.g., show an error message or log the error)
      print("Error updating preferences: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userOptions = ref.watch(profileOptionsProvider);
    final relationshiOptions = userOptions['relationship_goals'];
    final translations = CHelperFunctions().getTranslations(ref);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        toolbarHeight: 78,
        backgroundColor: Colors.white,
        title: Text(
          translations['Update Preferences'] ?? "Update Preferences",
          style: TextStyle(
            color: CColors.secondary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            height: 1.5,
          ),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translations['Preferred Gender'] ?? 'Preferred Gender',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: CColors.secondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFE8EAE6),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Row(
                            children: [
                              _genderButton(translations["Girls"] ?? 'Girls'),
                              if (selectedGender == "Both" ||
                                  selectedGender == translations["Both"])
                                Container(
                                  height: 22,
                                  width: 1,
                                  color: CColors.accent,
                                ),
                              _genderButton(translations["Boys"] ?? 'Boys'),
                              if (selectedGender == translations["Girls"] ||
                                  selectedGender == 'Girls')
                                Container(
                                  height: 22,
                                  width: 1,
                                  color: CColors.accent,
                                ),
                              _genderButton(translations["Both"] ?? 'Both'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            translations['Age'] ?? 'Age',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: CColors.secondary,
                              height: 1.5,
                            ),
                          ),
                          Text(
                            '${ageRange.start.round()} - ${ageRange.end.round()}',
                            style: TextStyle(
                              color: CColors.textOpacity,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      RangeSlider(
                        min: 18,
                        max: 99,
                        values: ageRange,
                        onChanged: (values) {
                          setState(() {
                            ageRange = values;
                          });
                        },
                        labels: RangeLabels(
                          '${ageRange.start.round()}',
                          '${ageRange.end.round()}',
                        ),
                        activeColor: CColors.primary,
                        inactiveColor: CColors.accent,
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            translations['Distance'] ?? 'Distance',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: CColors.secondary,
                              height: 1.5,
                            ),
                          ),
                          Text(
                            '${distance.round()}Km',
                            style: TextStyle(
                              color: CColors.textOpacity,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Slider(
                        value: distance,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        label: '${distance.round()} km',
                        activeColor: CColors.primary,
                        onChanged: (value) {
                          setState(() {
                            distance = value;
                          });
                        },
                      ),
                      const SizedBox(height: 30),
                      if (userOptions.isNotEmpty)
                        CustomDropdownBottomSheet(
                          title: translations['Relationship Goals'] ??
                              'Relationship Goals',
                          items: relationshiOptions,
                          onItemSelected: (int selectedId) {
                            setState(() {
                              selectedrelationship = selectedId;
                            });
                          },
                        ),
                      const SizedBox(height: 30),
                      CustomDropdownBottomSheet(
                        title: translations['City'] ?? 'City',
                        items: cityList,
                        onItemSelected: (int selectedId) {
                          setState(() {
                            selectedCity = selectedId;
                          });
                        },
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: applyFilter,
                          child:
                              Text(translations['Lets Swipe'] ?? 'Lets Swipe'),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isFetchingCities || isLoading)
            Container(
              color: Colors.white.withOpacity(0.7),
              child: const Center(
                child: LoaderScreen(gifPath: 'assets/gif/loader.gif'),
              ),
            ),
        ],
      ),
    );
  }

//   Widget buildDropdown(
//   String label,
//   String? selectedValue,
//   List<Map<String, dynamic>>? options,
//   ValueChanged<String?> onChanged,
// ) {
//   return DropdownSearch<String>(
//     mode: Mode.form, // or Mode.DIALOG for a dialog
//     dropdownSearchDecoration: InputDecoration(
//       labelText: label,
//       border: OutlineInputBorder(), // Style your input here
//     ),
//     items: options?.map((option) => option['id'].toString()).toList(),
//     onChanged: onChanged,
//     selectedItem: selectedValue,
//     itemAsString: (item) {
//       // Define how the items will be displayed
//       final option = options?.firstWhere((element) => element['id'].toString() == item);
//       return option != null ? option['name'] : '';
//     },
//     dropdownBuilder: (context, selectedItem) {
//       // Define how the selected item will be displayed
//       final option = options?.firstWhere((element) => element['id'].toString() == selectedItem);
//       return Text(option != null ? option['name'] : label);
//     },
//     popupItemBuilder: (context, item, isSelected) {
//       // Style the dropdown items
//       final option = options?.firstWhere((element) => element['id'].toString() == item);
//       return Container(
//         padding: const EdgeInsets.all(10),
//         child: Text(option != null ? option['name'] : ''),
//       );
//     },
//   );
// }

  Widget _genderButton(String gender) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedGender = gender;
          });
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          backgroundColor:
              selectedGender == gender ? CColors.primary : Colors.white,
        ),
        child: Text(
          gender,
          style: TextStyle(
            color: selectedGender == gender ? Colors.white : CColors.secondary,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
