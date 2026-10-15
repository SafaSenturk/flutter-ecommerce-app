import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novashop/core/storage/preferences.dart';
import 'package:novashop/features/cart/application/cart_controller.dart';
import 'package:novashop/features/cart/domain/cart.dart';
import 'package:novashop/features/catalog/domain/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

Product _product(int id, double price, {int stock = 50}) => Product(
      id: id,
      title: 'Product $id',
      description: '',
      category: 'beauty',
      price: price,
      discountPercentage: 0,
      rating: 4,
      stock: stock,
      thumbnail: '',
    );

Future<ProviderContainer> _container() async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final container = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('PriceSummary', () {
    test('charges standard shipping below the free threshold', () {
      final s = PriceSummary.of([CartLine(product: _product(1, 30), quantity: 2)]);
      expect(s.subtotal, 60);
      expect(s.shipping, DeliveryMethod.standard.fee);
      expect(s.total, closeTo(64.99, 0.001));
      expect(s.untilFreeShipping, 40);
    });

    test('ships for free from 100 after the coupon discount', () {
      final lines = [CartLine(product: _product(1, 110), quantity: 1)];
      expect(PriceSummary.of(lines).shipping, 0);
      // 10% off brings it to 99, so shipping is charged again.
      expect(PriceSummary.of(lines, couponPercent: 10).shipping, DeliveryMethod.standard.fee);
    });

    test('express delivery is never free', () {
      final lines = [CartLine(product: _product(1, 500), quantity: 1)];
      expect(PriceSummary.of(lines, delivery: DeliveryMethod.express).shipping,
          DeliveryMethod.express.fee);
    });

    test('an empty cart costs nothing', () {
      expect(PriceSummary.of(const []).total, 0);
    });
  });

  group('CartController', () {
    test('merges repeated adds and caps the quantity', () async {
      final c = await _container();
      final cart = c.read(cartProvider.notifier);
      final p = _product(1, 10);
      cart.add(p);
      cart.add(p, quantity: 3);
      expect(c.read(cartProvider).lines.single.quantity, 4);
      cart.add(p, quantity: 50);
      expect(c.read(cartProvider).lines.single.quantity, CartController.maxQuantity);
    });

    test('remove and restore puts the line back in place', () async {
      final c = await _container();
      final cart = c.read(cartProvider.notifier);
      cart
        ..add(_product(1, 10))
        ..add(_product(2, 20))
        ..add(_product(3, 30));
      final removed = cart.remove(2)!;
      expect(c.read(cartProvider).lines.map((l) => l.product.id), [1, 3]);
      cart.restore(removed.$1, removed.$2);
      expect(c.read(cartProvider).lines.map((l) => l.product.id), [1, 2, 3]);
    });

    test('applies only known coupons, case-insensitively', () async {
      final c = await _container();
      final cart = c.read(cartProvider.notifier);
      expect(cart.applyCoupon('nope'), isFalse);
      expect(cart.applyCoupon(' nova10 '), isTrue);
      expect(c.read(cartProvider).couponPercent, 10);
      expect(c.read(cartProvider).couponCode, 'NOVA10');
    });

    test('persists the cart between app launches', () async {
      final c = await _container();
      c.read(cartProvider.notifier).add(_product(7, 12.5), quantity: 2);

      final prefs = c.read(sharedPreferencesProvider);
      final relaunched = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(relaunched.dispose);
      final line = relaunched.read(cartProvider).lines.single;
      expect(line.product.id, 7);
      expect(line.quantity, 2);
    });
  });
}
