import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/auth_provider.dart';
import '../../shared/widgets/custom/safe_lottie.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _showPass = false;
  bool _shakeForm = false;
  bool _showSuccess = false;

  void _submit() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final data = _formKey.currentState!.value;
      await ref.read(authProvider.notifier).signup(
        name: data['name'],
        email: data['email'],
        password: data['password'],
      );
      if (mounted) {
        final authState = ref.read(authProvider);
        if (authState.isLoggedIn) {
          TextInput.finishAutofillContext();
          setState(() => _showSuccess = true);
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (mounted) context.go('/loading');
          });
        }
      }
    } else {
      HapticFeedback.heavyImpact();
      setState(() => _shakeForm = true);
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => _shakeForm = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          const SafeLottie(
            assetPath: 'assets/lottie/dolphin_bg.json',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            repeat: true,
          ),
          
          // Overlay
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black38, Colors.black87],
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                children: [
                  const Hero(
                    tag: 'nexus_logo',
                    child: Image(
                      image: AssetImage('assets/icon/icon.png'),
                      width: 70, height: 70,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Create Account',
                    style: GoogleFonts.orbitron(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Join the Hub',
                    style: GoogleFonts.sora(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Glassmorphic Card
                  ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.10),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: AutofillGroup(
                          child: FormBuilder(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildTextField(
                                  name: 'name',
                                  label: 'Full Name',
                                  icon: Icons.person_outline,
                                  autofillHints: const [AutofillHints.name],
                                  validator: FormBuilderValidators.required(),
                                ),
                              const SizedBox(height: 16),
                              _buildTextField(
                                name: 'email',
                                label: 'Email',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: const [AutofillHints.email],
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.email(),
                                ]),
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(
                                name: 'password',
                                label: 'Password',
                                icon: Icons.lock_outline,
                                obscureText: !_showPass,
                                autofillHints: const [AutofillHints.newPassword],
                                suffix: IconButton(
                                  icon: Icon(
                                    _showPass ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.white70,
                                  ),
                                  onPressed: () => setState(() => _showPass = !_showPass),
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.minLength(6),
                                ]),
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(
                                name: 'confirm_password',
                                label: 'Confirm Password',
                                icon: Icons.lock_outline,
                                obscureText: !_showPass,
                                validator: (val) {
                                  if (val == null || val.isEmpty) return 'This field cannot be empty.';
                                  if (val != _formKey.currentState?.fields['password']?.value) {
                                    return 'Passwords do not match.';
                                  }
                                  return null;
                                },
                              ),
                              
                              if (authState.error != null) ...[
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: AppColors.neonCoral.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.neonCoral.withValues(alpha: 0.5)),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.error_outline, color: AppColors.neonCoral, size: 20),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          authState.error!,
                                          style: GoogleFonts.nunito(color: Colors.white, fontSize: 13),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              const SizedBox(height: 32),
                              GestureDetector(
                                onTap: authState.isLoading ? null : _submit,
                                child: Container(
                                  height: 56,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.nexusBrandGrad,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  alignment: Alignment.center,
                                  child: authState.isLoading
                                      ? const CircularProgressIndicator(color: Colors.white)
                                      : Text(
                                          'Create Account',
                                          style: GoogleFonts.sora(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ),
                    ),
                  )
                  .animate(target: _shakeForm ? 1 : 0)
                  .shake(duration: const Duration(milliseconds: 500)),

                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account? ", style: GoogleFonts.nunito(color: Colors.white70)),
                      GestureDetector(
                        onTap: () => context.go('/login'),
                        child: Text(
                          "Sign In",
                          style: GoogleFonts.nunito(
                            color: AppColors.neonCyan,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Success Overlay
          if (_showSuccess)
            Positioned.fill(
              child: Container(
                color: AppColors.darkBg.withValues(alpha: 0.9),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SafeLottie(
                      assetPath: 'assets/lottie/success_check.json',
                      width: 160, height: 160,
                      repeat: false,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Welcome to Nexus!',
                      style: GoogleFonts.sora(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ).animate().fadeIn(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String name,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffix,
    TextInputType? keyboardType,
    Iterable<String>? autofillHints,
    String? Function(String?)? validator,
  }) {
    return FormBuilderTextField(
      name: name,
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      style: GoogleFonts.nunito(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.nunito(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.neonPurple, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.neonCoral, width: 1.5),
        ),
      ),
    );
  }
}
