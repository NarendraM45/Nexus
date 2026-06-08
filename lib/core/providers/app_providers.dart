import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user_model.dart';
import '../../models/explore_item_model.dart';

// ✅ USER — Starts as guest, updated by auth_provider
final userProvider = StateProvider<UserModel>((ref) {
  return const UserModel(
    id: 'guest',
    name: 'Guest User',
    email: 'guest@nexus.app',
    role: 'New Member',
    taskCount: 0,
    activeCount: 0,
    score: 0.0,
    streak: 0,
    isProMember: false,
  );
});



// ✅ EXPLORE ITEMS — Using Unsplash CDN (no API key needed, stable URLs)
final exploreItemsProvider = Provider<List<ExploreItem>>((ref) {
  return const [
    ExploreItem(
      id: 'p1', title: 'Nexus Hub Dashboard',
      subtitle: 'Central command interface for enterprise',
      imageUrl: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800&q=80',
      imageUrls: [
        'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800&q=80',
        'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=800&q=80',
        'https://images.unsplash.com/photo-1555421689-491a97ff2040?w=800&q=80'
      ],
      category: 'Fintech', views: 24500, rating: 4.9,
    ),
    ExploreItem(
      id: 'p2', title: 'Quantum Supply Chain',
      subtitle: 'Global logistics tracking system',
      imageUrl: 'https://images.unsplash.com/photo-1586528116311-ad8ed7c663b0?w=800&q=80',
      imageUrls: [
        'https://images.unsplash.com/photo-1586528116311-ad8ed7c663b0?w=800&q=80',
        'https://images.unsplash.com/photo-1566576912321-d58ddd7a6088?w=800&q=80',
        'https://images.unsplash.com/photo-1505751172876-fa1923c5c528?w=800&q=80'
      ],
      category: 'Logistics', views: 18200, rating: 4.8,
    ),
    ExploreItem(
      id: 'p3', title: 'AeroNav System',
      subtitle: 'Next-gen aerospace flight controls',
      imageUrl: 'https://images.unsplash.com/photo-1454789548928-9efd52dc4031?w=800&q=80',
      imageUrls: [
        'https://images.unsplash.com/photo-1454789548928-9efd52dc4031?w=800&q=80',
        'https://images.unsplash.com/photo-1446776811953-b23d57bd21aa?w=800&q=80',
        'https://images.unsplash.com/photo-1464802686167-b939a6910659?w=800&q=80'
      ],
      category: 'Space', views: 32000, rating: 4.9,
    ),
    ExploreItem(
      id: 'p4', title: 'MedTech Neural Sync',
      subtitle: 'Real-time patient vitals monitor',
      imageUrl: 'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=800&q=80',
      imageUrls: [
        'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=800&q=80',
        'https://images.unsplash.com/photo-1530497610245-94d3c16cda28?w=800&q=80',
        'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?w=800&q=80'
      ],
      category: 'Health', views: 15400, rating: 4.7,
    ),
    ExploreItem(
      id: 'p5', title: 'HoloRetail AR',
      subtitle: 'Virtual fitting room application',
      imageUrl: 'https://images.unsplash.com/photo-1558655146-d09347e92766?w=800&q=80',
      imageUrls: [
        'https://images.unsplash.com/photo-1558655146-d09347e92766?w=800&q=80',
        'https://images.unsplash.com/photo-1531297484001-80022131f5a1?w=800&q=80',
        'https://images.unsplash.com/photo-1478760329108-5c3ed9d495a0?w=800&q=80'
      ],
      category: 'AR/VR', views: 22000, rating: 4.6,
    ),
    ExploreItem(
      id: 'p6', title: 'EcoTrack Smart Grid',
      subtitle: 'City-wide energy distribution UI',
      imageUrl: 'https://images.unsplash.com/photo-1473341304170-971dccb5ac1e?w=800&q=80',
      imageUrls: [
        'https://images.unsplash.com/photo-1473341304170-971dccb5ac1e?w=800&q=80',
        'https://images.unsplash.com/photo-1497435334941-8c899ee9e8e9?w=800&q=80',
        'https://images.unsplash.com/photo-1419242902214-272b3f66ee7a?w=800&q=80'
      ],
      category: 'Tech', views: 19800, rating: 4.8,
    ),
  ];
});

// ✅ SELECTED TAB
final selectedTabProvider = StateProvider<int>((ref) => 0);

// ✅ CATEGORY FILTER for Explore
final selectedCategoryProvider = StateProvider<String>((ref) => 'All');

// ✅ SEARCH QUERY
final searchQueryProvider = StateProvider<String>((ref) => '');

// ✅ FILTERED EXPLORE ITEMS
final filteredExploreProvider = Provider<List<ExploreItem>>((ref) {
  final items = ref.watch(exploreItemsProvider);
  final category = ref.watch(selectedCategoryProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();

  return items.where((item) {
    final matchesCategory = category == 'All' || item.category == category;
    final matchesQuery = query.isEmpty ||
        item.title.toLowerCase().contains(query) ||
        item.subtitle.toLowerCase().contains(query);
    return matchesCategory && matchesQuery;
  }).toList();
});
