import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:animate_do/animate_do.dart';
import 'login_viewmodel.dart';
import '../register/register_view.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class LoginView extends StackedView<LoginViewModel> {
  const LoginView({super.key});

  @override
  Widget builder(
    BuildContext context,
    LoginViewModel viewModel,
    Widget? child,
  ) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.08,
                vertical: isSmallScreen ? 20 : 40,
              ),
              child: Column(
                children: [
                  // Spacer to center content
                  SizedBox(height: screenHeight * 0.15),

                  // Header Section
                  FadeInDown(
                    delay: const Duration(milliseconds: 100),
                    child: _buildHeader(),
                  ),

                  SizedBox(height: screenHeight * 0.08),

                  // Form Section
                  Form(
                    key: viewModel.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Email Field
                        FadeInUp(
                          delay: const Duration(milliseconds: 200),
                          child: CustomTextField(
                            hint: 'E-Posta',
                            controller: viewModel.emailController,
                            validator: viewModel.validateEmail,
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.025),

                        // Password Field
                        FadeInUp(
                          delay: const Duration(milliseconds: 300),
                          child: CustomTextField(
                            hint: 'Şifre',
                            controller: viewModel.passwordController,
                            validator: viewModel.validatePassword,
                            prefixIcon: Icons.lock_outline,
                            isPassword: true,
                            isPasswordVisible: viewModel.isPasswordVisible,
                            onTogglePassword: viewModel.togglePasswordVisibility,
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.025),

                        // Forgot Password
                        FadeInUp(
                          delay: const Duration(milliseconds: 400),
                          child: _buildForgotPassword(viewModel),
                        ),

                        SizedBox(height: screenHeight * 0.06),

                        // Login Button
                        FadeInUp(
                          delay: const Duration(milliseconds: 500),
                          child: _buildLoginButton(context, viewModel),
                        ),

                        SizedBox(height: screenHeight * 0.05),

                        // Social Login Buttons
                        FadeInUp(
                          delay: const Duration(milliseconds: 600),
                          child: _buildSocialLoginButtons(viewModel),
                        ),

                        SizedBox(height: screenHeight * 0.05),

                        // Register Link
                        FadeInUp(
                          delay: const Duration(milliseconds: 700),
                          child: _buildRegisterLink(context),
                        ),

                        SizedBox(height: screenHeight * 0.02),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  LoginViewModel viewModelBuilder(BuildContext context) => LoginViewModel();

  Widget _buildHeader() {
    return Column(
      children: [
        const Text(
          'Merhabalar',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Tempus varius a vitae interdum id\ntortor elementum tristique eleifend at.',
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

  Widget _buildForgotPassword(LoginViewModel model) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: model.forgotPassword,
        child: const Text(
          'Şifremi unuttum',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            decoration: TextDecoration.underline,
            decorationColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLoginButtons(LoginViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Google
        _buildSocialIconButton(
          icon: Icons.g_mobiledata,
          onPressed: model.loginWithGoogle,
        ),
        const SizedBox(width: 24),
        // Apple
        _buildSocialIconButton(
          icon: Icons.apple,
          onPressed: model.loginWithApple,
        ),
        const SizedBox(width: 24),
        // Facebook
        _buildSocialIconButton(
          icon: Icons.facebook,
          onPressed: model.loginWithFacebook,
        ),
      ],
    );
  }

  Widget _buildSocialIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(16),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildRegisterLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Bir hesabın yok mu? ',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const RegisterView(),
              ),
            );
          },
          child: const Text(
            'Kayıt Ol',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context, LoginViewModel model) {
    return CustomButton(
      onPressed: () => model.login(context),
      text: 'Giriş Yap',
      isLoading: model.isLoading,
      fontSize: 18,
      useTranslation: false, // Düz string kullanıyoruz
    );
  }
}
