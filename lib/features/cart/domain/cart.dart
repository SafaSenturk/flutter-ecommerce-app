import 'package:flutter/foundation.dart';

import '../../catalog/domain/product.dart';

@immutable
class CartLine {
  const CartLine({required this.product, required this.quantity});

  final Product product;
  final int quantity;

  double get lineTotal => product.price * quantity;

  CartLine copyWith({int? quantity}) =>
      CartLine(product: product, quantity: quantity ?? this.quantity);

  Map<String, dynamic> toJson() => {'product': product.toJson(), 'quantity': quantity};

  factory CartLine.fromJson(Map<String, dynamic> json) => CartLine(
        product: Product.fromJson(json['product'] as Map<String, dynamic>),
        quantity: (json['quantity'] as num).toInt(),
      );
}

enum DeliveryMethod {
  standard(4.99),
  express(12.99);

  const DeliveryMethod(this.fee);

  final double fee;
}

/// All money maths for the cart, kept free of Flutter so it is easy to test.
@immutable
class PriceSummary {
  const PriceSummary({
    required this.subtotal,
    required this.discount,
    required this.shipping,
  });

  static const freeShippingThreshold = 100.0;

  factory PriceSummary.of(
    List<CartLine> lines, {
    int couponPercent = 0,
    DeliveryMethod delivery = DeliveryMethod.standard,
  }) {
    final subtotal = lines.fold<double>(0, (sum, l) => sum + l.lineTotal);
    final discount = _round(subtotal * couponPercent / 100);
    final afterDiscount = subtotal - discount;
    final double shipping;
    if (lines.isEmpty) {
      shipping = 0;
    } else if (delivery == DeliveryMethod.standard && afterDiscount >= freeShippingThreshold) {
      shipping = 0;
    } else {
      shipping = delivery.fee;
    }
    return PriceSummary(subtotal: _round(subtotal), discount: discount, shipping: shipping);
  }

  final double subtotal;
  final double discount;
  final double shipping;

  double get total => _round(subtotal - discount + shipping);

  /// How much more the customer needs to spend for free standard shipping.
  double get untilFreeShipping =>
      (freeShippingThreshold - (subtotal - discount)).clamp(0, freeShippingThreshold);

  static double _round(double v) => (v * 100).roundToDouble() / 100;
}

@immutable
class CartState {
  const CartState({this.lines = const [], this.couponCode, this.couponPercent = 0});

  final List<CartLine> lines;
  final String? couponCode;
  final int couponPercent;

  int get itemCount => lines.fold(0, (sum, l) => sum + l.quantity);
  bool get isEmpty => lines.isEmpty;

  PriceSummary summary([DeliveryMethod delivery = DeliveryMethod.standard]) =>
      PriceSummary.of(lines, couponPercent: couponPercent, delivery: delivery);

  int quantityOf(int productId) =>
      lines.where((l) => l.product.id == productId).fold(0, (s, l) => s + l.quantity);

  CartState copyWith({
    List<CartLine>? lines,
    ValueGetter<String?>? couponCode,
    int? couponPercent,
  }) =>
      CartState(
        lines: lines ?? this.lines,
        couponCode: couponCode != null ? couponCode() : this.couponCode,
        couponPercent: couponPercent ?? this.couponPercent,
      );
}
