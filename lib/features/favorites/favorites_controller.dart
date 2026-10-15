import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/preferences.dart';
import '../catalog/domain/product.dart';

/// Saved products, newest first. Whole products are stored so the list
/// still renders offline.
class FavoritesController extends Notifier<List<Product>> {
  static const _key = 'favorites.v1';

  @override
  List<Product> build() {
    final raw = ref.read(sharedPreferencesProvider).getStringList(_key) ?? const [];
    return [for (final s in raw) ?_tryParse(s)];
  }

  bool isFavorite(int id) => state.any((p) => p.id == id);

  void toggle(Product product) {
    final next = isFavorite(product.id)
        ? state.where((p) => p.id != product.id).toList()
        : [product, ...state];
    state = next;
    ref
        .read(sharedPreferencesProvider)
        .setStringList(_key, next.map((p) => jsonEncode(p.toJson())).toList());
  }

  static Product? _tryParse(String s) {
    try {
      return Product.fromJson(jsonDecode(s) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }
}

final favoritesProvider =
    NotifierProvider<FavoritesController, List<Product>>(FavoritesController.new);

/// Lets a single heart icon rebuild without listening to the whole list.
final isFavoriteProvider = Provider.family<bool, int>(
  (ref, id) => ref.watch(favoritesProvider.select((list) => list.any((p) => p.id == id))),
);
