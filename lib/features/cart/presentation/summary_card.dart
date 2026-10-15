import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/cart.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key, required this.summary, this.couponCode});

  final PriceSummary summary;
  final String? couponCode;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    Widget row(String label, String value, {Color? color, bool bold = false}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: bold
                      ? context.text.titleMedium
                      : context.text.bodyMedium?.copyWith(color: context.colors.inkSoft),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  value,
                  key: ValueKey(value),
                  style: (bold ? context.text.titleLarge : context.text.bodyLarge)
                      ?.copyWith(fontWeight: bold ? FontWeight.w800 : FontWeight.w600, color: color),
                ),
              ),
            ],
          ),
        );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            row(l.subtotal, context.money(summary.subtotal)),
            if (summary.discount > 0)
              row(
                couponCode == null ? l.discount : '${l.discount} ($couponCode)',
                '−${context.money(summary.discount)}',
                color: context.colors.success,
              ),
            row(
              l.shippingFee,
              summary.shipping == 0 ? l.free : context.money(summary.shipping),
              color: summary.shipping == 0 ? context.colors.success : null,
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider()),
            row(l.total, context.money(summary.total), bold: true),
          ],
        ),
      ),
    );
  }
}
