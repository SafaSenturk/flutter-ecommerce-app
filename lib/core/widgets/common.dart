import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import 'skeleton.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage(
    this.url, {
    super.key,
    this.fit = BoxFit.contain,
    this.padding,
    this.placeholderUrl,
  });

  final String url;
  final BoxFit fit;
  final EdgeInsets? padding;

  /// A smaller, usually already cached image shown until [url] arrives.
  final String? placeholderUrl;

  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      fadeInDuration: const Duration(milliseconds: 250),
      placeholder: (_, _) => placeholderUrl != null
          ? CachedNetworkImage(imageUrl: placeholderUrl!, fit: fit)
          : const Shimmer(child: SkeletonBox(radius: 0)),
      errorWidget: (_, _, _) => Icon(
        Icons.image_not_supported_outlined,
        color: context.colors.inkSoft,
      ),
    );
    return padding == null ? image : Padding(padding: padding!, child: image);
  }
}

class RatingBadge extends StatelessWidget {
  const RatingBadge(this.rating, {super.key, this.compact = false});

  final double rating;
  final bool compact;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: compact ? 15 : 18, color: context.colors.star),
          const SizedBox(width: 3),
          Text(
            rating.toStringAsFixed(1),
            style: (compact ? context.text.labelMedium : context.text.labelLarge)
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      );
}

/// Current price, plus the crossed-out original when there is a discount.
class PriceTag extends StatelessWidget {
  const PriceTag({
    super.key,
    required this.price,
    this.originalPrice,
    this.large = false,
  });

  final double price;
  final double? originalPrice;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final style = (large ? context.text.headlineSmall : context.text.titleMedium)
        ?.copyWith(fontWeight: FontWeight.w800);
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.end,
      spacing: 6,
      children: [
        Text(context.money(price), style: style),
        if (originalPrice != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              context.money(originalPrice!),
              style: context.text.bodySmall?.copyWith(
                color: context.colors.inkSoft,
                decoration: TextDecoration.lineThrough,
                decorationColor: context.colors.inkSoft,
              ),
            ),
          ),
      ],
    );
  }
}

class DiscountChip extends StatelessWidget {
  const DiscountChip(this.percent, {super.key});

  final double percent;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: context.scheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '-${percent.round()}%',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      );
}

class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 10,
    this.dense = false,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final size = dense ? 32.0 : 44.0;
    Widget button(IconData icon, int next, bool enabled) => SizedBox(
          width: size,
          height: size,
          child: IconButton(
            padding: EdgeInsets.zero,
            iconSize: dense ? 16 : 20,
            onPressed: enabled
                ? () {
                    HapticFeedback.selectionClick();
                    onChanged(next);
                  }
                : null,
            icon: Icon(icon),
          ),
        );

    return Container(
      decoration: BoxDecoration(
        color: context.colors.muted,
        borderRadius: BorderRadius.circular(dense ? 12 : 16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          button(Icons.remove_rounded, value - 1, value > min),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            transitionBuilder: (child, a) => ScaleTransition(scale: a, child: child),
            child: SizedBox(
              key: ValueKey(value),
              width: dense ? 22 : 28,
              child: Text(
                '$value',
                textAlign: TextAlign.center,
                style: context.text.titleSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
          ),
          button(Icons.add_rounded, value + 1, value < max),
        ],
      ),
    );
  }
}

/// A tile with the product image on a soft tinted background.
class ProductImageTile extends StatelessWidget {
  const ProductImageTile({super.key, required this.url, this.size = 84, this.radius = 18});

  final String url;
  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: context.colors.muted,
          borderRadius: BorderRadius.circular(radius),
        ),
        clipBehavior: Clip.antiAlias,
        child: AppNetworkImage(url, padding: const EdgeInsets.all(8)),
      );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.trailing});

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(child: Text(text, style: context.text.titleMedium)),
          ?trailing,
        ],
      );
}
