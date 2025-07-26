import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/app_utils.dart';
import '../../utils/snackbar_status_enum.dart';
import '../../repositories/profile_repository.dart';
import '../../widgets/main_navigation_view.dart';

class PhotoUploadViewModel extends BaseViewModel {
  final ImagePicker _picker = ImagePicker();
  final ProfileRepository _profileRepository = ProfileRepository();
  File? _selectedImage;
  bool _isLoading = false;

  // Getters
  File? get selectedImage => _selectedImage;
  bool get isLoading => _isLoading;

  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (image != null) {
        _selectedImage = File(image.path);
        notifyListeners();
        debugPrint('Galeri resmi seçildi: ${image.path}');
      } else {
        debugPrint('Galeri resmi seçilmedi');
      }
    } catch (e) {
      debugPrint('Galeri hatası: $e');
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (image != null) {
        _selectedImage = File(image.path);
        notifyListeners();
        debugPrint('Kamera resmi çekildi: ${image.path}');
      } else {
        debugPrint('Kamera resmi çekilmedi');
      }
    } catch (e) {
      debugPrint('Kamera hatası: $e');
    }
  }

  void removeImage() {
    _selectedImage = null;
    notifyListeners();
  }

  Future<void> uploadPhoto(BuildContext context, {bool fromRegister = false}) async {
    if (_selectedImage == null) {
      AppUtils.showSnackBar(
        context,
        'Lütfen bir fotoğraf seçin',
        status: MessageStatus.error,
      );
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      debugPrint('Starting photo upload...');
      debugPrint('Image path: ${_selectedImage!.path}');

      // Try multipart upload (as per API documentation)
      debugPrint('Attempting multipart upload according to API doc...');
      final response = await _profileRepository.uploadProfilePhoto(_selectedImage!);

      debugPrint('Multipart upload response: $response');

      // Check response format: {response: {code: 200, message: ""}, data: {...}}
      if (response['response']?['code'] == 200) {
        AppUtils.showSnackBar(
          context,
          'Profil fotoğrafı başarıyla yüklendi!',
          status: MessageStatus.success,
        );

        // Navigation logic based on entry point
        if (fromRegister) {
          // Coming from register - navigate to main app (replace all)
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MainNavigationView(),
            ),
          );
        } else {
          // Coming from profile - go back to profile
          Navigator.of(context).pop();
        }
        return;
      } else {
        debugPrint('Upload failed with response: $response');
        final errorMessage = response['response']?['message'] ?? 'Fotoğraf yüklenirken bir hata oluştu';
        AppUtils.showSnackBar(
          context,
          errorMessage,
          status: MessageStatus.error,
        );
      }
    } catch (e) {
      debugPrint('Upload error details: $e');
      debugPrint('Error type: ${e.runtimeType}');

      AppUtils.showSnackBar(
        context,
        'Fotoğraf yüklenirken bir hata oluştu: ${e.toString()}',
        status: MessageStatus.error,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> skipPhotoUpload(BuildContext context, {bool fromRegister = false}) async {
    // Navigation logic based on entry point
    if (fromRegister) {
      // Coming from register - navigate to main app (replace all)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MainNavigationView(),
        ),
      );
    } else {
      // Coming from profile - go back to profile
      Navigator.of(context).pop();
    }
  }
}
