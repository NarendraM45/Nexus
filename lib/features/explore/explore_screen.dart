import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/providers/app_providers.dart';
import '../../core/providers/theme_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/explore_item_model.dart';
import '../../shared/widgets/custom/safe_lottie.dart';
import 'widgets/explore_card.dart';
import '../../shared/widgets/lottie_hamburger.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  static const _categories = [
    'All', 'Trending', 'Fintech', 'Logistics', 'Space', 'Health', 'AR/VR', 'Tech',
  ];

  @override
  void initState() {
    super.initState();
    // ✅ Connect controller to provider
    _searchCtrl.addListener(() {
      ref.read(searchQueryProvider.notifier).state = _searchCtrl.text;
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchFocus.dispose();
    // ✅ Clear search when leaving screen
    Future.microtask(() =>
      ref.read(searchQueryProvider.notifier).state = '');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(filteredExploreProvider);       // ✅ Filtered list
    final selectedCat = ref.watch(selectedCategoryProvider);
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        leading: const LottieHamburger(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ✅ WORKING SEARCH BAR
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _searchFocus.hasFocus
                        ? AppColors.neonCyan
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: TextField(
                  controller: _searchCtrl,   // ✅ connected controller
                  focusNode: _searchFocus,
                  style: AppTypography.body(Theme.of(context).colorScheme.onSurface),
                  decoration: InputDecoration(
                    hintText: 'Search topics, tags...',
                    hintStyle: AppTypography.body(Theme.of(context).colorScheme.onSurface).copyWith(color: AppColors.lightSubtext),
                    prefixIcon: const Icon(Icons.search_rounded,
                      color: AppColors.neonCyan),
                    suffixIcon: _searchCtrl.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.close_rounded, color: isDark ? Colors.white70 : Colors.black54),
                            onPressed: () {
                              _searchCtrl.clear();
                              ref.read(searchQueryProvider.notifier).state = '';
                              _searchFocus.unfocus();
                              setState(() {});
                            })
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  ),
                  onChanged: (val) {
                    ref.read(searchQueryProvider.notifier).state = val;
                    if (val.isEmpty) {
                      _searchFocus.unfocus();
                    }
                    setState(() {});
                  },
                ),
              ),
            ),

            // Category chips
            SizedBox(
              height: 56,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (ctx, i) {
                  final cat = _categories[i];
                  final isSelected = cat == selectedCat;
                  return GestureDetector(
                    onTap: () {
                      ref.read(selectedCategoryProvider.notifier).state = cat;
                      HapticFeedback.selectionClick();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: isSelected ? AppColors.primaryGrad : null,
                        color: isSelected ? null
                            : (isDark ? AppColors.darkCard : AppColors.lightCard),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : AppColors.neonCyan.withValues(alpha: 0.3)),
                      ),
                      child: Text(cat,
                        style: AppTypography.label(Theme.of(context).colorScheme.onSurface).copyWith(
                          color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87))),
                    ),
                  );
                },
              ),
            ),

            // Results or empty state
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ✅ Lottie empty state
                          const SafeLottie(
                            assetPath: 'assets/lottie/empty_box.json',
                            width: 160, height: 160,
                            fallback: Icon(
                              Icons.search_off_rounded, size: 64,
                              color: AppColors.neonCyan),
                          ),
                          const SizedBox(height: 16),
                          Text('Nothing found',
                            style: AppTypography.h2(Theme.of(context).colorScheme.onSurface)),
                          const SizedBox(height: 8),
                          Text('Try different keywords or filters',
                            style: AppTypography.bodySmall(Theme.of(context).colorScheme.onSurface)),
                        ],
                      ),
                    )
                  : CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: _FeaturedCarousel(items: items),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                          sliver: SliverGrid(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.72,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (ctx, i) => ExploreCard(item: items[i])
                                .animate(delay: Duration(milliseconds: 60 * i))
                                .fadeIn().slideY(begin: 0.2),
                              childCount: items.length,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedCarousel extends ConsumerStatefulWidget {
  final List<ExploreItem> items;
  const _FeaturedCarousel({required this.items});

  @override
  ConsumerState<_FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends ConsumerState<_FeaturedCarousel> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();
    final featured = widget.items.take(4).toList();

    return Column(
      children: [
        const SizedBox(height: 12),
        CarouselSlider.builder(
          itemCount: featured.length,
          options: CarouselOptions(
            height: 200,
            viewportFraction: 0.88,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            onPageChanged: (index, reason) => setState(() => _current = index),
          ),
          itemBuilder: (ctx, i, realI) {
            final item = featured[i];
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: CachedNetworkImage(
                      imageUrl: item.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (ctx, url) => Container(color: AppColors.darkCard),
                      errorWidget: (ctx, err, stack) => Container(color: AppColors.darkCard, child: const Icon(Icons.broken_image)),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        colors: [Colors.black.withValues(alpha: 0.9), Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        AnimatedSmoothIndicator(
          activeIndex: _current,
          count: featured.length,
          effect: const ExpandingDotsEffect(
            dotHeight: 6,
            dotWidth: 6,
            expansionFactor: 3,
            activeDotColor: AppColors.neonCyan,
            dotColor: Colors.grey,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
