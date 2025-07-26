import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final IconData prefixIcon;
  final TextInputType? keyboardType;
  final bool isPassword;
  final bool isPasswordVisible;
  final VoidCallback? onTogglePassword;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.controller,
    required this.validator,
    required this.prefixIcon,
    this.keyboardType,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.onTogglePassword,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[800]!),
          ),
          child: TextFormField(
            controller: widget.controller,
            validator: (value) {
              final error = widget.validator(value);
              // Validation sonucunu state'e kaydet
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    _errorMessage = error;
                  });
                }
              });
              return null; // TextFormField'ın kendi hata gösterimini tamamen kapat
            },
            keyboardType: widget.keyboardType,
            obscureText: widget.isPassword && !widget.isPasswordVisible,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: 16,
              ),
              prefixIcon: Icon(
                widget.prefixIcon,
                color: Colors.grey[500],
                size: 22,
              ),
              suffixIcon: widget.isPassword && widget.onTogglePassword != null
                  ? IconButton(
                      icon: Icon(
                        !widget.isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: Colors.grey[500],
                        size: 22,
                      ),
                      onPressed: widget.onTogglePassword,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              // Hata gösterimini tamamen kapat
              errorStyle: const TextStyle(
                height: 0,
                color: Colors.transparent,
                fontSize: 0,
              ),
              errorMaxLines: 1,
              isDense: true,
            ),
          ),
        ),
        // Hata mesajını aşağıda göster
        if (_errorMessage != null && _errorMessage!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8),
            child: Text(
              _errorMessage!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
