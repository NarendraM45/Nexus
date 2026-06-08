import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../models/explore_item_model.dart';

class ExploreDetailScreen extends StatelessWidget {
  final ExploreItem item;
  const ExploreDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.darkBg,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded,
                color: AppColors.neonCyan),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'explore_card_${item.id}',
                child: CachedNetworkImage(
                  imageUrl: item.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (c, u) => Container(color: AppColors.darkCard, child: const Center(child: CircularProgressIndicator(color: AppColors.neonCyan))),
                  errorWidget: (c, u, e) => Container(
                    color: AppColors.darkBg,
                    child: const Icon(Icons.image_not_supported_rounded,
                      color: AppColors.lightSubtext),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: AppTypography.h1(Theme.of(context).colorScheme.onSurface)),
                  const SizedBox(height: 8),
                  Text(item.subtitle, style: AppTypography.bodySmall(Theme.of(context).colorScheme.onSurface)),
                  const SizedBox(height: 24),
                  // Stats row
                  Row(children: [
                    _StatChip(icon: Icons.remove_red_eye_rounded,
                      value: '${item.views ~/ 1000}K views'),
                    const SizedBox(width: 12),
                    _StatChip(icon: Icons.star_rounded,
                      value: item.rating.toString()),
                    const SizedBox(width: 12),
                    _StatChip(icon: Icons.label_rounded,
                      value: item.category),
                  ]),
                  const SizedBox(height: 32),
                  // Description paragraphs
                  Text('About this topic', style: AppTypography.h2(Theme.of(context).colorScheme.onSurface)),
                  const SizedBox(height: 12),
                  Text(
                    'Dive deep into the future of ${item.title}. '
                    'This curated collection brings you the cutting edge of '
                    'innovation from the world\'s leading researchers and creators. '
                    'Unlock exclusive insights, tutorials, and live updates.',
                    style: AppTypography.body(Theme.of(context).colorScheme.onSurface),
                  ),
                  const SizedBox(height: 32),
                  // CTA
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGrad,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        alignment: Alignment.center,
                        child: Text('Explore Now →',
                          style: AppTypography.body(Theme.of(context).colorScheme.onSurface).copyWith(
                            fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  
  const _StatChip({required this.icon, required this.value});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.neonCyan, size: 16),
          const SizedBox(width: 6),
          Text(value, style: AppTypography.label(Theme.of(context).colorScheme.onSurface).copyWith(color: AppColors.neonCyan)),
        ],
      ),
    );
  }
}
