import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../services/dio_service.dart';
import '../services/token_service.dart';

class AuthRepository {
  final Dio _dio;
  final TokenService _tokenService;

  AuthRepository({Dio? dio, TokenService? tokenService})
      : _dio = dio ?? DioService.getDioInstance(),
        _tokenService = tokenService ?? TokenService();

  Future<Map<String, dynamic>> register({
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        'user/register',
        data: {
          'email': email,
          'name': name,
          'password': password,
        },
      );

      // API'den gelen yanıt formatı: {"response":{"code":200,"message":""},"data":{...}}
      final responseData = response.data;
      final apiResponse = responseData['response'];
      final code = apiResponse['code'];

      if (code == 200) {
        final userData = responseData['data'];
        final token = userData['token'];

        // Token'ı 24 saatlik süre ile kaydet
        if (token != null) {
          await _tokenService.saveToken(token, userData: userData);
        }

        return {'success': true, 'data': userData, 'message': 'Kayıt başarılı!'};
      } else {
        String errorMessage = 'Kayıt işlemi başarısız oldu';

        // API'den gelen hata mesajını çevir
        if (apiResponse['message'] == 'USER_EXISTS') {
          errorMessage = 'Bu e-posta adresi zaten kullanılıyor';
        } else if (apiResponse['message'] != null && apiResponse['message'].isNotEmpty) {
          errorMessage = apiResponse['message'];
        }

        return {'success': false, 'message': errorMessage};
      }
    } on DioException catch (e) {
      String errorMessage = 'Bir hata oluştu';

      if (e.response != null) {
        switch (e.response!.statusCode) {
          case 400:
            errorMessage = 'Geçersiz bilgiler gönderildi';
            break;
          case 409:
            errorMessage = 'Bu e-posta adresi zaten kullanılıyor';
            break;
          case 422:
            errorMessage = 'Girilen bilgiler geçerli değil';
            break;
          case 500:
            errorMessage = 'Sunucu hatası. Lütfen tekrar deneyin';
            break;
          default:
            errorMessage = e.response?.data?['message'] ?? 'Beklenmeyen bir hata oluştu';
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Bağlantı zaman aşımına uğradı';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Yanıt alma zaman aşımına uğradı';
      } else if (e.type == DioExceptionType.unknown) {
        errorMessage = 'İnternet bağlantınızı kontrol edin';
      }

      return {'success': false, 'message': errorMessage};
    } catch (e) {
      return {'success': false, 'message': 'Beklenmeyen bir hata oluştu'};
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        'user/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      // API'den gelen yanıt formatı: {"response":{"code":200,"message":""},"data":{...}}
      final responseData = response.data;
      final apiResponse = responseData['response'];
      final code = apiResponse['code'];

      if (code == 200) {
        final userData = responseData['data'];
        final token = userData['token'];

        // Token'ı 24 saatlik süre ile kaydet
        if (token != null) {
          await _tokenService.saveToken(token, userData: userData);
        }

        return {'success': true, 'data': userData, 'message': 'Giriş başarılı!'};
      } else {
        String errorMessage = 'Giriş işlemi başarısız oldu';

        // API'den gelen hata mesajını çevir
        if (apiResponse['message'] == 'USER_NOT_FOUND') {
          errorMessage = 'Kullanıcı bulunamadı';
        } else if (apiResponse['message'] == 'INVALID_PASSWORD') {
          errorMessage = 'E-posta veya şifre hatalı';
        } else if (apiResponse['message'] != null && apiResponse['message'].isNotEmpty) {
          errorMessage = apiResponse['message'];
        }

        return {'success': false, 'message': errorMessage};
      }
    } on DioException catch (e) {
      String errorMessage = 'Bir hata oluştu';

      if (e.response != null) {
        switch (e.response!.statusCode) {
          case 400:
            errorMessage = 'Geçersiz e-posta veya şifre';
            break;
          case 401:
            errorMessage = 'E-posta veya şifre hatalı';
            break;
          case 404:
            errorMessage = 'Kullanıcı bulunamadı';
            break;
          case 500:
            errorMessage = 'Sunucu hatası. Lütfen tekrar deneyin';
            break;
          default:
            errorMessage = e.response?.data?['message'] ?? 'Giriş başarısız oldu';
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Bağlantı zaman aşımına uğradı';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Yanıt alma zaman aşımına uğradı';
      } else if (e.type == DioExceptionType.unknown) {
        errorMessage = 'İnternet bağlantınızı kontrol edin';
      }

      return {'success': false, 'message': errorMessage};
    } catch (e) {
      return {'success': false, 'message': 'Beklenmeyen bir hata oluştu'};
    }
  }

  // Logout işlemi
  Future<void> logout() async {
    await _tokenService.logout();
  }

  // Token'ın geçerli olup olmadığını kontrol et
  Future<bool> isLoggedIn() async {
    return await _tokenService.isTokenValid();
  }

  // Mevcut token'ı al
  Future<String?> getCurrentToken() async {
    return await _tokenService.getToken();
  }

  // GET /user/profile - User profile
  Future<Map<String, dynamic>?> getProfile() async {
    try {
      final token = await _tokenService.getToken();
      if (token == null) return null;

      final response = await _dio.get(
        'https://caseapi.servicelabs.tech/user/profile',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      }

      return null;
    } catch (e) {
      debugPrint('Get profile API error: $e');
      return null;
    }
  }

  // POST /user/upload_photo - Upload photo
  Future<bool> uploadPhoto(String filePath) async {
    try {
      final token = await _tokenService.getToken();
      if (token == null) return false;

      FormData formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(filePath),
      });

      final response = await _dio.post(
        'https://caseapi.servicelabs.tech/user/upload_photo',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Upload photo API error: $e');
      return false;
    }
  }
}
