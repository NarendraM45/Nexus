import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/loading/loading_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/signup_screen.dart';
import '../../shared/layouts/main_shell.dart';
import '../../features/home/home_screen.dart';
import '../../features/explore/explore_screen.dart';
import '../../features/activity/activity_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/explore/explore_detail_screen.dart';
import '../../features/calendar/calendar_screen.dart';
import '../../features/team/team_screen.dart';
import '../../features/tasks/tasks_screen.dart';
import '../../features/analytics/analytics_screen.dart';
import '../../features/notes/notes_screen.dart';
import '../../features/projects/projects_screen.dart';
import '../../features/profile/edit_profile_screen.dart';
import '../providers/app_providers.dart';
import '../providers/auth_provider.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final authState = ProviderScope.containerOf(context).read(authProvider);
      final isLoggedIn = authState.isLoggedIn;
      final goingToAuth = state.matchedLocation == '/login' ||
                          state.matchedLocation == '/signup' ||
                          state.matchedLocation == '/onboarding' ||
                          state.matchedLocation == '/splash';
      if (!isLoggedIn && !goingToAuth) return '/login';
      if (isLoggedIn && goingToAuth && state.matchedLocation != '/splash') return '/home';
      return null;
    },
    
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded,
              color: AppColors.neonRose, size: 64),
            const SizedBox(height: 16),
            Text('Page not found',
              style: AppTypography.h1(Theme.of(context).colorScheme.onSurface)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),

    routes: [
      GoRoute(
        path: '/splash',
        pageBuilder: (ctx, state) => _fadeScalePage(const SplashScreen()),
      ),
      GoRoute(
        path: '/onboarding',
        pageBuilder: (ctx, state) => _fadeScalePage(const OnboardingScreen()),
      ),
      GoRoute(
        path: '/loading',
        pageBuilder: (ctx, state) => _fadeScalePage(const LoadingScreen()),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (ctx, state) => _fadeScalePage(const LoginScreen()),
      ),
      GoRoute(
        path: '/signup',
        pageBuilder: (ctx, state) => _fadeScalePage(const SignupScreen()),
      ),
      ShellRoute(
        builder: (ctx, state, child) => MainShell(child: child),
        routes: [
          GoRoute(path: '/home', pageBuilder: (ctx, state) => _fadePage(ctx, state, const HomeScreen())),
          GoRoute(path: '/explore', pageBuilder: (ctx, state) => _fadePage(ctx, state, const ExploreScreen())),
          GoRoute(path: '/status', pageBuilder: (ctx, state) => _fadePage(ctx, state, const ActivityScreen())),
          GoRoute(path: '/profile', pageBuilder: (ctx, state) => _fadePage(ctx, state, const ProfileScreen())),
          GoRoute(path: '/tasks', pageBuilder: (ctx, state) => _fadePage(ctx, state, const TasksScreen())),
          GoRoute(path: '/analytics', pageBuilder: (ctx, state) => _fadePage(ctx, state, const AnalyticsScreen())),
          GoRoute(path: '/notes', pageBuilder: (ctx, state) => _fadePage(ctx, state, const NotesScreen())),
          GoRoute(path: '/projects', pageBuilder: (ctx, state) => _fadePage(ctx, state, const ProjectsScreen())),
          GoRoute(path: '/team', pageBuilder: (ctx, state) => _fadePage(ctx, state, const TeamScreen())),
          GoRoute(path: '/calendar', pageBuilder: (ctx, state) => _fadePage(ctx, state, const CalendarScreen())),
          GoRoute(path: '/settings', pageBuilder: (ctx, state) => _noTransitionPage(const SettingsScreen())),
        ],
      ),
      GoRoute(
        path: '/profile/edit',
        pageBuilder: (ctx, state) => _fadeScalePage(const EditProfileScreen()),
      ),
      GoRoute(
        path: '/explore/:id',
        pageBuilder: (ctx, state) {
          final id = state.pathParameters['id'] ?? 'e1';
          final items = ProviderScope.containerOf(ctx).read(exploreItemsProvider);
          final item = items.firstWhere(
            (e) => e.id == id,
            orElse: () => items.first,
          );
          return _fadeScalePage(ExploreDetailScreen(item: item));
        },
      ),
    ],
  );
});

CustomTransitionPage<void> _fadeScalePage(Widget child) {
  return CustomTransitionPage<void>(
    transitionDuration: const Duration(milliseconds: 600),
    transitionsBuilder: (ctx, anim, secAnim, child) => FadeTransition(
      opacity: CurveTween(curve: Curves.easeOut).animate(anim),
      child: ScaleTransition(
        scale: Tween(begin: 0.94, end: 1.0)
          .chain(CurveTween(curve: Curves.easeOut)).animate(anim),
        child: child,
      ),
    ),
    child: child,
  );
}

CustomTransitionPage<void> _fadePage(BuildContext context, GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 350),
    reverseTransitionDuration: const Duration(milliseconds: 280),
    transitionsBuilder: (ctx, animation, secondaryAnimation, child) =>
        FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          child: child,
        ),
  );
}

NoTransitionPage<void> _noTransitionPage(Widget child) {
  return NoTransitionPage<void>(child: child);
}
