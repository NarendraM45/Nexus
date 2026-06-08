import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class FeatureItem {
  final String id;
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color glowColor;
  final String? subtitle;
  final String route;
  final Gradient gradient;
  final String? badge;

  const FeatureItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.iconColor,
    this.glowColor = Colors.transparent, // Default value to prevent errors
    this.subtitle,
    required this.route,
    required this.gradient,
    this.badge,
  });
}

class FeatureItems {
  static const List<FeatureItem> all = [
    FeatureItem(
      id: 'status',      
      title: 'Status',
      subtitle: 'Circling progress',
      icon: Icons.track_changes_rounded,
      iconColor: AppColors.neonCyan,
      glowColor: AppColors.neonCyan,
      gradient: AppColors.primaryGrad,
      route: '/status',
    ),
    FeatureItem(
      id: 'tasks',      
      title: 'My Tasks',
      subtitle: 'Track your work',
      icon: Icons.task_alt_rounded,
      iconColor: AppColors.neonAmber,
      glowColor: AppColors.neonAmber,
      gradient: AppColors.warmGrad,
      route: '/tasks',
      badge: '7',
    ),
    FeatureItem(
      id: 'explore',    
      title: 'Explore',
      subtitle: 'Discover content',
      icon: Icons.explore_rounded,
      iconColor: AppColors.neonViolet,
      glowColor: AppColors.neonViolet,
      gradient: LinearGradient(
        colors: [Color(0xFF7C3AED), Color(0xFFEC4899)]),
      route: '/explore',
    ),
    FeatureItem(
      id: 'projects',
      title: 'Projects',
      subtitle: 'Your active work',
      icon: Icons.account_tree_rounded,
      iconColor: AppColors.neonCyan,
      glowColor: AppColors.neonCyan,
      gradient: AppColors.primaryGrad,
      route: '/projects',
    ),
    FeatureItem(
      id: 'notes',
      title: 'Notes',
      subtitle: 'Your thoughts',
      icon: Icons.note_alt_rounded,
      iconColor: AppColors.neonGreen,
      glowColor: AppColors.neonGreen,
      gradient: LinearGradient(
        colors: [Color(0xFF10B981), Color(0xFF00D9F5)]),
      route: '/notes',
    ),
    FeatureItem(
      id: 'analytics',  
      title: 'Analytics',
      subtitle: 'Your performance',
      icon: Icons.bar_chart_rounded,
      iconColor: AppColors.neonAmber,
      glowColor: AppColors.neonAmber,
      gradient: AppColors.warmGrad,
      route: '/analytics',
    ),
    FeatureItem(
      id: 'team',       
      title: 'Team',
      subtitle: 'Your cohort',
      icon: Icons.group_rounded,
      iconColor: AppColors.neonGreen,
      glowColor: AppColors.neonGreen,
      gradient: LinearGradient(
        colors: [Color(0xFF10B981), Color(0xFF00D9F5)]),
      route: '/team',
    ),
    FeatureItem(
      id: 'calendar',   
      title: 'Calendar',
      subtitle: 'Deadlines & meetings',
      icon: Icons.calendar_month_rounded,
      iconColor: AppColors.neonRose,
      glowColor: AppColors.neonRose,
      gradient: LinearGradient(
        colors: [Color(0xFFEC4899), Color(0xFFFF6B6B)]),
      route: '/calendar',
    ),
    FeatureItem(
      id: 'profile',    
      title: 'My Profile',
      subtitle: 'Stats & settings',
      icon: Icons.person_rounded,
      iconColor: AppColors.neonAmber,
      glowColor: AppColors.neonAmber,
      gradient: AppColors.warmGrad,
      route: '/profile',
    ),
  ];
}
