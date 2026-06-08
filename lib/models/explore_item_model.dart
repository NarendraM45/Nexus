class ExploreItem {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;    // ✅ always has a value (fallback Unsplash URL)
  final List<String> imageUrls;
  final String category;
  final int views;
  final double rating;

  const ExploreItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.imageUrls = const [],
    required this.category,
    required this.views,
    required this.rating,
  });
}
