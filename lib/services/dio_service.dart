import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shartflix/utils/constants.dart';

import '../utils/api_logging_interceptor_utils.dart';
import '../utils/error_handling_interceptor_utils.dart';

class DioService {
  static Dio? _dio;
  static BuildContext? _context;

  static void init(BuildContext context) {
    _context = context;
  }

  static Dio getDioInstance() {
    if (_dio == null) {
      _dio = Dio(BaseOptions(
        baseUrl: AppConstants.baseApiUrl,
        connectTimeout: const Duration(minutes: 3),
        receiveTimeout: const Duration(minutes: 2),
      ))
        ..options.headers["content-type"] = "application/json"
        ..interceptors.add(LoggingInterceptor());

      if (_context != null) {
        _dio!.interceptors.add(ErrorHandingInterceptor(_context!));
      }
    }
    return _dio!;
  }

  // POST request method
  Future<Map<String, dynamic>> post(String endpoint, {dynamic data}) async {
    try {
      final response = await getDioInstance().post(endpoint, data: data);
      return response.data;
    } catch (e) {
      throw Exception('POST request failed: $e');
    }
  }

  // GET request method
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await getDioInstance().get(endpoint);
      return response.data;
    } catch (e) {
      throw Exception('GET request failed: $e');
    }
  }
}
