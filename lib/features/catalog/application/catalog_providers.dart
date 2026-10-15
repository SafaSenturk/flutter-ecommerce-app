import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../data/product_repository.dart';
import '../domain/product.dart';
import '../domain/product_query.dart';

final categoriesProvider = FutureProvider<List<ProductCategory>>(
  (ref) => ref.watch(productRepositoryProvider).fetchCategories(),
);

final productDetailProvider = FutureProvider.autoDispose.family<Product, int>(
  (ref, id) => ref.watch(productRepositoryProvider).fetchProduct(id),
);

class ProductQueryNotifier extends Notifier<ProductQuery> {
  @override
  ProductQuery build() => const ProductQuery();

  void setCategory(String? slug) => state = state.copyWith(category: () => slug);
  void setSearch(String text) => state = state.copyWith(search: text);
  void apply(ProductQuery query) => state = query;
  void clearFilters() => state = state.clearFilters();
}

final productQueryProvider =
    NotifierProvider<ProductQueryNotifier, ProductQuery>(ProductQueryNotifier.new);

@immutable
class FeedState {
  const FeedState({
    this.items = const [],
    this.nextSkip = 0,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  final List<Product> items;
  final int nextSkip;
  final bool hasMore;
  final bool isLoadingMore;
  final AppException? loadMoreError;

  FeedState copyWith({
    List<Product>? items,
    int? nextSkip,
    bool? hasMore,
    bool? isLoadingMore,
    ValueGetter<AppException?>? loadMoreError,
  }) =>
      FeedState(
        items: items ?? this.items,
        nextSkip: nextSkip ?? this.nextSkip,
        hasMore: hasMore ?? this.hasMore,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        loadMoreError: loadMoreError != null ? loadMoreError() : this.loadMoreError,
      );
}

/// Infinite-scrolling product list for the current [ProductQuery].
class ProductFeedNotifier extends AsyncNotifier<FeedState> {
  /// Keep fetching until at least this many new items pass the local filters,
  /// so a strict price filter never leaves the user staring at an empty page.
  static const _minNewItems = 8;

  ProductRepository get _repo => ref.read(productRepositoryProvider);

  @override
  Future<FeedState> build() {
    final query = ref.watch(productQueryProvider);
    return _fill(query, const FeedState());
  }

  Future<FeedState> _fill(ProductQuery query, FeedState from) async {
    var current = from;
    var added = 0;
    do {
      final page = await _repo.fetchPage(query, skip: current.nextSkip);
      final visible = page.items.where(query.matches).toList();
      added += visible.length;
      current = current.copyWith(
        items: [...current.items, ...visible],
        nextSkip: page.skip + page.items.length,
        hasMore: page.hasMore,
      );
    } while (current.hasMore && added < _minNewItems);
    return current;
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore || state.isLoading) {
      return;
    }
    final query = ref.read(productQueryProvider);
    state = AsyncData(current.copyWith(isLoadingMore: true, loadMoreError: () => null));
    try {
      final next = await _fill(query, current);
      if (!ref.mounted || ref.read(productQueryProvider) != query) return;
      state = AsyncData(next.copyWith(isLoadingMore: false));
    } catch (e) {
      if (!ref.mounted || ref.read(productQueryProvider) != query) return;
      state = AsyncData(
        current.copyWith(isLoadingMore: false, loadMoreError: () => AppException.from(e)),
      );
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

final productFeedProvider =
    AsyncNotifierProvider<ProductFeedNotifier, FeedState>(ProductFeedNotifier.new);
