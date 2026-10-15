import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../core/widgets/state_views.dart';
import '../../../l10n/app_localizations.dart';
import '../../cart/application/cart_controller.dart';
import '../../favorites/favorite_button.dart';
import '../application/catalog_providers.dart';
import '../domain/product.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({
    super.key,
    required this.productId,
    this.initial,
    this.heroPrefix = 'grid',
  });

  final int productId;

  /// The product as shown on the previous screen, so the page can render
  /// (and run its Hero animation) before the full details arrive.
  final Product? initial;
  final String heroPrefix;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(productDetailProvider(productId));
    final product = detail.value ?? initial;

    if (product == null) {
      return Scaffold(
        appBar: AppBar(),
        body: detail.hasError
            ? ErrorView(
                error: detail.error!,
                onRetry: () => ref.invalidate(productDetailProvider(productId)),
              )
            : const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: MediaQuery.sizeOf(context).width * 0.95,
            backgroundColor: context.colors.muted,
            leading: Padding(
              padding: const EdgeInsets.all(6),
              child: IconButton.filledTonal(
                style: IconButton.styleFrom(backgroundColor: context.scheme.surface),
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: FavoriteButton(product: product, size: 44),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _Gallery(product: product, heroTag: '$heroPrefix-${product.id}'),
            ),
          ),
          SliverToBoxAdapter(child: _Info(product: product, loadingDetails: detail.isLoading)),
          if (detail.hasValue) ...[
            SliverToBoxAdapter(child: _Details(product: product)),
            SliverToBoxAdapter(child: _Reviews(product: product)),
          ] else if (detail.isLoading)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Shimmer(
                  child: Column(
                    children: [
                      SkeletonBox(height: 120),
                      SizedBox(height: 16),
                      SkeletonBox(height: 90),
                    ],
                  ),
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
      bottomNavigationBar: _BuyBar(product: product),
    );
  }
}

class _Gallery extends StatefulWidget {
  const _Gallery({required this.product, required this.heroTag});

  final Product product;
  final String heroTag;

  @override
  State<_Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<_Gallery> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final images = widget.product.gallery;
    return Stack(
      children: [
        PageView.builder(
          itemCount: images.length,
          onPageChanged: (i) => setState(() => _index = i),
          itemBuilder: (context, i) {
            final image = AppNetworkImage(
              images[i],
              // The cached thumbnail fills in while the full image loads, so the
              // Hero never lands on an empty box.
              placeholderUrl: i == 0 ? widget.product.thumbnail : null,
              padding: const EdgeInsets.fromLTRB(40, 90, 40, 40),
            );
            return i == 0 ? Hero(tag: widget.heroTag, child: image) : image;
          },
        ),
        if (images.length > 1)
          Positioned(
            bottom: 18,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < images.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == _index ? 20 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: i == _index ? context.scheme.onSurface : context.colors.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Info extends StatefulWidget {
  const _Info({required this.product, required this.loadingDetails});

  final Product product;
  final bool loadingDetails;

  @override
  State<_Info> createState() => _InfoState();
}

class _InfoState extends State<_Info> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final p = widget.product;
    final locale = Localizations.localeOf(context);

    final stockText = !p.inStock
        ? l.outOfStock
        : p.stock < 10
            ? l.lowStock(p.stock)
            : l.inStockCount(p.stock);
    final stockColor = !p.inStock
        ? context.scheme.error
        : p.stock < 10
            ? context.scheme.primary
            : context.colors.success;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            categoryLabel(p.category, prettifySlug(p.category), locale).toUpperCase(),
            style: context.text.labelMedium?.copyWith(
              color: context.scheme.primary,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(p.title, style: context.text.headlineSmall),
          const SizedBox(height: 10),
          Row(
            children: [
              RatingBadge(p.rating),
              const SizedBox(width: 8),
              if (p.reviews.isNotEmpty)
                Text(
                  l.reviewCount(p.reviews.length),
                  style: context.text.bodyMedium?.copyWith(color: context.colors.inkSoft),
                ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: stockColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  stockText,
                  style: context.text.labelMedium
                      ?.copyWith(color: stockColor, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              PriceTag(
                price: p.price,
                originalPrice: p.hasDiscount ? p.originalPrice : null,
                large: true,
              ),
              const SizedBox(width: 10),
              if (p.hasDiscount) DiscountChip(p.discountPercentage),
            ],
          ),
          const SizedBox(height: 24),
          Text(l.description, style: context.text.titleMedium),
          const SizedBox(height: 8),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            alignment: Alignment.topCenter,
            child: GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Text(
                p.description,
                maxLines: _expanded ? null : 3,
                overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
                style: context.text.bodyMedium?.copyWith(color: context.colors.inkSoft, height: 1.55),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final rows = [
      if (product.brand != null) (Icons.sell_outlined, l.brand, product.brand!),
      if (product.warranty != null) (Icons.verified_user_outlined, l.warranty, product.warranty!),
      if (product.shipping != null) (Icons.local_shipping_outlined, l.shipping, product.shipping!),
      if (product.returnPolicy != null)
        (Icons.assignment_return_outlined, l.returns, product.returnPolicy!),
    ];
    if (rows.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.details, style: context.text.titleMedium),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                for (final (i, row) in rows.indexed) ...[
                  if (i > 0) const Divider(indent: 56),
                  ListTile(
                    leading: Icon(row.$1, color: context.colors.inkSoft),
                    title: Text(row.$2,
                        style: context.text.bodySmall?.copyWith(color: context.colors.inkSoft)),
                    subtitle: Text(row.$3,
                        style: context.text.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Reviews extends StatelessWidget {
  const _Reviews({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (product.reviews.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(l.reviews, trailing: RatingBadge(product.rating)),
          const SizedBox(height: 10),
          for (final r in product.reviews)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: context.colors.accentSoft,
                            child: Text(
                              r.reviewerName.isEmpty ? '?' : r.reviewerName[0],
                              style: TextStyle(
                                color: context.scheme.primary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(r.reviewerName, style: context.text.titleSmall),
                          ),
                          for (var s = 1; s <= 5; s++)
                            Icon(
                              Icons.star_rounded,
                              size: 16,
                              color: s <= r.rating ? context.colors.star : context.colors.border,
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(r.comment, style: context.text.bodyMedium),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BuyBar extends ConsumerStatefulWidget {
  const _BuyBar({required this.product});

  final Product product;

  @override
  ConsumerState<_BuyBar> createState() => _BuyBarState();
}

class _BuyBarState extends ConsumerState<_BuyBar> {
  int _quantity = 1;
  bool _justAdded = false;

  Future<void> _add() async {
    unawaited(HapticFeedback.mediumImpact());
    ref.read(cartProvider.notifier).add(widget.product, quantity: _quantity);
    setState(() => _justAdded = true);
    await Future<void>.delayed(const Duration(milliseconds: 1400));
    if (mounted) setState(() => _justAdded = false);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final p = widget.product;
    final inCart = ref.watch(cartProvider.select((c) => c.itemCount));

    return Container(
      padding: EdgeInsets.fromLTRB(20, 14, 20, 14 + MediaQuery.paddingOf(context).bottom),
      decoration: BoxDecoration(
        color: context.scheme.surface,
        border: Border(top: BorderSide(color: context.colors.border)),
      ),
      child: Row(
        children: [
          QuantityStepper(
            value: _quantity,
            max: p.stock.clamp(1, CartController.maxQuantity),
            onChanged: (v) => setState(() => _quantity = v),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: _justAdded ? context.colors.success : null,
              ),
              onPressed: p.inStock ? _add : null,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                transitionBuilder: (child, a) => FadeTransition(
                  opacity: a,
                  child: SlideTransition(
                    position: Tween(begin: const Offset(0, 0.4), end: Offset.zero).animate(a),
                    child: child,
                  ),
                ),
                child: _justAdded
                    ? Row(
                        key: const ValueKey('added'),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle_rounded, size: 20),
                          const SizedBox(width: 8),
                          Text('${l.addedToCart} · $inCart'),
                        ],
                      )
                    : Text(
                        p.inStock
                            ? '${l.addToCart} · ${context.money(p.price * _quantity)}'
                            : l.outOfStock,
                        key: const ValueKey('add'),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
