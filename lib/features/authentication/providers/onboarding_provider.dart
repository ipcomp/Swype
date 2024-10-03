import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:swype/routes/api_routes.dart';
import 'package:swype/utils/preferences/preferences_provider.dart';

class Onboarding {
  final String image;
  final String title;
  final String description;

  Onboarding(
      {required this.image, required this.title, required this.description});
}

class OnboardingNotifier extends StateNotifier<List<Onboarding>> {
  final Dio dio;

  OnboardingNotifier(this.dio) : super([]);

  Future<void> fetchOnBoardingData(WidgetRef ref) async {
    final preferredLanguage = ref.read(preferencesProvider).preferredLanguage;

    try {
      final response = await dio.get(ApiRoutes.getOnBoardingData);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status_code'] == 200) {
          List<dynamic> onboardingList = data['data'];

          List<Onboarding> fetchedData = onboardingList.map((item) {
            String title = item['title'];
            String description = item['description'];

            if (preferredLanguage == 'iw' &&
                item['title_iw'] != null &&
                item['title_iw'] != "") {
              title = item['title_iw'];
            }
            if (preferredLanguage == 'iw' &&
                item['description_iw'] != null &&
                item['description_iw'] != "") {
              description = item['description_iw'];
            }

            return Onboarding(
              image: item['image_url'],
              title: title,
              description: description,
            );
          }).toList();

          state = fetchedData;
        } else {
          // Handle error case
          print('Error: ${data['message']}');
        }
      } else {
        print('Failed to fetch onboarding data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while fetching onboarding data: $e');
    }
  }
}

// Create a provider for the OnboardingNotifier
final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, List<Onboarding>>((ref) {
  return OnboardingNotifier(Dio());
});
