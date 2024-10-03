import 'package:dio/dio.dart';
import 'package:swype/routes/api_routes.dart';
import 'package:swype/utils/dio/dio_client.dart';

class AdvancedSearchController {
  final DioClient dioClient = DioClient();

  Future<Map<String, dynamic>?> performAdvancedSearch(
      Map<String, dynamic> searchData) async {
    try {
      FormData formData = FormData.fromMap(searchData);

      final response = await dioClient.postWithFormData(
        ApiRoutes.advanceSearch,
        formData,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data;
        return responseData;
      } else {
        print('Failed to perform search. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error during API call: $e');
      return null;
    }
  }
}
