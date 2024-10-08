import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swype/commons/widgets/custom_drop_down.dart';
import 'package:swype/features/authentication/providers/user_provider.dart';
import 'package:swype/features/settings/controllers/update_user_options_controller.dart';
import 'package:swype/features/settings/providers/user_options_provider.dart';
import 'package:swype/routes/api_routes.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/dio/dio_client.dart';
import 'package:swype/utils/helpers/helper_functions.dart';
import 'package:swype/utils/helpers/loader_screen.dart';
import 'package:swype/utils/preferences/preferences_provider.dart';

class UpdateUserPreferences extends ConsumerStatefulWidget {
  const UpdateUserPreferences({super.key});

  @override
  ConsumerState<UpdateUserPreferences> createState() =>
      _UpdateUserPreferencesState();
}

class _UpdateUserPreferencesState extends ConsumerState<UpdateUserPreferences> {
  UpdateUserOptionsController updateUserOptionsController =
      UpdateUserOptionsController();
  DioClient dioClient = DioClient();
  String selectedGender = 'Girls';
  double distance = 10;
  RangeValues ageRange = const RangeValues(20, 50);
  int? selectedrelationship;
  int? selectedCity;
  bool isLoading = false;
  bool isFetchingCities = true;
  List<Map<String, dynamic>>? cityList;

  @override
  void initState() {
    super.initState();
    final currentLang = ref.read(preferencesProvider).preferredLanguage;
    // if (currentLang == "en") {
    //   setState(() {
    //     selectedGender = "Girls";
    //   });
    // } else {
    //   setState(() {
    //     selectedGender = "נשים";
    //   });
    // }
    Future.wait([fetchCities(), setUserPreferences(currentLang)]);
  }

  Future<void> setUserPreferences(currentLang) async {
    final user = ref.read(userProvider);
    final preferences = user?['preference'];
    if (preferences != null) {
      setState(() {
        selectedGender = preferences['preferred_gender'] == "male"
            ? (currentLang == "en" ? "Boys" : "גברים")
            : preferences['preferred_gender'] == "female"
                ? (currentLang == "en" ? "Girls" : "נשים")
                : (currentLang == "en" ? "Both" : "אחר");
        distance = preferences['max_distance']?.toDouble() ?? 10;
        ageRange = RangeValues(
          preferences['age_range_min'].toDouble() ?? 20,
          preferences['age_range_max'].toDouble() ?? 50,
        );
        selectedrelationship = preferences['user_relationship_goals']['id'];
        selectedCity = preferences['user_preferred_city']['id'];
      });
    }
  }

  Future<void> fetchCities() async {
    setState(() {
      isFetchingCities = true; // Show loader while fetching
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
            response.data['message'],
          );
        }
      } else {
        CHelperFunctions.showToaster(
          context,
          response.data['message'],
        );
      }
    } catch (e) {
      CHelperFunctions.showToaster(
        context,
        'An error occurred: $e',
      );
    } finally {
      setState(() {
        isFetchingCities = false;
      });
    }
  }

  Future<void> applyFilter() async {
    setState(() {
      isLoading = true;
    });
    final formData = FormData.fromMap({
      'relationship_goals': selectedrelationship,
      'preferred_city': selectedCity,
      'preferred_gender': selectedGender == 'Both'
          ? 'both'
          : selectedGender == 'Girls'
              ? 'female'
              : 'male',
      'max_distance': distance.round(),
      'age_range_min': ageRange.start.round(),
      'age_range_max': ageRange.end.round(),
    });

    await updateUserOptionsController.updateUserPreferences(
      formData,
      context,
      ref,
    );

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userOptions = ref.watch(profileOptionsProvider);
    final relationshiOptions = userOptions['relationship_goals'];
    final translations = CHelperFunctions().getTranslations(ref);
    if (isFetchingCities || isLoading) {
      return Container(
        color: Colors.white.withOpacity(0.7),
        child: const Center(
          child: LoaderScreen(gifPath: 'assets/gif/loader.gif'),
        ),
      );
    }
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
                            style: const TextStyle(
                              color: Color.fromRGBO(21, 33, 31, .7),
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
                        inactiveColor: const Color(0xFFE8E6EA),
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
                            style: const TextStyle(
                              color: Color.fromRGBO(21, 33, 31, .7),
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
                        max: 25,
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
                      if (!isLoading)
                        CustomDropdownBottomSheet(
                          title: translations['Relationship Goals'] ??
                              'Relationship Goals',
                          items: relationshiOptions,
                          initialValueId: selectedrelationship,
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
                        initialValueId: selectedCity,
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
                          child: Text(translations['Update'] ?? 'Update'),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDropdown(
    String label,
    String? selectedValue,
    List<Map<String, dynamic>>? options,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
      ),
      items: options?.map((option) {
        return DropdownMenuItem<String>(
          value: option['id'].toString(),
          child: Text(option['name']),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

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
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
