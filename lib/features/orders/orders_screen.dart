import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/state_views.dart';
import '../../l10n/app_localizations.dart';
import 'orders_controller.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final orders = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.ordersTitle)),
      body: orders.isEmpty
          ? MessageView(
              icon: Icons.receipt_long_rounded,
              title: l.ordersEmptyTitle,
              body: l.ordersEmptyBody,
              actionLabel: l.startShopping,
              onAction: () => context.go('/'),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
              itemCount: orders.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, i) => _OrderCard(order: orders[i]),
            ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Card(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          shape: const RoundedRectangleBorder(),
          tilePadding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Row(
            children: [
              Text(order.id, style: context.text.titleSmall),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: context.colors.accentSoft,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  l.orderPreparing,
                  style: context.text.labelSmall?.copyWith(
                    color: context.scheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '${context.shortDate(order.createdAt)} · ${l.itemCount(order.itemCount)}',
              style: context.text.bodySmall?.copyWith(color: context.colors.inkSoft),
            ),
          ),
          trailing: Text(
            context.money(order.total),
            style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          children: [
            SizedBox(
              height: 64,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: order.lines.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (_, i) => Badge(
                  label: Text('${order.lines[i].quantity}'),
                  isLabelVisible: order.lines[i].quantity > 1,
                  child: ProductImageTile(url: order.lines[i].product.thumbnail, size: 60, radius: 14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _row(context, Icons.location_on_outlined,
                '${order.address.fullName} · ${order.address.address}, ${order.address.city}'),
            _row(context, Icons.credit_card_rounded, l.paidWithCard(order.cardLast4)),
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, IconData icon, String text) => Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Row(
          children: [
            Icon(icon, size: 18, color: context.colors.inkSoft),
            const SizedBox(width: 8),
            Expanded(child: Text(text, style: context.text.bodySmall)),
          ],
        ),
      );
}
