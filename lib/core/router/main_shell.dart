import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/cart/application/cart_controller.dart';
import '../../features/favorites/favorites_controller.dart';
import '../../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

class MainShell extends ConsumerWidget {
  const MainShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final cartCount = ref.watch(cartProvider.select((c) => c.itemCount));
    final favCount = ref.watch(favoritesProvider.select((f) => f.length));

    Widget badged(IconData icon, int count, {bool selected = false}) => Badge.count(
          count: count,
          isLabelVisible: count > 0,
          backgroundColor: context.scheme.primary,
          child: Icon(icon, color: selected ? context.scheme.primary : null),
        );

    return Scaffold(
      body: shell,
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: context.colors.border)),
        ),
        child: NavigationBar(
          selectedIndex: shell.currentIndex,
          backgroundColor: context.scheme.surface,
          indicatorColor: context.colors.accentSoft,
          surfaceTintColor: Colors.transparent,
          onDestinationSelected: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore_rounded, color: context.scheme.primary),
              label: l.navHome,
            ),
            NavigationDestination(
              icon: badged(Icons.favorite_border_rounded, favCount),
              selectedIcon: badged(Icons.favorite_rounded, favCount, selected: true),
              label: l.navFavorites,
            ),
            NavigationDestination(
              icon: badged(Icons.shopping_bag_outlined, cartCount),
              selectedIcon: badged(Icons.shopping_bag_rounded, cartCount, selected: true),
              label: l.navCart,
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded, color: context.scheme.primary),
              label: l.navProfile,
            ),
          ],
        ),
      ),
    );
  }
}
