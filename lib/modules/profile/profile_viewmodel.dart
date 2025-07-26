import 'package:stacked/stacked.dart';
import '../../services/token_service.dart';
import '../../repositories/movie_repository.dart';
import '../../repositories/profile_repository.dart';
import '../../models/movie_list_response.dart';
import '../../models/user.dart';

class ProfileViewModel extends BaseViewModel {
  final TokenService _tokenService = TokenService();
  final ProfileRepository _profileRepository = ProfileRepository();
  final MovieRepository _movieRepository = MovieRepository();

  User? _currentUser;
  List<MovieResponse> favoriteMovies = [];

  // Getters
  User? get currentUser => _currentUser;
  String get userName => _currentUser?.name ?? 'Kullanıcı';
  String get userId => 'ID: ${_currentUser?.id ?? '000000'}';
  String get userPhotoUrl => _currentUser?.photoUrl ?? '';
  String get userInitials => _currentUser?.initials ?? '?';
  String get userEmail => _currentUser?.email ?? '';

  Future<void> loadUserData() async {
    setBusy(true);
    try {
      print('ProfileViewModel: Loading user data');

      // Get user profile from ProfileRepository (no caching)
      _currentUser = await _profileRepository.getUserProfile();

      print('ProfileViewModel: User loaded: ${_currentUser?.name}');
      notifyListeners();
    } catch (e) {
      print('ProfileViewModel: Error loading user data: $e');

      // Fallback: try to get from TokenService
      try {
        final userData = await _tokenService.getUserData();
        if (userData != null) {
          _currentUser = User.fromJson(userData);
          print('ProfileViewModel: Fallback user data loaded from TokenService');
        } else {
          // Final fallback
          _currentUser = User(
            id: '000000',
            name: 'Kullanıcı',
            email: 'user@example.com',
          );
          print('ProfileViewModel: Using fallback user data');
        }
        notifyListeners();
      } catch (fallbackError) {
        print('ProfileViewModel: Fallback also failed: $fallbackError');
        setError('Kullanıcı bilgileri yüklenemedi');
      }
    } finally {
      setBusy(false);
    }
  }

  Future<void> loadFavoriteMovies() async {
    setBusy(true);
    try {
      favoriteMovies = await _movieRepository.getFavoriteMovies();
      notifyListeners();
    } catch (e) {
      print('Favori filmler yüklenemedi: $e');
      setError('Favori filmler yüklenemedi');
      // Hata durumunda boş liste
      favoriteMovies = [];
    } finally {
      setBusy(false);
    }
  }

  Future<void> refreshFavorites() async {
    await loadFavoriteMovies();
  }

  void onPhotoTap() {
    // Fotoğraf ekleme işlemi
    print('Fotoğraf ekleme tıklandı');
  }

  void onSinirliTeklifTap() {
    // Sınırlı teklif işlemi
    print('Sınırlı teklif tıklandı');
  }

  void onMovieTap(MovieResponse movie) {
    // Film detayına git
    print('Film tıklandı: ${movie.title}');
  }
}
