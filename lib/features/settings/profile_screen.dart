import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../cart/application/cart_controller.dart';
import '../favorites/favorites_controller.dart';
import '../orders/orders_controller.dart';
import 'settings_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider);
    final orders = ref.watch(ordersProvider).length;
    final favorites = ref.watch(favoritesProvider).length;
    final inCart = ref.watch(cartProvider.select((c) => c.itemCount));
    final currentLang = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(l.profileTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [Color(0xFF1F1F27), Color(0xFF3B3B4A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: AppTheme.accent,
                      child: Icon(Icons.person_rounded, color: Colors.white, size: 30),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.guestName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(l.guestSubtitle, style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _Stat(value: orders, label: l.statOrders),
                    _Stat(value: favorites, label: l.statFavorites),
                    _Stat(value: inCart, label: l.statInCart),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: const Icon(Icons.receipt_long_rounded),
              title: Text(l.ordersTitle, style: context.text.titleSmall),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.go('/profile/orders'),
            ),
          ),
          const SizedBox(height: 24),
          Text(l.settings, style: context.text.titleMedium),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.language, style: context.text.labelLarge),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<String>(
                      showSelectedIcon: false,
                      segments: const [
                        ButtonSegment(value: 'tr', label: Text('🇹🇷  Türkçe')),
                        ButtonSegment(value: 'en', label: Text('🇬🇧  English')),
                      ],
                      selected: {currentLang},
                      onSelectionChanged: (s) =>
                          ref.read(settingsProvider.notifier).setLocale(Locale(s.first)),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(l.theme, style: context.text.labelLarge),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<ThemeMode>(
                      showSelectedIcon: false,
                      segments: [
                        ButtonSegment(
                          value: ThemeMode.system,
                          icon: const Icon(Icons.brightness_auto_rounded),
                          label: Text(l.themeSystem),
                        ),
                        ButtonSegment(
                          value: ThemeMode.light,
                          icon: const Icon(Icons.light_mode_rounded),
                          label: Text(l.themeLight),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          icon: const Icon(Icons.dark_mode_rounded),
                          label: Text(l.themeDark),
                        ),
                      ],
                      selected: {settings.themeMode},
                      onSelectionChanged: (s) =>
                          ref.read(settingsProvider.notifier).setThemeMode(s.first),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline_rounded),
              title: Text(l.about, style: context.text.titleSmall),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => showAboutDialog(
                context: context,
                applicationName: 'NovaShop',
                applicationVersion: '1.0.0',
                applicationIcon: const CircleAvatar(
                  backgroundColor: AppTheme.accent,
                  child: Icon(Icons.shopping_bag_rounded, color: Colors.white),
                ),
                children: [
                  Text(l.aboutBody),
                  const SizedBox(height: 12),
                  Text(l.sourceCode, style: context.text.labelLarge),
                  const SelectableText('github.com/SafaSenturk/flutter-ecommerce-app'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          children: [
            TweenAnimationBuilder<int>(
              tween: IntTween(begin: 0, end: value),
              duration: const Duration(milliseconds: 600),
              builder: (_, v, _) => Text(
                '$v',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      );
}
