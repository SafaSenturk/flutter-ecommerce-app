import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/cart/application/cart_controller.dart';
import '../../features/cart/presentation/cart_screen.dart';
import '../../features/catalog/domain/product.dart';
import '../../features/catalog/presentation/home_screen.dart';
import '../../features/catalog/presentation/product_detail_screen.dart';
import '../../features/checkout/application/checkout_controller.dart';
import '../../features/checkout/presentation/checkout_screen.dart';
import '../../features/checkout/presentation/order_success_screen.dart';
import '../../features/checkout/presentation/payment_screen.dart';
import '../../features/favorites/favorites_screen.dart';
import '../../features/orders/orders_screen.dart';
import '../../features/settings/profile_screen.dart';
import 'main_shell.dart';

final _rootKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => MainShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/', builder: (_, _) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/favorites', builder: (_, _) => const FavoritesScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/cart', builder: (_, _) => const CartScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/profile',
              builder: (_, _) => const ProfileScreen(),
              routes: [
                GoRoute(path: 'orders', builder: (_, _) => const OrdersScreen()),
              ],
            ),
          ]),
        ],
      ),
      GoRoute(
        path: '/product/:id',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final extra = state.extra;
          final (Product? initial, String prefix) =
              extra is (Product, String) ? (extra.$1, extra.$2) : (null, 'grid');
          return ProductDetailScreen(
            productId: int.parse(state.pathParameters['id']!),
            initial: initial,
            heroPrefix: prefix,
          );
        },
      ),
      GoRoute(
        path: '/checkout',
        parentNavigatorKey: _rootKey,
        // Nothing to check out with an empty cart (e.g. after a deep link).
        redirect: (_, _) => ref.read(cartProvider).isEmpty ? '/cart' : null,
        builder: (_, _) => const CheckoutScreen(),
        routes: [
          GoRoute(
            path: 'payment',
            parentNavigatorKey: _rootKey,
            redirect: (_, _) => ref.read(checkoutProvider).address == null ? '/checkout' : null,
            builder: (_, _) => const PaymentScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/order-success/:id',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => OrderSuccessScreen(orderId: state.pathParameters['id']!),
      ),
    ],
  );
});
