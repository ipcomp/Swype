import 'package:flutter/material.dart';
import 'package:swype/features/home/widgets/advanced_search_screen.dart';
import 'package:swype/utils/constants/colors.dart';

class FilterBottomSheet extends StatefulWidget {
  final void Function(Map<String, dynamic>) onApplyFilter;

  const FilterBottomSheet({
    super.key,
    required this.onApplyFilter,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  Map<String, dynamic> selectedFilters = {};
  String selectedGender = 'Girls';
  String location = 'Jerusalem, Israel';
  double distance = 40;
  RangeValues ageRange = const RangeValues(20, 50);

  Future<void> applyFilter() async {
    Map<String, dynamic> filterData = {
      'gender': selectedGender == "Girls"
          ? 'female'
          : selectedGender == "Boys"
              ? 'male'
              : 'other',
      'latitude': 40.7128,
      'longitude': -74.006
    };
    widget.onApplyFilter(filterData);
    Navigator.pop(context);
  }

  void clearFilter() {
    setState(() {
      selectedGender = 'Girls';
      location = 'Jerusalem, Israel';
      distance = 40;
      ageRange = const RangeValues(20, 50);
      location = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 38,
              ),
              Text(
                "Filters",
                style: TextStyle(
                  color: CColors.secondary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: clearFilter,
                  style: TextButton.styleFrom(
                      splashFactory: NoSplash.splashFactory),
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
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Interested in',
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
                      _genderButton('Girls'),
                      _genderButton('Boys'),
                      _genderButton('Both'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 39),
              TextFormField(
                controller: TextEditingController(text: location),
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Location'),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Distance',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: CColors.secondary,
                      height: 1.5,
                    ),
                  ),
                  Text(
                    '${distance.round()}',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Age',
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: applyFilter,
                  child: const Text('Continue'),
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdvancedSearchScreen(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    splashFactory: NoSplash.splashFactory,
                  ),
                  child: const Text(
                    'Advanced Search',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(21, 33, 31, 0.70),
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
