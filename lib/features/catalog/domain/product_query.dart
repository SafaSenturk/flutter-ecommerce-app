import 'package:flutter/foundation.dart';

import 'product.dart';

enum ProductSort {
  /// Best-rated first, so the home feed opens with products people like.
  recommended('rating', 'desc'),
  bestDeals('discountPercentage', 'desc'),
  priceLowHigh('price', 'asc'),
  priceHighLow('price', 'desc'),
  nameAZ('title', 'asc');

  const ProductSort(this.field, this.order);

  final String field;
  final String order;
}

/// Everything the user can change on the catalog screen.
///
/// Category, search and sort are sent to the API; price and rating are applied
/// on the client because DummyJSON has no such filters.
@immutable
class ProductQuery {
  const ProductQuery({
    this.category,
    this.search = '',
    this.sort = ProductSort.recommended,
    this.minPrice,
    this.maxPrice,
    this.minRating = 0,
    this.inStockOnly = false,
  });

  final String? category;
  final String search;
  final ProductSort sort;
  final double? minPrice;
  final double? maxPrice;
  final double minRating;
  final bool inStockOnly;

  static const priceCeiling = 2000.0;

  bool get hasLocalFilters =>
      minPrice != null || maxPrice != null || minRating > 0 || inStockOnly;

  int get activeFilterCount =>
      (minPrice != null || maxPrice != null ? 1 : 0) +
      (minRating > 0 ? 1 : 0) +
      (inStockOnly ? 1 : 0) +
      (sort != ProductSort.recommended ? 1 : 0);

  bool matches(Product p) {
    // The search endpoint ignores categories, so filter them here instead.
    if (search.isNotEmpty && category != null && p.category != category) return false;
    if (minPrice != null && p.price < minPrice!) return false;
    if (maxPrice != null && p.price > maxPrice!) return false;
    if (p.rating < minRating) return false;
    if (inStockOnly && !p.inStock) return false;
    return true;
  }

  ProductQuery copyWith({
    ValueGetter<String?>? category,
    String? search,
    ProductSort? sort,
    ValueGetter<double?>? minPrice,
    ValueGetter<double?>? maxPrice,
    double? minRating,
    bool? inStockOnly,
  }) =>
      ProductQuery(
        category: category != null ? category() : this.category,
        search: search ?? this.search,
        sort: sort ?? this.sort,
        minPrice: minPrice != null ? minPrice() : this.minPrice,
        maxPrice: maxPrice != null ? maxPrice() : this.maxPrice,
        minRating: minRating ?? this.minRating,
        inStockOnly: inStockOnly ?? this.inStockOnly,
      );

  ProductQuery clearFilters() => ProductQuery(category: category, search: search);

  @override
  bool operator ==(Object other) =>
      other is ProductQuery &&
      other.category == category &&
      other.search == search &&
      other.sort == sort &&
      other.minPrice == minPrice &&
      other.maxPrice == maxPrice &&
      other.minRating == minRating &&
      other.inStockOnly == inStockOnly;

  @override
  int get hashCode =>
      Object.hash(category, search, sort, minPrice, maxPrice, minRating, inStockOnly);
}
