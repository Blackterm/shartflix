import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import '../models/user.dart';
import '../services/dio_service.dart';
import '../services/token_service.dart';

class ProfileRepository {
  final Dio _dio;
  final TokenService _tokenService;

  ProfileRepository({Dio? dio, TokenService? tokenService})
      : _dio = dio ?? DioService.getDioInstance(),
        _tokenService = tokenService ?? TokenService();

  /// Upload profile photo to server
  Future<Map<String, dynamic>> uploadProfilePhoto(File photoFile) async {
    try {
      // Get token from TokenService
      final token = await _tokenService.getToken();

      // Check if file is too large (max 2MB)
      final fileSize = await photoFile.length();
      if (fileSize > 2 * 1024 * 1024) {
        throw Exception('Image file is too large. Please choose a smaller image.');
      }

      // Prepare form data for file upload
      String fileName = photoFile.path.split('/').last;

      // Determine content type based on file extension
      String contentType = 'image/jpeg'; // Default to JPEG
      if (fileName.toLowerCase().endsWith('.png')) {
        contentType = 'image/png';
      } else if (fileName.toLowerCase().endsWith('.jpg') || fileName.toLowerCase().endsWith('.jpeg')) {
        contentType = 'image/jpeg';
      }

      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          photoFile.path,
          filename: fileName,
          contentType: MediaType.parse(contentType),
        ),
      });

      // Add token to headers if available
      if (token != null) {
        _dio.options.headers['Authorization'] = token; // No 'Bearer' prefix according to API doc
      }

      // Set content type for multipart form data
      _dio.options.headers['Content-Type'] = 'multipart/form-data';
      _dio.options.headers['accept'] = 'application/json';

      // Make POST request to upload photo
      final response = await _dio.post(
        '/user/upload_photo',
        data: formData,
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to upload profile photo: $e');
    }
  }

  /// Update user profile information
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> profileData) async {
    try {
      // Get token from TokenService
      final token = await _tokenService.getToken();

      // Add token to headers if available
      if (token != null) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
      }

      final response = await _dio.post(
        '/user/update_profile',
        data: profileData,
      );

      return response.data;
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  /// Get user profile information (no caching)
  Future<User> getUserProfile() async {
    try {
      // Get token from TokenService
      final token = await _tokenService.getToken();

      if (token == null) {
        throw Exception('No authentication token available');
      }

      // Add token to headers
      _dio.options.headers['Authorization'] = token; // No Bearer prefix as per API
      _dio.options.headers['accept'] = 'application/json';

      final response = await _dio.get('/user/profile');

      // Parse response according to the API structure
      if (response.data['response']?['code'] == 200 && response.data['data'] != null) {
        final userData = response.data['data'];
        final user = User.fromJson(userData);

        return user;
      } else {
        throw Exception('Invalid response format: ${response.data}');
      }
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  // Legacy method for backward compatibility
  Future<Map<String, dynamic>> getUserProfileLegacy() async {
    final user = await getUserProfile();
    return user.toJson();
  }
}
