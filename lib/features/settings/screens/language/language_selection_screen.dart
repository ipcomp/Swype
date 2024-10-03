import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_animation_transition/animations/fade_animation_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:swype/commons/widgets/custom_drop_down_with_names.dart';
import 'package:swype/features/authentication/login/screens/onboarding/onboarding_screen.dart';
import 'package:swype/localizations/language_provider.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/constants/image_strings.dart';
import 'package:swype/utils/preferences/preferences_provider.dart';

class LanguageSelectionScreen extends ConsumerStatefulWidget {
  final bool isFirstTime;
  const LanguageSelectionScreen({super.key, required this.isFirstTime});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState
    extends ConsumerState<LanguageSelectionScreen> {
  String selectedLang = "";

  @override
  void initState() {
    super.initState();
    final lang = ref.read(preferencesProvider).preferredLanguage;
    setState(() {
      selectedLang = lang;
    });
  }

  @override
  Widget build(BuildContext context) {
    final langCode = ref.watch(preferencesProvider).preferredLanguage;
    final translations = ref.watch(
        langProvider)?[(langCode == "" || langCode == "iw") ? "iw" : langCode];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 97),
                Image.asset(
                  ImageStrings.mainLogo,
                  height: 105,
                ),
                const SizedBox(height: 39),
                Text(
                  translations?['Choose a Language'] ?? "Choose a Languge",
                  // langCode == '' || langCode == "iw"
                  //     ? "בחר שפה"
                  //     : "Choose a Languge",
                  style: TextStyle(
                    color: CColors.secondary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),
                CustomDropdownBottomSheetWithNames(
                  // title: langCode == '' || langCode == "iw" ? "שפה" : "Languge",
                  // initialValue:
                  //     langCode == '' || langCode == "iw" ? "עברית" : "Hebrew",
                  title: translations?['Language'] ?? "Language",
                  initialValue: selectedLang == 'en' ? "English" : "עברית",
                  items: selectedLang == "en"
                      ? const ["Hebrew", "English"]
                      : const ["עברית", "אַנגְלִית"],
                  onItemSelected: (selectedItem) {
                    setState(() {
                      selectedLang = selectedItem;
                    });
                  },
                ),
                const SizedBox(height: 39),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (widget.isFirstTime) {
                        ref
                            .read(preferencesProvider.notifier)
                            .setPreferredLanguage(
                              selectedLang == '' || selectedLang == "עברית"
                                  ? "iw"
                                  : "en",
                            );
                        Navigator.pushReplacement(
                          context,
                          PageAnimationTransition(
                            page: const OnboardingScreen(),
                            pageAnimationType: FadeAnimationTransition(),
                          ),
                        );
                      } else {
                        final res =
                            selectedLang == "Hebrew" || selectedLang == "עברית"
                                ? "iw"
                                : 'en';
                        ref
                            .read(preferencesProvider.notifier)
                            .setPreferredLanguage(res);
                        Navigator.pop(context);
                      }
                    },
                    child: Text(translations?['Submit'] ?? "Submit"
                        // langCode == '' || langCode == "iw" ? "אישור" : "Confirm",
                        ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
