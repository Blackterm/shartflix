class ApiResponse {
  final int code;
  final String message;

  ApiResponse({
    required this.code,
    required this.message,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      code: json['code'] ?? 200,
      message: json['message'] ?? '',
    );
  }
}

class Pagination {
  final int totalCount;
  final int perPage;
  final int maxPage;
  final int currentPage;

  Pagination({
    required this.totalCount,
    required this.perPage,
    required this.maxPage,
    required this.currentPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      totalCount: json['totalCount'] ?? 0,
      perPage: json['perPage'] ?? 0,
      maxPage: json['maxPage'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
    );
  }
}

class MovieResponse {
  final String id;
  final String title;
  final String year;
  final String rated;
  final String released;
  final String runtime;
  final String genre;
  final String director;
  final String writer;
  final String actors;
  final String plot;
  final String language;
  final String country;
  final String awards;
  final String poster;
  final String metascore;
  final String imdbRating;
  final String imdbVotes;
  final String imdbID;
  final String type;
  final String response;
  final List<String> images;
  final bool comingSoon;
  final bool isFavorite;

  MovieResponse({
    required this.id,
    required this.title,
    required this.year,
    required this.rated,
    required this.released,
    required this.runtime,
    required this.genre,
    required this.director,
    required this.writer,
    required this.actors,
    required this.plot,
    required this.language,
    required this.country,
    required this.awards,
    required this.poster,
    required this.metascore,
    required this.imdbRating,
    required this.imdbVotes,
    required this.imdbID,
    required this.type,
    required this.response,
    required this.images,
    required this.comingSoon,
    required this.isFavorite,
  });

  factory MovieResponse.fromJson(Map<String, dynamic> json) {
    return MovieResponse(
      id: json['id'] ?? json['_id'] ?? '',
      title: json['Title'] ?? '',
      year: json['Year'] ?? '',
      rated: json['Rated'] ?? '',
      released: json['Released'] ?? '',
      runtime: json['Runtime'] ?? '',
      genre: json['Genre'] ?? '',
      director: json['Director'] ?? '',
      writer: json['Writer'] ?? '',
      actors: json['Actors'] ?? '',
      plot: json['Plot'] ?? '',
      language: json['Language'] ?? '',
      country: json['Country'] ?? '',
      awards: json['Awards'] ?? '',
      poster: json['Poster'] ?? '',
      metascore: json['Metascore'] ?? '',
      imdbRating: json['imdbRating'] ?? '',
      imdbVotes: json['imdbVotes'] ?? '',
      imdbID: json['imdbID'] ?? '',
      type: json['Type'] ?? '',
      response: json['Response'] ?? '',
      images: (json['Images'] as List<dynamic>?)?.map((img) => img.toString()).toList() ?? [],
      comingSoon: json['ComingSoon'] ?? false,
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Title': title,
      'Year': year,
      'Rated': rated,
      'Released': released,
      'Runtime': runtime,
      'Genre': genre,
      'Director': director,
      'Writer': writer,
      'Actors': actors,
      'Plot': plot,
      'Language': language,
      'Country': country,
      'Awards': awards,
      'Poster': poster,
      'Metascore': metascore,
      'imdbRating': imdbRating,
      'imdbVotes': imdbVotes,
      'imdbID': imdbID,
      'Type': type,
      'Response': response,
      'Images': images,
      'ComingSoon': comingSoon,
      'isFavorite': isFavorite,
    };
  }
}

class MovieData {
  final List<MovieResponse> movies;
  final Pagination pagination;

  MovieData({
    required this.movies,
    required this.pagination,
  });

  factory MovieData.fromJson(Map<String, dynamic> json) {
    return MovieData(
      movies: (json['movies'] as List<dynamic>?)?.map((movie) => MovieResponse.fromJson(movie)).toList() ?? [],
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

class MovieListResponse {
  final ApiResponse response;
  final MovieData data;

  MovieListResponse({
    required this.response,
    required this.data,
  });

  factory MovieListResponse.fromJson(Map<String, dynamic> json) {
    return MovieListResponse(
      response: ApiResponse.fromJson(json['response'] ?? {}),
      data: MovieData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': {
        'code': response.code,
        'message': response.message,
      },
      'data': {
        'movies': data.movies.map((movie) => movie.toJson()).toList(),
        'pagination': {
          'totalCount': data.pagination.totalCount,
          'perPage': data.pagination.perPage,
          'maxPage': data.pagination.maxPage,
          'currentPage': data.pagination.currentPage,
        },
      },
    };
  }
}
