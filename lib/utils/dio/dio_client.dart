import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioClient {
  final Dio _dio = Dio();
  final storage = const FlutterSecureStorage();

  DioClient() {
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? token = await storage.read(key: 'auth_token');
        if (token != null) {
          options.headers["Authorization"] = "Bearer $token";
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        if (e.response?.statusCode == 401) {}
        return handler.next(e);
      },
    ));
  }

  //  Future<void> _handleUnauthorized() async {
  //   // Clear token from storage
  //   await storage.delete(key: 'auth_token');

  //   // Navigate to SplashScreen or any other relevant screen
  //   Navigator.pushAndRemoveUntil(
  //     context,
  //     MaterialPageRoute(builder: (context) => const SplashScreen()), // Replace with your SplashScreen widget
  //     (Route<dynamic> route) => false, // Remove all previous routes
  //   );
  // }

  Future<Response> get(String path) async {
    try {
      return await _dio.get(path);
    } on DioException catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Response> postWithFormData(String path, FormData formData) async {
    try {
      final response = await _dio.post(
        path,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );
      return response;
    } on DioException catch (e) {
      print('POST request error with FormData: $e');
      rethrow;
    }
  }

  // Post method without any data (no formData, no jsonData)
  Future<Response> postWithoutData(String path) async {
    try {
      final response = await _dio.post(path);
      return response;
    } on DioException catch (e) {
      print('POST request error without data: $e');
      rethrow;
    }
  }
}
