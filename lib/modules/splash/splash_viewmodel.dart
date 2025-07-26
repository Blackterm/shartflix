import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'dart:async';
import '../../repositories/auth_repository.dart';
import '../../widgets/main_navigation_view.dart';
import '../login/login_view.dart';

class SplashViewModel extends BaseViewModel {
  static const int _splashDuration = 3; // seconds

  final AuthRepository _authRepository = AuthRepository();

  bool _isInitialized = false;
  bool _isLoggedIn = false;

  // Getters
  bool get isInitialized => _isInitialized;
  bool get isLoggedIn => _isLoggedIn;

  // Token kontrolü ile initialization ve navigation
  Future<void> initializeAndNavigate(BuildContext context) async {
    setBusy(true);

    // Token kontrolü yap
    _isLoggedIn = await _authRepository.isLoggedIn();

    // Minimum splash süresi
    await Future.delayed(const Duration(seconds: _splashDuration));

    _isInitialized = true;
    setBusy(false);
    notifyListeners();

    // Navigation logic
    if (context.mounted) {
      Widget targetPage;

      // Token var ise main navigation sayfasına, yoksa login sayfasına yönlendir
      if (_isLoggedIn) {
        targetPage = const MainNavigationView();
      } else {
        targetPage = const LoginView();
      }

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => targetPage,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 1000),
        ),
      );
    }
  }

  // Eski initialize metodu (geriye uyumluluk için)
  Future<void> initialize() async {
    setBusy(true);

    // Token kontrolü yap
    _isLoggedIn = await _authRepository.isLoggedIn();

    // Minimum splash süresi
    await Future.delayed(const Duration(seconds: _splashDuration));

    _isInitialized = true;
    setBusy(false);
    notifyListeners();
  }
}
