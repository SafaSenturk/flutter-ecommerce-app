import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';

/// Address → Payment → Done progress header.
class CheckoutSteps extends StatelessWidget {
  const CheckoutSteps({super.key, required this.current});

  final int current;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final labels = [l.stepAddress, l.stepPayment, l.stepDone];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++) ...[
            if (i > 0)
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: i <= current ? context.scheme.primary : context.colors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            _Dot(index: i, label: labels[i], state: i.compareTo(current)),
          ],
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.index, required this.label, required this.state});

  final int index;
  final String label;

  /// -1 done, 0 current, 1 upcoming.
  final int state;

  @override
  Widget build(BuildContext context) {
    final active = state <= 0;
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: active ? context.scheme.primary : context.colors.muted,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: state < 0
              ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
              : Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: active ? Colors.white : context.colors.inkSoft,
                  ),
                ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: context.text.labelLarge?.copyWith(
            color: active ? context.scheme.onSurface : context.colors.inkSoft,
          ),
        ),
      ],
    );
  }
}
