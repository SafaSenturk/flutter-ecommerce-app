import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../catalog/domain/product.dart';
import 'favorites_controller.dart';

/// Heart toggle with a small "pop" when a product is saved.
class FavoriteButton extends ConsumerStatefulWidget {
  const FavoriteButton({super.key, required this.product, this.size = 36});

  final Product product;
  final double size;

  @override
  ConsumerState<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends ConsumerState<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late final _pop = AnimationController(vsync: this, duration: const Duration(milliseconds: 420));

  late final _scale = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1, end: 1.35), weight: 35),
    TweenSequenceItem(tween: Tween(begin: 1.35, end: 0.9), weight: 30),
    TweenSequenceItem(tween: Tween(begin: 0.9, end: 1), weight: 35),
  ]).animate(CurvedAnimation(parent: _pop, curve: Curves.easeOut));

  @override
  void dispose() {
    _pop.dispose();
    super.dispose();
  }

  void _toggle() {
    final wasFavorite = ref.read(isFavoriteProvider(widget.product.id));
    ref.read(favoritesProvider.notifier).toggle(widget.product);
    if (!wasFavorite) {
      HapticFeedback.lightImpact();
      _pop.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = ref.watch(isFavoriteProvider(widget.product.id));
    final color = isFavorite ? context.scheme.primary : context.scheme.onSurface;
    return Semantics(
      button: true,
      toggled: isFavorite,
      label: 'Favorite',
      child: Material(
        color: context.scheme.surface.withValues(alpha: 0.92),
        shape: const CircleBorder(),
        elevation: 0,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: _toggle,
          child: SizedBox.square(
            dimension: widget.size,
            child: ScaleTransition(
              scale: _scale,
              child: Icon(
                isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                size: widget.size * 0.52,
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
