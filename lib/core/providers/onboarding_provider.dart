import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final onboardingProvider = StateNotifierProvider<OnboardingNotifier, bool>((ref) {
  return OnboardingNotifier();
});

class OnboardingNotifier extends StateNotifier<bool> {
  OnboardingNotifier() : super(false) { _load(); }

  Future<void> _load() async {
    try {
      final p = await SharedPreferences.getInstance();
      state = p.getBool('onboarded') ?? false;
    } catch (_) {
      state = false;
    }
  }

  Future<void> complete() async {
    state = true;
    try {
      final p = await SharedPreferences.getInstance();
      await p.setBool('onboarded', true);
    } catch (_) {}
  }
}
