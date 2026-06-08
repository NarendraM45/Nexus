import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../features/auth/widgets/glass_text_field.dart';
import '../../../core/constants/app_colors.dart';

class PasswordFieldWidget extends StatefulWidget {
  final String hintText;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const PasswordFieldWidget({
    super.key,
    this.hintText = 'Password',
    this.validator,
    this.controller,
  });

  @override
  State<PasswordFieldWidget> createState() => _PasswordFieldWidgetState();
}

class _PasswordFieldWidgetState extends State<PasswordFieldWidget> {
  bool _obscureText = true;

  void _toggleVisibility() {
    HapticFeedback.lightImpact();
    setState(() => _obscureText = !_obscureText);
  }

  @override
  Widget build(BuildContext context) {
    return GlassTextField(
      controller: widget.controller,
      hintText: widget.hintText,
      prefixIcon: Icons.lock_outline,
      obscureText: _obscureText,
      validator: widget.validator,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: AppColors.neonViolet,
        ),
        onPressed: _toggleVisibility,
      ),
    );
  }
}
