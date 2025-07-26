import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:stacked/stacked.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../repositories/auth_repository.dart';
import '../../utils/app_utils.dart';
import '../../utils/snackbar_status_enum.dart';
import '../../widgets/main_navigation_view.dart';

class LoginViewModel extends BaseViewModel {
  // Repository
  final AuthRepository _authRepository = AuthRepository();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'email_required'.tr();
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'email_invalid'.tr();
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'password_required'.tr();
    }
    if (value.length < 6) {
      return 'password_min_length'.tr();
    }
    return null;
  }

  Future<void> login(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _authRepository.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (result['success']) {
        // Başarılı giriş
        if (kDebugMode) {
          debugPrint('Login successful: ${result['data']}');
        }

        // Başarı mesajı göster
        AppUtils.showSnackBar(
          context,
          result['message'] ?? 'Giriş başarılı!',
          status: MessageStatus.success,
        );

        // Main navigation sayfasına yönlendir (stack'i temizleyerek)
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainNavigationView()),
          (Route<dynamic> route) => false,
        );
      } else {
        // Hata durumu
        if (kDebugMode) {
          debugPrint('Login failed: ${result['message']}');
        }

        // Hata mesajını göster
        AppUtils.showSnackBar(
          context,
          result['message'] ?? 'Giriş işlemi başarısız oldu',
          status: MessageStatus.error,
        );
      }
    } catch (e) {
      // Beklenmeyen hata
      if (kDebugMode) {
        debugPrint('Login error: $e');
      }

      AppUtils.showSnackBar(
        context,
        'Beklenmeyen bir hata oluştu',
        status: MessageStatus.error,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginWithGoogle() async {
    // TODO: Implement Google login
    if (kDebugMode) {
      debugPrint('Google login pressed');
    }
  }

  Future<void> loginWithApple() async {
    // TODO: Implement Apple login
    if (kDebugMode) {
      debugPrint('Apple login pressed');
    }
  }

  Future<void> loginWithFacebook() async {
    // TODO: Implement Facebook login
    if (kDebugMode) {
      debugPrint('Facebook login pressed');
    }
  }

  Future<void> forgotPassword() async {
    // TODO: Implement forgot password
    if (kDebugMode) {
      debugPrint('Forgot password pressed');
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
