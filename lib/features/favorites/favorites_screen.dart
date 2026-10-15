import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/state_views.dart';
import '../../l10n/app_localizations.dart';
import '../catalog/presentation/widgets/product_card.dart';
import 'favorites_controller.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.favoritesTitle),
        actions: [
          if (favorites.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Center(child: Text(l.productCount(favorites.length))),
            ),
        ],
      ),
      body: favorites.isEmpty
          ? MessageView(
              icon: Icons.favorite_rounded,
              title: l.favoritesEmptyTitle,
              body: l.favoritesEmptyBody,
              actionLabel: l.startShopping,
              onAction: () => context.go('/'),
            )
          : GridView.builder(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.64,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, i) => ProductCard(
                key: ValueKey(favorites[i].id),
                product: favorites[i],
                heroPrefix: 'fav',
              ),
            ),
    );
  }
}
