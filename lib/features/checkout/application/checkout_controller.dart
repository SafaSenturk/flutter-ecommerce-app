import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cart/application/cart_controller.dart';
import '../../cart/domain/cart.dart';
import '../../orders/orders_controller.dart';
import '../domain/card_validators.dart';

class PaymentDeclined implements Exception {
  const PaymentDeclined();
}

@immutable
class CheckoutState {
  const CheckoutState({this.address, this.delivery = DeliveryMethod.standard});

  final ShippingAddress? address;
  final DeliveryMethod delivery;
}

class CheckoutController extends Notifier<CheckoutState> {
  @override
  CheckoutState build() => const CheckoutState();

  void setAddress(ShippingAddress address) =>
      state = CheckoutState(address: address, delivery: state.delivery);

  void setDelivery(DeliveryMethod method) =>
      state = CheckoutState(address: state.address, delivery: method);

  /// Simulates a payment gateway round trip, then records the order.
  Future<Order> pay({required String cardNumber}) async {
    await Future<void>.delayed(const Duration(milliseconds: 1800));
    final digits = CardValidators.digitsOnly(cardNumber);
    if (digits == CardValidators.declinedTestCard) throw const PaymentDeclined();

    final order = ref.read(ordersProvider.notifier).add(
          cart: ref.read(cartProvider),
          address: state.address!,
          delivery: state.delivery,
          cardLast4: digits.substring(digits.length - 4),
        );
    ref.read(cartProvider.notifier).clear();
    return order;
  }
}

final checkoutProvider =
    NotifierProvider<CheckoutController, CheckoutState>(CheckoutController.new);
