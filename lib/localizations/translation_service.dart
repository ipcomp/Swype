import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swype/localizations/language_provider.dart';
import 'package:swype/routes/api_routes.dart';
import 'package:swype/utils/dio/dio_client.dart';

class TranslationService {
  DioClient dio = DioClient();

  Future<void> fetchTranslationData(WidgetRef ref) async {
    try {
      final response = await dio.get(ApiRoutes.getTranslations);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status_code'] == 200) {
          final Map<String, String> eng =
              _sanitizeTranslations(data['data']['en']);
          final Map<String, String> iw =
              _sanitizeTranslations(data['data']['iw']);
          ref.read(langProvider.notifier).setTranslations(eng, iw);
        } else {
          print(data['message']);
        }
      } else {
        throw Exception('Failed to load translations: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }

  Map<String, String> _sanitizeTranslations(Map<String, dynamic> translations) {
    return translations.map((key, value) {
      return MapEntry(key, value?.toString() ?? '');
    });
  }
}
