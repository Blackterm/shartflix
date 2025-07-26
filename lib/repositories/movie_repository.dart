import 'package:dio/dio.dart';
import '../models/movie_list_response.dart';
import '../services/dio_service.dart';
import '../services/token_service.dart';

class MovieRepository {
  final Dio _dio;
  final TokenService _tokenService;

  MovieRepository({Dio? dio, TokenService? tokenService})
      : _dio = dio ?? DioService.getDioInstance(),
        _tokenService = tokenService ?? TokenService();

  Future<MovieListResponse?> getMovieList({int page = 1}) async {
    try {
      // Token'ı al
      final token = await _tokenService.getToken();
      if (token == null) {
        throw Exception('Token bulunamadı');
      }

      // Headers'a token ekle
      final options = Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final response = await _dio.get(
        'movie/list',
        queryParameters: {'page': page},
        options: options,
      );
      if (response.statusCode == 200) {
        final movieListResponse = MovieListResponse.fromJson(response.data);
        return movieListResponse;
      } else {
        throw Exception('Film listesi alınamadı: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network hatası: ${e.message}');
    } catch (e) {
      throw Exception('Beklenmeyen hata: $e');
    }
  }

  Future<bool> toggleFavorite(String movieId) async {
    try {
      // Token'ı al
      final token = await _tokenService.getToken();
      if (token == null) {
        throw Exception('Token bulunamadı');
      }

      // Headers'a token ekle
      final options = Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final response = await _dio.post(
        'movie/favorite/$movieId',
        options: options,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Favori işlemi başarısız: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network hatası: ${e.message}');
    } catch (e) {
      throw Exception('Beklenmeyen hata: $e');
    }
  }

  Future<List<MovieResponse>> getFavoriteMovies() async {
    try {
      // Token'ı al
      final token = await _tokenService.getToken();
      if (token == null) {
        throw Exception('Token bulunamadı');
      }

      // Headers'a token ekle
      final options = Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final response = await _dio.get(
        'movie/favorites',
        options: options,
      );

      if (response.statusCode == 200) {
        // API'den gelen response formatına göre parse et
        final List<dynamic> favoritesData = response.data['data'] ?? response.data;
        final List<MovieResponse> favoriteMovies =
            favoritesData.map((movieJson) => MovieResponse.fromJson(movieJson)).toList();

        return favoriteMovies;
      } else {
        throw Exception('Favori filmler alınamadı: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network hatası: ${e.message}');
    } catch (e) {
      throw Exception('Beklenmeyen hata: $e');
    }
  }
}
