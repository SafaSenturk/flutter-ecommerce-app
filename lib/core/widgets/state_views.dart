import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../network/api_client.dart';
import '../theme/app_theme.dart';

String errorMessage(BuildContext context, Object error) {
  final l = AppLocalizations.of(context);
  final type = error is AppException ? error.type : AppErrorType.unknown;
  return switch (type) {
    AppErrorType.network => l.errorNetwork,
    AppErrorType.timeout => l.errorTimeout,
    AppErrorType.server => l.errorServer,
    AppErrorType.unknown => l.errorUnknown,
  };
}

/// Centered illustration + text + optional action, used for empty and error states.
class MessageView extends StatelessWidget {
  const MessageView({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.actionLabel,
    this.onAction,
    this.tone,
  });

  final IconData icon;
  final String title;
  final String body;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? tone;

  @override
  Widget build(BuildContext context) {
    final color = tone ?? context.scheme.primary;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOutBack,
          builder: (context, t, child) => Opacity(
            opacity: t.clamp(0, 1),
            child: Transform.scale(scale: 0.9 + 0.1 * t, child: child),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 44, color: color),
              ),
              const SizedBox(height: 22),
              Text(title, style: context.text.titleLarge, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                body,
                textAlign: TextAlign.center,
                style: context.text.bodyMedium?.copyWith(color: context.colors.inkSoft, height: 1.45),
              ),
              if (actionLabel != null) ...[
                const SizedBox(height: 24),
                SizedBox(
                  width: 220,
                  child: FilledButton(onPressed: onAction, child: Text(actionLabel!)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final offline = error is AppException && (error as AppException).type == AppErrorType.network;
    return MessageView(
      icon: offline ? Icons.wifi_off_rounded : Icons.cloud_off_rounded,
      title: l.errorTitle,
      body: errorMessage(context, error),
      actionLabel: l.retry,
      onAction: onRetry,
      tone: context.scheme.error,
    );
  }
}
