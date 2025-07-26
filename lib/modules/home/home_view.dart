import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/movie_list_response.dart';
import '../profile/profile_view.dart';
import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: viewModel.refreshMovies,
        child: viewModel.isBusy && viewModel.movies.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : viewModel.hasError && viewModel.movies.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Bir hata oluştu',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          viewModel.errorMessage ?? 'Bilinmeyen hata',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: viewModel.refreshMovies,
                          child: const Text('Tekrar Dene'),
                        ),
                      ],
                    ),
                  )
                : viewModel.movies.isEmpty
                    ? const Center(
                        child: Text('Henüz film bulunamadı'),
                      )
                    : Stack(
                        children: [
                          // Ana PageView
                          PageView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: viewModel.movies.length,
                            onPageChanged: (index) {
                              // Son sayfalara yaklaşıldığında yeni sayfa yükle
                              if (index >= viewModel.movies.length - 2 && !viewModel.isBusy && viewModel.hasMorePages) {
                                viewModel.loadMoreMovies();
                              }
                            },
                            itemBuilder: (context, index) {
                              final movie = viewModel.movies[index];
                              return _FullScreenMovieCard(
                                movie: movie,
                                onRefresh: viewModel.refreshMovies,
                                viewModel: viewModel,
                              );
                            },
                          ),
                          // Fixed global overlay elements
                          _buildFixedOverlay(context),
                        ],
                      ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();

  @override
  void onViewModelReady(HomeViewModel viewModel) {
    viewModel.loadMovies();
  }

  Widget _buildFixedOverlay(BuildContext context) {
    return Stack(
      children: [
        // Bottom Navigation (Sabit)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Anasayfa Button
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Anasayfa',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Profil Button
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileView(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Profil',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FullScreenMovieCard extends StatelessWidget {
  final MovieResponse movie;
  final VoidCallback onRefresh;
  final HomeViewModel viewModel;

  const _FullScreenMovieCard({
    required this.movie,
    required this.onRefresh,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    // HTTP URL'lerini HTTPS'e çevir
    String fixedPosterUrl = movie.poster;
    if (fixedPosterUrl.startsWith('http://')) {
      fixedPosterUrl = fixedPosterUrl.replaceFirst('http://', 'https://');
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: fixedPosterUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: fixedPosterUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF1a1a1a),
                              Color(0xFF333333),
                            ],
                          ),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white54,
                          ),
                        ),
                      );
                    },
                    errorWidget: (context, url, error) {
                      // Fallback olarak Images array'inden ilk resmi deneyelim (HTTPS'e çevrilerek)
                      if (movie.images.isNotEmpty) {
                        String fallbackUrl = movie.images.first;
                        if (fallbackUrl.startsWith('http://')) {
                          fallbackUrl = fallbackUrl.replaceFirst('http://', 'https://');
                        }
                        return CachedNetworkImage(
                          imageUrl: fallbackUrl,
                          fit: BoxFit.cover,
                          errorWidget: (context, url2, error2) {
                            return Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFF1a1a1a),
                                    Color(0xFF333333),
                                  ],
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.movie,
                                  size: 100,
                                  color: Colors.white54,
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF1a1a1a),
                              Color(0xFF333333),
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.movie,
                            size: 100,
                            color: Colors.white54,
                          ),
                        ),
                      );
                    },
                  )
                : Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF1a1a1a),
                          Color(0xFF333333),
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.movie,
                        size: 100,
                        color: Colors.white54,
                      ),
                    ),
                  ),
          ),
          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.8),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          // Favorite Button (Sağ Alt)
          Positioned(
            bottom: 200,
            right: 20,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
              ),
              child: IconButton(
                onPressed: () async {
                  // Favorite toggle functionality
                  await viewModel.toggleFavorite(movie);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(movie.isFavorite
                          ? '${movie.title} favorilerden çıkarıldı'
                          : '${movie.title} favorilere eklendi'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                icon: Icon(
                  movie.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: movie.isFavorite ? Colors.red : Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
          // Movie Info (Sol Alt)
          Positioned(
            bottom: 120,
            left: 20,
            right: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  movie.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Description
                Text(
                  movie.plot,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                // Movie Tags
              ],
            ),
          ),
        ],
      ),
    );
  }
}
