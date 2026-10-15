import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../l10n/app_localizations.dart';
import '../../cart/application/cart_controller.dart';
import '../../cart/domain/cart.dart';
import '../../cart/presentation/summary_card.dart';
import '../../orders/orders_controller.dart';
import '../application/checkout_controller.dart';
import 'checkout_steps.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: _saved?.fullName);
  late final _phone = TextEditingController(text: _saved?.phone);
  late final _address = TextEditingController(text: _saved?.address);
  late final _city = TextEditingController(text: _saved?.city);
  late final _zip = TextEditingController(text: _saved?.zip);

  ShippingAddress? get _saved => ref.read(checkoutProvider).address;

  @override
  void dispose() {
    for (final c in [_name, _phone, _address, _city, _zip]) {
      c.dispose();
    }
    super.dispose();
  }

  void _fillDemo() {
    _name.text = 'Ayşe Yılmaz';
    _phone.text = '0532 123 45 67';
    _address.text = 'Atatürk Cad. No: 12 D: 4';
    _city.text = 'İstanbul';
    _zip.text = '34000';
    _form.currentState?.validate();
  }

  void _continue() {
    if (!_form.currentState!.validate()) return;
    ref.read(checkoutProvider.notifier).setAddress(ShippingAddress(
          fullName: _name.text.trim(),
          phone: _phone.text.trim(),
          address: _address.text.trim(),
          city: _city.text.trim(),
          zip: _zip.text.trim(),
        ));
    context.push('/checkout/payment');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cart = ref.watch(cartProvider);
    final delivery = ref.watch(checkoutProvider.select((s) => s.delivery));
    String? required(String? v) => (v == null || v.trim().isEmpty) ? l.fieldRequired : null;

    return Scaffold(
      appBar: AppBar(title: Text(l.checkout)),
      body: Column(
        children: [
          const CheckoutSteps(current: 0),
          Expanded(
            child: Form(
              key: _form,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(l.deliveryAddress, style: context.text.titleMedium)),
                      TextButton.icon(
                        onPressed: _fillDemo,
                        icon: const Icon(Icons.auto_fix_high_rounded, size: 18),
                        label: const Text('Demo'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _name,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: l.fullName,
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                    ),
                    validator: required,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9 +]'))],
                    decoration: InputDecoration(
                      labelText: l.phone,
                      prefixIcon: const Icon(Icons.phone_outlined),
                    ),
                    validator: (v) {
                      final digits = (v ?? '').replaceAll(RegExp(r'\D'), '');
                      if (digits.isEmpty) return l.fieldRequired;
                      return digits.length < 10 || digits.length > 13 ? l.invalidPhone : null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _address,
                    textInputAction: TextInputAction.next,
                    maxLines: 2,
                    minLines: 1,
                    decoration: InputDecoration(
                      labelText: l.address,
                      prefixIcon: const Icon(Icons.home_outlined),
                    ),
                    validator: required,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: _city,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(labelText: l.city),
                          validator: required,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _zip,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          decoration: InputDecoration(labelText: l.zip),
                          validator: required,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(l.deliveryMethod, style: context.text.titleMedium),
                  const SizedBox(height: 10),
                  for (final method in DeliveryMethod.values)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _DeliveryOption(
                        method: method,
                        selected: delivery == method,
                        summary: cart.summary(method),
                        onTap: () => ref.read(checkoutProvider.notifier).setDelivery(method),
                      ),
                    ),
                  const SizedBox(height: 14),
                  Text(l.orderSummary, style: context.text.titleMedium),
                  const SizedBox(height: 10),
                  SummaryCard(summary: cart.summary(delivery), couponCode: cart.couponCode),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: FilledButton(onPressed: _continue, child: Text(l.continueToPayment)),
        ),
      ),
    );
  }
}

class _DeliveryOption extends StatelessWidget {
  const _DeliveryOption({
    required this.method,
    required this.selected,
    required this.summary,
    required this.onTap,
  });

  final DeliveryMethod method;
  final bool selected;
  final PriceSummary summary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final (title, eta, icon) = switch (method) {
      DeliveryMethod.standard =>
        (l.deliveryStandard, l.deliveryStandardEta, Icons.local_shipping_outlined),
      DeliveryMethod.express => (l.deliveryExpress, l.deliveryExpressEta, Icons.bolt_rounded),
    };
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: context.scheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selected ? context.scheme.primary : context.colors.border,
          width: selected ? 2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: selected ? context.colors.accentSoft : context.colors.muted,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: selected ? context.scheme.primary : context.colors.inkSoft),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: context.text.titleSmall),
                    Text(eta,
                        style: context.text.bodySmall?.copyWith(color: context.colors.inkSoft)),
                  ],
                ),
              ),
              Text(
                summary.shipping == 0 ? l.free : context.money(summary.shipping),
                style: context.text.titleSmall?.copyWith(
                  color: summary.shipping == 0 ? context.colors.success : null,
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                color: selected ? context.scheme.primary : context.colors.border,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
