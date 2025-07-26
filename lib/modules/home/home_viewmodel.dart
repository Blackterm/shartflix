import 'package:stacked/stacked.dart';
import '../../models/movie_list_response.dart';
import '../../repositories/movie_repository.dart';

class HomeViewModel extends BaseViewModel {
  final MovieRepository _movieRepository = MovieRepository();

  List<MovieResponse> _movies = [];
  String? _errorMessage;
  int _currentPage = 1;
  int _totalPages = 0;
  bool _hasMorePages = true;
  int _totalCount = 0;

  List<MovieResponse> get movies => _movies;
  String? get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  bool get hasMorePages => _hasMorePages;
  int get totalCount => _totalCount;

  Future<void> loadMovies({bool refresh = false}) async {
    if (isBusy) return;

    if (refresh) {
      _currentPage = 1;
      _movies.clear();
      _hasMorePages = true;
    }

    if (!_hasMorePages && !refresh) return;

    setBusy(true);
    _errorMessage = null;

    try {
      final response = await _movieRepository.getMovieList(page: _currentPage);

      if (response != null) {
        if (refresh) {
          _movies = response.data.movies;
        } else {
          _movies.addAll(response.data.movies);
        }

        _totalPages = response.data.pagination.maxPage;
        _currentPage = response.data.pagination.currentPage;
        _totalCount = response.data.pagination.totalCount;
        _hasMorePages = _currentPage < _totalPages;

        if (!refresh && _hasMorePages) {
          _currentPage++;
        }
      }
    } catch (e) {
      _errorMessage = e.toString();
      setError(e.toString());
    } finally {
      setBusy(false);
    }
  }

  Future<void> loadMoreMovies() async {
    if (_hasMorePages && !isBusy) {
      await loadMovies();
    }
  }

  Future<void> refreshMovies() async {
    await loadMovies(refresh: true);
  }

  void clearError() {
    _errorMessage = null;
    setError(null);
    notifyListeners();
  }

  Future<void> toggleFavorite(MovieResponse movie) async {
    try {
      // API'ye favori toggle isteği gönder
      await _movieRepository.toggleFavorite(movie.id);

      // Local state'i güncelle
      final movieIndex = _movies.indexWhere((m) => m.id == movie.id);
      if (movieIndex != -1) {
        _movies[movieIndex] = MovieResponse(
          id: movie.id,
          title: movie.title,
          year: movie.year,
          rated: movie.rated,
          released: movie.released,
          runtime: movie.runtime,
          genre: movie.genre,
          director: movie.director,
          writer: movie.writer,
          actors: movie.actors,
          plot: movie.plot,
          language: movie.language,
          country: movie.country,
          awards: movie.awards,
          poster: movie.poster,
          metascore: movie.metascore,
          imdbRating: movie.imdbRating,
          imdbVotes: movie.imdbVotes,
          imdbID: movie.imdbID,
          type: movie.type,
          response: movie.response,
          images: movie.images,
          comingSoon: movie.comingSoon,
          isFavorite: !movie.isFavorite, // Toggle favorite status
        );
        notifyListeners();
      }
    } catch (e) {
      // Hata durumunda kullanıcıya bildir
      setError('Favori işlemi başarısız: $e');
    }
  }
}
