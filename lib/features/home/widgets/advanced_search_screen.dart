import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:swype/utils/constants/colors.dart';

class AdvancedSearchScreen extends StatefulWidget {
  const AdvancedSearchScreen({super.key});

  @override
  _AdvancedSearchScreenState createState() => _AdvancedSearchScreenState();
}

class _AdvancedSearchScreenState extends State<AdvancedSearchScreen> {
  final _formKey = GlobalKey<FormState>();

  // Dropdown variables
  String? selectedEducation;
  String? selectedProfession;
  String? selectedBodyType;
  String? selectedMaritalStatus;
  String? selectedSmokingHabits;
  String? selectedDrinkingHabits;
  String? selectedExerciseFrequency;
  String? selectedDietPlan;
  String? selectedTravelFrequency;
  String? selectedZodiacSign;

  // List of options (can be fetched from API or loaded locally)
  final List<String> educationOptions = [
    'Bachelor\'s Degree',
    'Master\'s Degree',
    'PhD'
  ];
  final List<String> professionOptions = [
    'Software Engineer',
    'Doctor',
    'Teacher'
  ];
  final List<String> bodyTypeOptions = ['Slim', 'Average', 'Athletic', 'Heavy'];
  final List<String> maritalStatusOptions = ['Single', 'Married', 'Divorced'];
  final List<String> smokingHabitsOptions = ['Never', 'Occasionally', 'Often'];
  final List<String> drinkingHabitsOptions = ['Never', 'Occasionally', 'Often'];
  final List<String> exerciseFrequencyOptions = [
    'Never',
    'Sometimes',
    'Regularly'
  ];
  final List<String> dietPlanOptions = ['Vegan', 'Vegetarian', 'Keto'];
  final List<String> travelFrequencyOptions = [
    'Never',
    'Occasionally',
    'Often'
  ];
  final List<String> zodiacSignOptions = ['Aries', 'Taurus', 'Gemini'];

  // API call to fetch filtered results
  Future<void> fetchSearchResults() async {
    final formData = {
      'education': selectedEducation,
      'profession': selectedProfession,
      'body_type': selectedBodyType,
      'marital_status': selectedMaritalStatus,
      'smoking_habits': selectedSmokingHabits,
      'drinking_habits': selectedDrinkingHabits,
      'exercise_frequency': selectedExerciseFrequency,
      'diet_plan': selectedDietPlan,
      'travel_frequency': selectedTravelFrequency,
      'zodiac_sign': selectedZodiacSign,
    };

    try {
      Dio dio = Dio();
      final response = await dio.post(
        'https://your-backend-api.com/search',
        data: formData,
      );
      if (response.statusCode == 200) {
        print('Search results fetched successfully');
      } else {
        print('Failed to fetch search results');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void clearFilter() {
    setState(() {
      selectedEducation = null;
      selectedProfession = null;
      selectedBodyType = null;
      selectedMaritalStatus = null;
      selectedSmokingHabits = null;
      selectedDrinkingHabits = null;
      selectedExerciseFrequency = null;
      selectedDietPlan = null;
      selectedTravelFrequency = null;
      selectedZodiacSign = null;
    });
  }

  // Dropdown builder widget
  Widget buildDropdown(String label, String? selectedValue,
      List<String> options, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color.fromRGBO(21, 33, 31, .4),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        floatingLabelStyle: const TextStyle(
          fontSize: 18,
          color: Color.fromRGBO(21, 33, 31, .4),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xFFE8E6EA),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: CColors.primary,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xFFE8E6EA),
            width: 1.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 20.0,
        ),
      ),
      items: options.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Advanced Search',
            style: TextStyle(
              color: CColors.secondary,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            Container(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: clearFilter,
                child: Text(
                  'Clear',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: CColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  buildDropdown(
                      'Education', selectedEducation, educationOptions,
                      (value) {
                    setState(() {
                      selectedEducation = value;
                    });
                  }),
                  const SizedBox(height: 20),
                  buildDropdown(
                      'Profession', selectedProfession, professionOptions,
                      (value) {
                    setState(() {
                      selectedProfession = value;
                    });
                  }),
                  const SizedBox(height: 20),
                  buildDropdown('Body Type', selectedBodyType, bodyTypeOptions,
                      (value) {
                    setState(() {
                      selectedBodyType = value;
                    });
                  }),
                  const SizedBox(height: 20),
                  buildDropdown('Marital Status', selectedMaritalStatus,
                      maritalStatusOptions, (value) {
                    setState(() {
                      selectedMaritalStatus = value;
                    });
                  }),
                  const SizedBox(height: 20),
                  buildDropdown('Smoking Habits', selectedSmokingHabits,
                      smokingHabitsOptions, (value) {
                    setState(() {
                      selectedSmokingHabits = value;
                    });
                  }),
                  const SizedBox(height: 20),
                  buildDropdown('Drinking Habits', selectedDrinkingHabits,
                      drinkingHabitsOptions, (value) {
                    setState(() {
                      selectedDrinkingHabits = value;
                    });
                  }),
                  const SizedBox(height: 20),
                  buildDropdown('Exercise Frequency', selectedExerciseFrequency,
                      exerciseFrequencyOptions, (value) {
                    setState(() {
                      selectedExerciseFrequency = value;
                    });
                  }),
                  const SizedBox(height: 20),
                  buildDropdown('Diet Plan', selectedDietPlan, dietPlanOptions,
                      (value) {
                    setState(() {
                      selectedDietPlan = value;
                    });
                  }),
                  const SizedBox(height: 20),
                  buildDropdown('Travelling Frequency', selectedTravelFrequency,
                      travelFrequencyOptions, (value) {
                    setState(() {
                      selectedTravelFrequency = value;
                    });
                  }),
                  const SizedBox(height: 20),
                  buildDropdown(
                      'Zodiac Sign', selectedZodiacSign, zodiacSignOptions,
                      (value) {
                    setState(() {
                      selectedZodiacSign = value;
                    });
                  }),
                  const SizedBox(height: 40),
                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          fetchSearchResults();
                        }
                      },
                      child: const Text('Continue'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
