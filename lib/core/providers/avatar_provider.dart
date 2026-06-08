import 'package:nexus/core/utils/app_logger.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

final avatarProvider = StateNotifierProvider<AvatarNotifier, String?>((ref) {
  return AvatarNotifier();
});

class AvatarNotifier extends StateNotifier<String?> {
  AvatarNotifier() : super(null) {
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final path = prefs.getString('profile_photo_path');
      // Verify the saved file still exists before setting state
      if (path != null && await File(path).exists()) {
        state = path;
      } else if (path != null) {
        // File was deleted externally — clear stale reference
        await prefs.remove('profile_photo_path');
      }
    } catch (e) {
      AppLogger.log('AvatarNotifier._load error: $e');
    }
  }

  Future<void> pickFromGallery() async {
    await _pick(ImageSource.gallery);
  }

  Future<void> pickFromCamera() async {
    await _pick(ImageSource.camera);
  }

  Future<void> _pick(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: source, imageQuality: 85);
      if (picked == null) return;

      // Copy picked image to app-local directory so it persists
      final appDir = File(picked.path).parent;
      final ext = picked.path.split('.').last;
      final savedFile = await File(picked.path).copy(
        '${appDir.path}/profile_avatar.$ext',
      );

      // Try cropping — if cropper fails, fall back to the raw picked file
      CroppedFile? cropped;
      try {
        cropped = await ImageCropper().cropImage(
          sourcePath: savedFile.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Crop Photo',
              toolbarColor: const Color(0xFF0D0F1A),
              toolbarWidgetColor: Colors.white,
              backgroundColor: const Color(0xFF0D0F1A),
              activeControlsWidgetColor: const Color(0xFF00E5FF),
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true,
            ),
            IOSUiSettings(title: 'Crop Photo', aspectRatioLockEnabled: true),
          ],
        );
      } catch (cropError) {
        AppLogger.log('ImageCropper error (using raw image): $cropError');
      }

      final finalPath = cropped?.path ?? savedFile.path;

      state = finalPath;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_photo_path', finalPath);
    } catch (e) {
      AppLogger.log('AvatarNotifier._pick error: $e');
    }
  }

  Future<void> removePhoto() async {
    state = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('profile_photo_path');
    } catch (e) {
      AppLogger.log('AvatarNotifier.removePhoto error: $e');
    }
  }
}
