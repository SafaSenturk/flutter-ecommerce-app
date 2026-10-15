import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../domain/product.dart';
import '../domain/product_query.dart';

/// Talks to the DummyJSON products API.
class ProductRepository {
  ProductRepository(this._dio);

  final Dio _dio;

  static const pageSize = 20;

  Future<ProductPage> fetchPage(ProductQuery query, {int skip = 0}) async {
    final params = <String, dynamic>{
      'limit': pageSize,
      'skip': skip,
      'sortBy': query.sort.field,
      'order': query.sort.order,
    };

    final String path;
    if (query.search.trim().isNotEmpty) {
      path = '/products/search';
      params['q'] = query.search.trim();
    } else if (query.category != null) {
      path = '/products/category/${query.category}';
    } else {
      path = '/products';
    }

    return _guard(() async {
      final res = await _dio.get<Map<String, dynamic>>(path, queryParameters: params);
      final data = res.data!;
      return ProductPage(
        items: (data['products'] as List)
            .map((e) => Product.fromJson(e as Map<String, dynamic>))
            .toList(),
        total: (data['total'] as num).toInt(),
        skip: (data['skip'] as num).toInt(),
      );
    });
  }

  Future<Product> fetchProduct(int id) => _guard(() async {
        final res = await _dio.get<Map<String, dynamic>>('/products/$id');
        return Product.fromJson(res.data!);
      });

  Future<List<ProductCategory>> fetchCategories() => _guard(() async {
        final res = await _dio.get<List<dynamic>>('/products/categories');
        return res.data!
            .map((e) => ProductCategory.fromJson(e as Map<String, dynamic>))
            .toList();
      });

  Future<T> _guard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } catch (e) {
      throw AppException.from(e);
    }
  }
}

final productRepositoryProvider =
    Provider<ProductRepository>((ref) => ProductRepository(ref.watch(dioProvider)));
