import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';

class GlassTextField extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final TextEditingController? controller;

  const GlassTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.onChanged,
    this.controller,
  });

  @override
  State<GlassTextField> createState() => _GlassTextFieldState();
}

class _GlassTextFieldState extends State<GlassTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Focus(
        onFocusChange: (focus) => setState(() => _isFocused = focus),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: _isFocused ? AppColors.neonCyan : AppColors.lightSubtext,
                width: _isFocused ? 2 : 1,
              ),
            ),
          ),
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            style: AppTypography.body(Theme.of(context).colorScheme.onSurface),
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: AppTypography.body(Theme.of(context).colorScheme.onSurface).copyWith(color: AppColors.lightSubtext),
              prefixIcon: Icon(
                widget.prefixIcon,
                color: _isFocused ? AppColors.neonCyan : AppColors.lightSubtext,
              ),
              suffixIcon: widget.suffixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
            validator: widget.validator,
          ),
        ),
      ),
    );
  }
}
