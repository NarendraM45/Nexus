import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/providers/avatar_provider.dart';
import '../../../core/providers/nav_state_provider.dart';
import 'safe_lottie.dart';

class UserAvatar extends ConsumerWidget {
  final double size;
  final bool showEditButton;
  final bool showOnlineDot;

  const UserAvatar({
    super.key,
    this.size = 64,
    this.showEditButton = false,
    this.showOnlineDot = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photoPath = ref.watch(avatarProvider);

    Widget avatarImage;
    if (photoPath != null) {
      avatarImage = ClipOval(
        child: Image.file(
          File(photoPath),
          fit: BoxFit.cover,
          width: size,
          height: size,
          errorBuilder: (c, e, s) => _placeholder(context),
        ),
      );
    } else {
      final user = ref.watch(userProvider);
      final initials = user.name.isNotEmpty
          ? user.name.split(' ').where((w) => w.isNotEmpty).map((w) => w[0]).take(2).join()
          : 'U';
      avatarImage = Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColors.primaryGrad,
        ),
        alignment: Alignment.center,
        child: Text(
          initials,
          style: GoogleFonts.orbitron(
            fontSize: size * 0.35,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      );
    }

    return Stack(
      children: [
        // Spinning gradient border ring
        Container(
          width: size + 6,
          height: size + 6,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.primaryGrad,
          ),
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: avatarImage,
          ),
        ),

        // Online dot
        if (showOnlineDot)
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              width: size * 0.22,
              height: size * 0.22,
              decoration: BoxDecoration(
                color: AppColors.neonGreen,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 2,
                ),
              ),
            ).animate(onPlay: (c) => c.repeat())
             .scaleXY(begin: 0.85, end: 1.15, duration: 1000.ms, curve: Curves.easeInOut)
             .then()
             .scaleXY(begin: 1.15, end: 0.85, duration: 1000.ms),
          ),

        // Edit button
        if (showEditButton)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => _showPhotoPicker(context, ref),
              child: Container(
                width: size * 0.32,
                height: size * 0.32,
                decoration: BoxDecoration(
                  gradient: AppColors.warmGrad,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: size * 0.18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _placeholder(BuildContext ctx) => Container(
    width: size,
    height: size,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      color: AppColors.darkCard,
    ),
    child: Icon(
      Icons.person_rounded,
      size: size * 0.5,
      color: Theme.of(ctx).colorScheme.onSurface.withValues(alpha: 0.4),
    ),
  );

  void _showPhotoPicker(BuildContext context, WidgetRef ref) {
    HapticFeedback.lightImpact();
    // Hide nav while picker is open
    ref.read(navVisibleProvider.notifier).state = false;
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PhotoPickerSheet(ref: ref),
    ).then((_) {
      // Restore nav when sheet closes
      ref.read(navVisibleProvider.notifier).state = true;
    });
  }
}

class _PhotoPickerSheet extends StatelessWidget {
  final WidgetRef ref;
  const _PhotoPickerSheet({required this.ref});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1E2030),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          // Camera Lottie
          const SafeLottie(
            assetPath: 'assets/lottie/camera_flash.json',
            width: 80,
            height: 80,
            fallback: Icon(
              Icons.add_a_photo_rounded,
              size: 48,
              color: AppColors.neonCyan,
            ),
          ),
          const SizedBox(height: 12),
          Text('Change Photo', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _PickerOption(
                  icon: Icons.photo_library_rounded,
                  label: 'Gallery',
                  color: AppColors.neonViolet,
                  onTap: () async {
                    Navigator.pop(context);
                    await ref.read(avatarProvider.notifier).pickFromGallery();
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _PickerOption(
                  icon: Icons.camera_alt_rounded,
                  label: 'Camera',
                  color: AppColors.neonCyan,
                  onTap: () async {
                    Navigator.pop(context);
                    await ref.read(avatarProvider.notifier).pickFromCamera();
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _PickerOption(
                  icon: Icons.delete_outline_rounded,
                  label: 'Remove',
                  color: AppColors.neonCoral,
                  onTap: () {
                    Navigator.pop(context);
                    ref.read(avatarProvider.notifier).removePhoto();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PickerOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _PickerOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
