import 'package:flutter/foundation.dart';

@immutable
class Review {
  const Review({
    required this.rating,
    required this.comment,
    required this.reviewerName,
    required this.date,
  });

  final int rating;
  final String comment;
  final String reviewerName;
  final DateTime date;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        rating: (json['rating'] as num).toInt(),
        comment: json['comment'] as String? ?? '',
        reviewerName: json['reviewerName'] as String? ?? '',
        date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime(2025),
      );
}

@immutable
class Product {
  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.thumbnail,
    this.images = const [],
    this.brand,
    this.warranty,
    this.shipping,
    this.returnPolicy,
    this.reviews = const [],
  });

  final int id;
  final String title;
  final String description;
  final String category;

  /// Final price the customer pays, in USD.
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String thumbnail;
  final List<String> images;
  final String? brand;
  final String? warranty;
  final String? shipping;
  final String? returnPolicy;
  final List<Review> reviews;

  bool get inStock => stock > 0;
  bool get hasDiscount => discountPercentage >= 1;

  /// Price before the discount, derived from the discount percentage.
  double get originalPrice => price / (1 - discountPercentage / 100);

  List<String> get gallery => images.isEmpty ? [thumbnail] : images;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: (json['id'] as num).toInt(),
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        category: json['category'] as String? ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0,
        discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0,
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
        stock: (json['stock'] as num?)?.toInt() ?? 0,
        thumbnail: json['thumbnail'] as String? ?? '',
        images: (json['images'] as List?)?.cast<String>() ?? const [],
        brand: json['brand'] as String?,
        warranty: json['warrantyInformation'] as String?,
        shipping: json['shippingInformation'] as String?,
        returnPolicy: json['returnPolicy'] as String?,
        reviews: (json['reviews'] as List?)
                ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      );

  /// Compact form used when persisting favorites and cart lines locally.
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        'price': price,
        'discountPercentage': discountPercentage,
        'rating': rating,
        'stock': stock,
        'thumbnail': thumbnail,
        'images': images,
        'brand': brand,
      };

  @override
  bool operator ==(Object other) => other is Product && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

@immutable
class ProductCategory {
  const ProductCategory({required this.slug, required this.name});

  final String slug;
  final String name;

  factory ProductCategory.fromJson(Map<String, dynamic> json) => ProductCategory(
        slug: json['slug'] as String,
        name: json['name'] as String,
      );
}

@immutable
class ProductPage {
  const ProductPage({required this.items, required this.total, required this.skip});

  final List<Product> items;
  final int total;
  final int skip;

  bool get hasMore => skip + items.length < total;
}
