import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../cart/application/cart_controller.dart';
import '../../../favorites/favorite_button.dart';
import '../../domain/product.dart';

class ProductCard extends ConsumerWidget {
  const ProductCard({super.key, required this.product, this.heroPrefix = 'grid'});

  final Product product;
  final String heroPrefix;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/product/${product.id}', extra: (product, heroPrefix)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: context.colors.muted,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Hero(
                        tag: '$heroPrefix-${product.id}',
                        child: AppNetworkImage(
                          product.thumbnail,
                          padding: const EdgeInsets.all(12),
                        ),
                      ),
                    ),
                  ),
                  if (product.hasDiscount)
                    Positioned(left: 16, top: 16, child: DiscountChip(product.discountPercentage)),
                  Positioned(right: 14, top: 14, child: FavoriteButton(product: product, size: 34)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 2, 8, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      RatingBadge(product.rating, compact: true),
                      if (!product.inStock) ...[
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            l.outOfStock,
                            overflow: TextOverflow.ellipsis,
                            style: context.text.labelSmall?.copyWith(color: context.scheme.error),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(child: PriceTag(price: product.price)),
                      _QuickAddButton(product: product),
                    ],
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

class _QuickAddButton extends ConsumerWidget {
  const _QuickAddButton({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final inCart = ref.watch(cartProvider.select((c) => c.quantityOf(product.id)));
    return SizedBox.square(
      dimension: 36,
      child: IconButton.filled(
        tooltip: l.addToCart,
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          backgroundColor: inCart > 0 ? context.scheme.primary : context.scheme.onSurface,
          foregroundColor: inCart > 0 ? Colors.white : context.scheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: product.inStock
            ? () {
                HapticFeedback.lightImpact();
                ref.read(cartProvider.notifier).add(product);
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    persist: false,
                    content: Text(l.addedToCart),
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(label: l.view, onPressed: () => context.go('/cart')),
                  ));
              }
            : null,
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: inCart > 0
              ? Text('$inCart',
                  key: ValueKey(inCart),
                  style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white))
              : const Icon(Icons.add_rounded, size: 20),
        ),
      ),
    );
  }
}

class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) => const Card(
        child: Shimmer(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: SkeletonBox(radius: 16)),
                SizedBox(height: 12),
                SkeletonBox(height: 14, width: 120),
                SizedBox(height: 8),
                SkeletonBox(height: 12, width: 50),
                SizedBox(height: 10),
                SkeletonBox(height: 18, width: 70),
                SizedBox(height: 6),
              ],
            ),
          ),
        ),
      );
}
