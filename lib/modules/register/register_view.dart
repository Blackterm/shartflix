import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'register_viewmodel.dart';
import '../../utils/app_utils.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../login/login_view.dart';

class RegisterView extends StackedView<RegisterViewModel> {
  const RegisterView({super.key});

  @override
  Widget builder(
    BuildContext context,
    RegisterViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: viewModel.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // Header
                _buildHeader(),

                const SizedBox(height: 50),

                // Name Field
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: CustomTextField(
                    hint: 'full_name'.tr(),
                    controller: viewModel.nameController,
                    validator: viewModel.validateName,
                    prefixIcon: Icons.person,
                  ),
                ),

                const SizedBox(height: 20),

                // Email Field
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  child: CustomTextField(
                    hint: 'email'.tr(),
                    controller: viewModel.emailController,
                    validator: viewModel.validateEmail,
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),

                const SizedBox(height: 20),

                // Password Field
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  child: CustomTextField(
                    hint: 'password'.tr(),
                    controller: viewModel.passwordController,
                    validator: viewModel.validatePassword,
                    prefixIcon: Icons.lock,
                    isPassword: true,
                    isPasswordVisible: viewModel.isPasswordVisible,
                    onTogglePassword: viewModel.togglePasswordVisibility,
                  ),
                ),

                const SizedBox(height: 20),

                // Confirm Password Field
                FadeInUp(
                  delay: const Duration(milliseconds: 500),
                  child: CustomTextField(
                    hint: 'confirm_password'.tr(),
                    controller: viewModel.confirmPasswordController,
                    validator: viewModel.validateConfirmPassword,
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    isPasswordVisible: false, // Always hidden, no toggle
                  ),
                ),

                const SizedBox(height: 40),

                // Register Button
                FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  child: CustomButton(
                    onPressed: () => viewModel.register(context),
                    text: 'register_now',
                    isLoading: viewModel.isLoading,
                  ),
                ),
                const SizedBox(height: 30),

                FadeInUp(
                  delay: const Duration(milliseconds: 700),
                  child: _terms(context),
                ),

                const SizedBox(height: 30),

                // Social Login Buttons
                FadeInUp(
                  delay: const Duration(milliseconds: 800),
                  child: _buildSocialLoginButtons(viewModel),
                ),

                const SizedBox(height: 30),

                // Login Link
                FadeInUp(
                  delay: const Duration(milliseconds: 900),
                  child: _buildLoginLink(context),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  RegisterViewModel viewModelBuilder(BuildContext context) => RegisterViewModel();

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'register_welcome'.tr(),
          style: const TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'register_subtitle'.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _terms(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'terms_prefix'.tr(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: Colors.grey[400],
            ),
          ),
          WidgetSpan(
            child: GestureDetector(
              onTap: () {
                _openWebView(context);
              },
              child: Text(
                'terms_link'.tr(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                ),
              ),
            ),
          ),
          TextSpan(
            text: 'terms_suffix'.tr(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  void _openWebView(BuildContext context) async {
    await AppUtils.openTermsOfService(context);
  }

  Widget _buildSocialLoginButtons(RegisterViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Google
        _buildSocialIconButton(
          icon: Icons.g_mobiledata,
          onPressed: viewModel.loginWithGoogle,
        ),
        const SizedBox(width: 20),
        // Apple
        _buildSocialIconButton(
          icon: Icons.apple,
          onPressed: viewModel.loginWithApple,
        ),
        const SizedBox(width: 20),
        // Facebook
        _buildSocialIconButton(
          icon: Icons.facebook,
          onPressed: viewModel.loginWithFacebook,
        ),
      ],
    );
  }

  Widget _buildSocialIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey[800]!),
        color: Colors.grey[900],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: Colors.white,
          size: 35,
        ),
      ),
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'already_have_account'.tr(),
          style: TextStyle(color: Colors.grey[400]),
        ),
        GestureDetector(
          onTap: () {
            // Navigate to login page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginView(),
              ),
            );
          },
          child: Text(
            'login_now'.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
