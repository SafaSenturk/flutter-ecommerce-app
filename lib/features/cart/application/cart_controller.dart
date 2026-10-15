import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/preferences.dart';
import '../../catalog/domain/product.dart';
import '../domain/cart.dart';

class CartController extends Notifier<CartState> {
  static const _key = 'cart.v1';
  static const maxQuantity = 10;

  /// Demo coupon codes and their percentage discounts.
  static const coupons = {'NOVA10': 10, 'FLUTTER20': 20};

  @override
  CartState build() {
    final raw = ref.read(sharedPreferencesProvider).getString(_key);
    if (raw == null) return const CartState();
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return CartState(
        lines: (json['lines'] as List)
            .map((e) => CartLine.fromJson(e as Map<String, dynamic>))
            .toList(),
        couponCode: json['couponCode'] as String?,
        couponPercent: (json['couponPercent'] as num?)?.toInt() ?? 0,
      );
    } catch (_) {
      return const CartState();
    }
  }

  void add(Product product, {int quantity = 1}) {
    final index = state.lines.indexWhere((l) => l.product.id == product.id);
    final lines = [...state.lines];
    if (index == -1) {
      lines.add(CartLine(product: product, quantity: quantity.clamp(1, maxQuantity)));
    } else {
      final q = (lines[index].quantity + quantity).clamp(1, maxQuantity);
      lines[index] = lines[index].copyWith(quantity: q);
    }
    _set(state.copyWith(lines: lines));
  }

  void setQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      remove(productId);
      return;
    }
    _set(state.copyWith(
      lines: [
        for (final l in state.lines)
          l.product.id == productId ? l.copyWith(quantity: quantity.clamp(1, maxQuantity)) : l,
      ],
    ));
  }

  /// Removes a line and returns it with its position, so the UI can undo.
  (CartLine, int)? remove(int productId) {
    final index = state.lines.indexWhere((l) => l.product.id == productId);
    if (index == -1) return null;
    final removed = state.lines[index];
    _set(state.copyWith(lines: [...state.lines]..removeAt(index)));
    return (removed, index);
  }

  void restore(CartLine line, int index) {
    final lines = [...state.lines];
    lines.insert(index.clamp(0, lines.length), line);
    _set(state.copyWith(lines: lines));
  }

  /// Returns true when the code is valid and has been applied.
  bool applyCoupon(String code) {
    final normalized = code.trim().toUpperCase();
    final percent = coupons[normalized];
    if (percent == null) return false;
    _set(state.copyWith(couponCode: () => normalized, couponPercent: percent));
    return true;
  }

  void removeCoupon() => _set(state.copyWith(couponCode: () => null, couponPercent: 0));

  void clear() => _set(const CartState());

  void _set(CartState next) {
    state = next;
    ref.read(sharedPreferencesProvider).setString(
          _key,
          jsonEncode({
            'lines': next.lines.map((l) => l.toJson()).toList(),
            'couponCode': next.couponCode,
            'couponPercent': next.couponPercent,
          }),
        );
  }
}

final cartProvider = NotifierProvider<CartController, CartState>(CartController.new);
