import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:stacked/stacked.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../repositories/auth_repository.dart';
import '../../utils/app_utils.dart';
import '../../utils/snackbar_status_enum.dart';
import '../photo_upload/photo_upload_view.dart';

class RegisterViewModel extends BaseViewModel {
  // Repository
  final AuthRepository _authRepository = AuthRepository();

  // Text controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Form key for validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Password visibility states
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  // Getters
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isLoading => _isLoading;

  // Toggle password visibility
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  // Validation methods
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'name_required'.tr();
    }
    if (value.length < 2) {
      return 'name_min_length'.tr();
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'email_required'.tr();
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
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

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'confirm_password_required'.tr();
    }
    if (value != passwordController.text) {
      return 'passwords_not_match'.tr();
    }
    return null;
  }

  // Register method
  Future<void> register(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _authRepository.register(
        email: emailController.text.trim(),
        name: nameController.text.trim(),
        password: passwordController.text,
      );

      if (result['success']) {
        // Başarılı kayıt
        if (kDebugMode) {
          debugPrint('Registration successful: ${result['data']}');
        }

        // Başarı mesajı göster
        AppUtils.showSnackBar(
          context,
          result['message'] ?? 'Kayıt başarılı!',
          status: MessageStatus.success,
        );

        // PhotoUploadView'e yönlendir (fromRegister: true parametresi ile)
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const PhotoUploadView(fromRegister: true),
          ),
        );
      } else {
        // Hata durumu
        if (kDebugMode) {
          debugPrint('Registration failed: ${result['message']}');
        }

        // Hata mesajını göster
        AppUtils.showSnackBar(
          context,
          result['message'] ?? 'Kayıt işlemi başarısız oldu',
          status: MessageStatus.error,
        );
      }
    } catch (e) {
      // Beklenmeyen hata
      if (kDebugMode) {
        debugPrint('Registration error: $e');
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

  // Social login methods
  Future<void> loginWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      if (kDebugMode) {
        debugPrint('Google login');
      }
      // TODO: Implement Google login
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Google login error: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginWithApple() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      if (kDebugMode) {
        debugPrint('Apple login');
      }
      // TODO: Implement Apple login
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Apple login error: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginWithFacebook() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      if (kDebugMode) {
        debugPrint('Facebook login');
      }
      // TODO: Implement Facebook login
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Facebook login error: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
