import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import 'checkout_steps.dart';

class OrderSuccessScreen extends StatefulWidget {
  const OrderSuccessScreen({super.key, required this.orderId});

  final String orderId;

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen>
    with SingleTickerProviderStateMixin {
  late final _controller =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final fade = CurvedAnimation(parent: _controller, curve: const Interval(0.45, 1));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            const CheckoutSteps(current: 3),
            const Spacer(),
            SizedBox.square(
              dimension: 220,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) => CustomPaint(
                  painter: _SuccessPainter(
                    progress: _controller.value,
                    color: context.colors.success,
                    accent: context.scheme.primary,
                    star: context.colors.star,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FadeTransition(
              opacity: fade,
              child: SlideTransition(
                position: Tween(begin: const Offset(0, 0.3), end: Offset.zero).animate(fade),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      Text(l.orderSuccessTitle, style: context.text.headlineMedium),
                      const SizedBox(height: 12),
                      Text(
                        l.orderSuccessBody(widget.orderId),
                        textAlign: TextAlign.center,
                        style: context.text.bodyLarge
                            ?.copyWith(color: context.colors.inkSoft, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            FadeTransition(
              opacity: fade,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Column(
                  children: [
                    FilledButton(
                      onPressed: () => context.go('/profile/orders'),
                      child: Text(l.viewOrders),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () => context.go('/'),
                      child: Text(l.continueShopping),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Draws a growing circle, a hand-drawn check mark and a burst of confetti.
class _SuccessPainter extends CustomPainter {
  _SuccessPainter({
    required this.progress,
    required this.color,
    required this.accent,
    required this.star,
  });

  final double progress;
  final Color color;
  final Color accent;
  final Color star;

  static final _particles = List.generate(18, (i) {
    final r = Random(i * 7 + 3);
    return (angle: i / 18 * 2 * pi + r.nextDouble() * 0.3, dist: 0.75 + r.nextDouble() * 0.25,
        size: 3.0 + r.nextDouble() * 4);
  });

  double _seg(double start, double end) => ((progress - start) / (end - start)).clamp(0.0, 1.0);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width * 0.3;

    // Confetti burst.
    final burst = Curves.easeOutCubic.transform(_seg(0.25, 0.8));
    final fadeOut = 1 - _seg(0.7, 1);
    if (burst > 0) {
      final colors = [accent, star, color];
      for (final (i, p) in _particles.indexed) {
        final d = radius * (1 + burst * p.dist);
        final offset = center + Offset(cos(p.angle), sin(p.angle)) * d;
        canvas.drawCircle(
          offset,
          p.size * (1 - burst * 0.4),
          Paint()..color = colors[i % 3].withValues(alpha: fadeOut),
        );
      }
    }

    // Soft halo and filled circle.
    final grow = Curves.elasticOut.transform(_seg(0, 0.5));
    canvas.drawCircle(center, radius * 1.25 * grow, Paint()..color = color.withValues(alpha: 0.15));
    canvas.drawCircle(center, radius * grow, Paint()..color = color);

    // Check mark drawn stroke by stroke.
    final check = _seg(0.35, 0.65);
    if (check > 0) {
      final path = Path()
        ..moveTo(center.dx - radius * 0.42, center.dy + radius * 0.02)
        ..lineTo(center.dx - radius * 0.1, center.dy + radius * 0.34)
        ..lineTo(center.dx + radius * 0.46, center.dy - radius * 0.3);
      final metric = path.computeMetrics().first;
      canvas.drawPath(
        metric.extractPath(0, metric.length * check),
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = radius * 0.16
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }
  }

  @override
  bool shouldRepaint(_SuccessPainter old) => old.progress != progress;
}
