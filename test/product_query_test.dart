import 'package:flutter_test/flutter_test.dart';
import 'package:novashop/features/catalog/domain/product.dart';
import 'package:novashop/features/catalog/domain/product_query.dart';

void main() {
  const phone = Product(
    id: 1,
    title: 'Phone',
    description: '',
    category: 'smartphones',
    price: 499,
    discountPercentage: 20,
    rating: 4.6,
    stock: 3,
    thumbnail: '',
  );

  test('price and rating filters are applied locally', () {
    expect(const ProductQuery(maxPrice: 400).matches(phone), isFalse);
    expect(const ProductQuery(minPrice: 400, maxPrice: 600).matches(phone), isTrue);
    expect(const ProductQuery(minRating: 4.5).matches(phone), isTrue);
    expect(const ProductQuery(minRating: 4.8).matches(phone), isFalse);
  });

  test('category is checked locally only while searching', () {
    // Without a search the API already filters by category.
    expect(const ProductQuery(category: 'laptops').matches(phone), isTrue);
    expect(const ProductQuery(category: 'laptops', search: 'ph').matches(phone), isFalse);
  });

  test('counts active filters and clears them but keeps the category', () {
    const q = ProductQuery(
      category: 'smartphones',
      sort: ProductSort.priceLowHigh,
      minRating: 4,
      inStockOnly: true,
    );
    expect(q.activeFilterCount, 3);
    final cleared = q.clearFilters();
    expect(cleared.activeFilterCount, 0);
    expect(cleared.category, 'smartphones');
  });

  test('original price is derived from the discount', () {
    expect(phone.originalPrice, closeTo(623.75, 0.01));
  });
}
