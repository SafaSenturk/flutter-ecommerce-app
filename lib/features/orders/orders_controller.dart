import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/preferences.dart';
import '../cart/domain/cart.dart';

@immutable
class ShippingAddress {
  const ShippingAddress({
    required this.fullName,
    required this.phone,
    required this.address,
    required this.city,
    required this.zip,
  });

  final String fullName;
  final String phone;
  final String address;
  final String city;
  final String zip;

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'phone': phone,
        'address': address,
        'city': city,
        'zip': zip,
      };

  factory ShippingAddress.fromJson(Map<String, dynamic> j) => ShippingAddress(
        fullName: j['fullName'] as String,
        phone: j['phone'] as String,
        address: j['address'] as String,
        city: j['city'] as String,
        zip: j['zip'] as String,
      );
}

@immutable
class Order {
  const Order({
    required this.id,
    required this.createdAt,
    required this.lines,
    required this.subtotal,
    required this.discount,
    required this.shipping,
    required this.total,
    required this.address,
    required this.delivery,
    required this.cardLast4,
  });

  final String id;
  final DateTime createdAt;
  final List<CartLine> lines;
  final double subtotal;
  final double discount;
  final double shipping;
  final double total;
  final ShippingAddress address;
  final DeliveryMethod delivery;
  final String cardLast4;

  int get itemCount => lines.fold(0, (s, l) => s + l.quantity);

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'lines': lines.map((l) => l.toJson()).toList(),
        'subtotal': subtotal,
        'discount': discount,
        'shipping': shipping,
        'total': total,
        'address': address.toJson(),
        'delivery': delivery.name,
        'cardLast4': cardLast4,
      };

  factory Order.fromJson(Map<String, dynamic> j) => Order(
        id: j['id'] as String,
        createdAt: DateTime.parse(j['createdAt'] as String),
        lines: (j['lines'] as List)
            .map((e) => CartLine.fromJson(e as Map<String, dynamic>))
            .toList(),
        subtotal: (j['subtotal'] as num).toDouble(),
        discount: (j['discount'] as num).toDouble(),
        shipping: (j['shipping'] as num).toDouble(),
        total: (j['total'] as num).toDouble(),
        address: ShippingAddress.fromJson(j['address'] as Map<String, dynamic>),
        delivery: DeliveryMethod.values.byName(j['delivery'] as String),
        cardLast4: j['cardLast4'] as String,
      );
}

class OrdersController extends Notifier<List<Order>> {
  static const _key = 'orders.v1';

  @override
  List<Order> build() {
    final raw = ref.read(sharedPreferencesProvider).getString(_key);
    if (raw == null) return const [];
    try {
      return (jsonDecode(raw) as List)
          .map((e) => Order.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Order add({
    required CartState cart,
    required ShippingAddress address,
    required DeliveryMethod delivery,
    required String cardLast4,
  }) {
    final summary = cart.summary(delivery);
    final order = Order(
      id: 'NS-${100000 + Random().nextInt(899999)}',
      createdAt: DateTime.now(),
      lines: cart.lines,
      subtotal: summary.subtotal,
      discount: summary.discount,
      shipping: summary.shipping,
      total: summary.total,
      address: address,
      delivery: delivery,
      cardLast4: cardLast4,
    );
    state = [order, ...state];
    ref
        .read(sharedPreferencesProvider)
        .setString(_key, jsonEncode(state.map((o) => o.toJson()).toList()));
    return order;
  }
}

final ordersProvider = NotifierProvider<OrdersController, List<Order>>(OrdersController.new);
