import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/providers/app_providers.dart';
import '../../core/providers/theme_provider.dart';
import '../../shared/widgets/custom/user_avatar.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _bioCtrl;
  late TextEditingController _passCtrl;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    _nameCtrl = TextEditingController(text: user.name);
    _emailCtrl = TextEditingController(text: user.email);
    _phoneCtrl = TextEditingController(text: '+1 (555) 123-4567'); // mock
    _bioCtrl = TextEditingController(text: 'Passionate about building seamless mobile experiences and exploring new technologies. Always learning!');
    _passCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _bioCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      // Create updated user and save to provider
      final currentUser = ref.read(userProvider);
      ref.read(userProvider.notifier).state = currentUser.copyWith(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        // In a real app we'd save photo, phone, bio, pass as well
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: AppColors.neonGreen,
        ),
      );
      context.pop();
    }
  }

  Widget _buildField(String label, TextEditingController controller, {bool obscure = false, int maxLines = 1, String? Function(String?)? validator}) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.label(Theme.of(context).colorScheme.onSurface).copyWith(color: AppColors.lightSubtext)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            obscureText: obscure,
            maxLines: maxLines,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            decoration: InputDecoration(
              filled: true,
              fillColor: isDark ? AppColors.darkCard : AppColors.lightCard,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: isDark ? Colors.white12 : Colors.black12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: isDark ? Colors.white12 : Colors.black12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.neonCyan),
              ),
            ),
            validator: validator,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: Text('Save', style: AppTypography.h3(Theme.of(context).colorScheme.onSurface).copyWith(color: AppColors.neonCyan)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: UserAvatar(
                  size: 120,
                  showEditButton: true,
                ),
              ),
              const SizedBox(height: 32),
              Text('Personal Info', style: AppTypography.h2(Theme.of(context).colorScheme.onSurface)),
              const SizedBox(height: 16),
              _buildField('Full Name', _nameCtrl, validator: (v) => v!.isEmpty ? 'Name cannot be empty' : null),
              _buildField('Email Address', _emailCtrl, validator: (v) => !v!.contains('@') ? 'Invalid email' : null),
              _buildField('Phone Number', _phoneCtrl),
              _buildField('Bio', _bioCtrl, maxLines: 3),
              const SizedBox(height: 16),
              Text('Security', style: AppTypography.h2(Theme.of(context).colorScheme.onSurface)),
              const SizedBox(height: 16),
              _buildField('Change Password', _passCtrl, obscure: true),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
