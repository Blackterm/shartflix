import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:animate_do/animate_do.dart';
import 'photo_upload_viewmodel.dart';
import '../../widgets/custom_button.dart';

class PhotoUploadView extends StackedView<PhotoUploadViewModel> {
  final bool fromRegister;

  const PhotoUploadView({super.key, this.fromRegister = false});

  @override
  Widget builder(
    BuildContext context,
    PhotoUploadViewModel viewModel,
    Widget? child,
  ) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: fromRegister
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
        title: const Text(
          'Profil Detayı',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.08,
              vertical: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header Section
                FadeInDown(
                  delay: const Duration(milliseconds: 100),
                  child: _buildHeader(),
                ),

                SizedBox(height: screenHeight * 0.08),

                // Photo Upload Section
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: _buildPhotoUploadSection(context, viewModel),
                ),

                const Spacer(),

                // Continue Button
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  child: SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      onPressed: () => viewModel.uploadPhoto(context, fromRegister: fromRegister),
                      text: 'Devam Et',
                      isLoading: viewModel.isLoading,
                      fontSize: 18,
                      useTranslation: false,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  PhotoUploadViewModel viewModelBuilder(BuildContext context) => PhotoUploadViewModel();

  Widget _buildHeader() {
    return Column(
      children: [
        const Text(
          'Fotoğraflarına Yükleyin',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Resources out incentivize \n relaxation floor loss cc.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[400],
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoUploadSection(BuildContext context, PhotoUploadViewModel viewModel) {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(30),
      ),
      child: viewModel.selectedImage != null
          ? Stack(
              children: [
                // Selected Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(17),
                  child: Image.file(
                    viewModel.selectedImage!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // Remove Button
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: viewModel.removeImage,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : _buildImagePicker(context, viewModel),
    );
  }

  Widget _buildImagePicker(BuildContext context, PhotoUploadViewModel viewModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Plus Icon
        GestureDetector(
          onTap: () => _showImagePickerOptions(context, viewModel),
          child: Icon(
            Icons.add,
            color: Colors.grey[600],
            size: 54,
          ),
        ),
      ],
    );
  }

  void _showImagePickerOptions(BuildContext context, PhotoUploadViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Fotoğraf Seç',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Camera Option
                _buildPickerOption(
                  icon: Icons.camera_alt,
                  label: 'Kamera',
                  onTap: () {
                    debugPrint('Kamera seçeneğine tıklandı');
                    Navigator.pop(context);
                    viewModel.pickImageFromCamera();
                  },
                ),
                // Gallery Option
                _buildPickerOption(
                  icon: Icons.photo_library,
                  label: 'Galeri',
                  onTap: () {
                    debugPrint('Galeri seçeneğine tıklandı');
                    Navigator.pop(context);
                    viewModel.pickImageFromGallery();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPickerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
