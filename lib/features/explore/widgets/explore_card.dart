import 'package:flutter/material.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../models/explore_item_model.dart';
import '../../../core/providers/theme_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ExploreCard extends ConsumerStatefulWidget {
  final ExploreItem item;

  const ExploreCard({super.key, required this.item});

  @override
  ConsumerState<ExploreCard> createState() => _ExploreCardState();
}

class _ExploreCardState extends ConsumerState<ExploreCard> {
  late PageController _pageController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    
    if (widget.item.imageUrls.length > 1) {
      _timer = Timer.periodic(const Duration(milliseconds: 2500), (timer) {
        if (_pageController.hasClients && mounted) {
          int next = _pageController.page!.round() + 1;
          if (next >= widget.item.imageUrls.length) next = 0;
          _pageController.animateToPage(
            next,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    final images = widget.item.imageUrls.isNotEmpty ? widget.item.imageUrls : [widget.item.imageUrl];

    return GestureDetector(
      onTap: () {
        context.push('/explore/${widget.item.id}');
      },
      child: Hero(
        tag: 'explore_card_${widget.item.id}',
        flightShuttleBuilder: (flightCtx, anim, dir, from, to) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              imageUrl: images.first,
              fit: BoxFit.cover,
              placeholder: (c, u) => Container(color: isDark ? AppColors.darkCard : AppColors.lightCard),
              errorWidget: (c, u, e) => Container(color: isDark ? AppColors.darkCard : AppColors.lightCard),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.white12 : Colors.black12,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Carousel
              Expanded(
                flex: 3,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: images.length,
                      itemBuilder: (ctx, index) {
                        return CachedNetworkImage(
                          imageUrl: images[index],
                          fit: BoxFit.cover,
                          placeholder: (ctx, url) => Container(
                            color: isDark ? AppColors.darkBg : AppColors.lightBg,
                            child: const Center(child: CircularProgressIndicator(color: AppColors.neonCyan, strokeWidth: 2)),
                          ),
                          errorWidget: (ctx, err, stack) => Container(
                            color: isDark ? AppColors.darkBg : AppColors.lightBg,
                            child: const Icon(Icons.broken_image, color: AppColors.neonCyan),
                          ),
                        );
                      },
                    ),
                    
                    // Indicators
                    if (images.length > 1)
                      Positioned(
                        bottom: 8, left: 0, right: 0,
                        child: Center(
                          child: SmoothPageIndicator(
                            controller: _pageController,
                            count: images.length,
                            effect: const ExpandingDotsEffect(
                              dotHeight: 4,
                              dotWidth: 4,
                              expansionFactor: 3,
                              activeDotColor: AppColors.neonCyan,
                              dotColor: Colors.white54,
                            ),
                          ),
                        ),
                      ),
                      
                    Positioned(
                      top: 8, right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded, color: AppColors.neonAmber, size: 14),
                            const SizedBox(width: 4),
                            Text(widget.item.rating.toString(),
                              style: AppTypography.label(Theme.of(context).colorScheme.onSurface).copyWith(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8, left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.neonCyan.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(widget.item.category,
                          style: AppTypography.label(Theme.of(context).colorScheme.onSurface).copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.title,
                        style: AppTypography.h3(Theme.of(context).colorScheme.onSurface),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.item.subtitle,
                        style: AppTypography.bodySmall(Theme.of(context).colorScheme.onSurface),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.visibility_rounded, size: 14, color: AppColors.lightSubtext),
                          const SizedBox(width: 4),
                          Text('${(widget.item.views / 1000).toStringAsFixed(1)}k',
                            style: AppTypography.label(Theme.of(context).colorScheme.onSurface).copyWith(color: AppColors.lightSubtext)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
