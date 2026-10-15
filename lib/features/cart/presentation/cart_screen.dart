import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/state_views.dart';
import '../../../l10n/app_localizations.dart';
import '../application/cart_controller.dart';
import '../domain/cart.dart';
import 'summary_card.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final cart = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.cartTitle),
        actions: [
          if (!cart.isEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Center(child: Text(l.itemCount(cart.itemCount))),
            ),
        ],
      ),
      body: cart.isEmpty
          ? MessageView(
              icon: Icons.shopping_bag_outlined,
              title: l.cartEmptyTitle,
              body: l.cartEmptyBody,
              actionLabel: l.startShopping,
              onAction: () => context.go('/'),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                _FreeShippingBar(summary: cart.summary()),
                const SizedBox(height: 14),
                for (final line in cart.lines)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _CartLineTile(key: ValueKey(line.product.id), line: line),
                  ),
                const SizedBox(height: 6),
                const _CouponField(),
                const SizedBox(height: 16),
                SummaryCard(summary: cart.summary(), couponCode: cart.couponCode),
              ],
            ),
      bottomNavigationBar: cart.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: FilledButton(
                onPressed: () => context.push('/checkout'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l.checkout),
                    const SizedBox(width: 8),
                    Text('· ${context.money(cart.summary().total)}'),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward_rounded, size: 20),
                  ],
                ),
              ),
            ),
    );
  }
}

class _FreeShippingBar extends StatelessWidget {
  const _FreeShippingBar({required this.summary});

  final PriceSummary summary;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final remaining = summary.untilFreeShipping;
    final progress = 1 - remaining / PriceSummary.freeShippingThreshold;
    final done = remaining <= 0;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: done ? context.colors.success.withValues(alpha: 0.12) : context.colors.accentSoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                done ? Icons.celebration_rounded : Icons.local_shipping_rounded,
                size: 20,
                color: done ? context.colors.success : context.scheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  done ? l.freeShippingUnlocked : l.freeShippingProgress(context.money(remaining)),
                  style: context.text.labelLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: progress.clamp(0, 1)),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
              builder: (context, v, _) => LinearProgressIndicator(
                value: v,
                minHeight: 6,
                backgroundColor: context.scheme.surface,
                color: done ? context.colors.success : context.scheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartLineTile extends ConsumerWidget {
  const _CartLineTile({super.key, required this.line});

  final CartLine line;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final p = line.product;
    final cart = ref.read(cartProvider.notifier);

    void remove() {
      final removed = cart.remove(p.id);
      if (removed == null) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          persist: false,
          content: Text(l.removedFromCart(p.title)),
          action: SnackBarAction(
            label: l.undo,
            onPressed: () => cart.restore(removed.$1, removed.$2),
          ),
        ));
    }

    return Dismissible(
      key: ValueKey('dismiss-${p.id}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => remove(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: context.scheme.error,
          borderRadius: BorderRadius.circular(AppTheme.radius),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.radius),
          onTap: () => context.push('/product/${p.id}', extra: (p, 'cart')),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Hero(tag: 'cart-${p.id}', child: ProductImageTile(url: p.thumbnail, size: 88)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.text.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        context.money(p.price),
                        style: context.text.bodySmall?.copyWith(color: context.colors.inkSoft),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          QuantityStepper(
                            dense: true,
                            min: 0,
                            value: line.quantity,
                            max: p.stock.clamp(1, CartController.maxQuantity),
                            onChanged: (q) => q == 0 ? remove() : cart.setQuantity(p.id, q),
                          ),
                          const Spacer(),
                          Text(
                            context.money(line.lineTotal),
                            style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CouponField extends ConsumerStatefulWidget {
  const _CouponField();

  @override
  ConsumerState<_CouponField> createState() => _CouponFieldState();
}

class _CouponFieldState extends ConsumerState<_CouponField> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _apply() {
    final l = AppLocalizations.of(context);
    final ok = ref.read(cartProvider.notifier).applyCoupon(_controller.text);
    setState(() => _error = ok ? null : l.couponInvalid);
    if (ok) {
      _controller.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cart = ref.watch(cartProvider);

    if (cart.couponCode != null) {
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 6, 6, 6),
        decoration: BoxDecoration(
          color: context.colors.success.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(Icons.confirmation_number_rounded, color: context.colors.success),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                l.couponApplied(cart.couponCode!, cart.couponPercent),
                style: context.text.labelLarge,
              ),
            ),
            IconButton(
              onPressed: () => ref.read(cartProvider.notifier).removeCoupon(),
              icon: const Icon(Icons.close_rounded),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                textCapitalization: TextCapitalization.characters,
                onSubmitted: (_) => _apply(),
                decoration: InputDecoration(
                  hintText: l.couponHint,
                  prefixIcon: const Icon(Icons.confirmation_number_outlined),
                  errorText: _error,
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 56,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: const Size(90, 56),
                  backgroundColor: context.scheme.onSurface,
                  foregroundColor: context.scheme.surface,
                ),
                onPressed: _apply,
                child: Text(l.apply),
              ),
            ),
          ],
        ),
        if (_error == null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              l.couponTip,
              style: context.text.bodySmall?.copyWith(color: context.colors.inkSoft),
            ),
          ),
      ],
    );
  }
}
