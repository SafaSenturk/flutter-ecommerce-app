import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../l10n/app_localizations.dart';
import '../../cart/application/cart_controller.dart';
import '../application/checkout_controller.dart';
import '../domain/card_validators.dart';
import 'checkout_steps.dart';
import 'credit_card_view.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  final _form = GlobalKey<FormState>();
  final _number = TextEditingController();
  final _holder = TextEditingController();
  final _expiry = TextEditingController();
  final _cvv = TextEditingController();
  final _cvvFocus = FocusNode();
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    for (final c in [_number, _holder, _expiry, _cvv]) {
      c.addListener(() => setState(() {}));
    }
    _cvvFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    for (final c in [_number, _holder, _expiry, _cvv]) {
      c.dispose();
    }
    _cvvFocus.dispose();
    super.dispose();
  }

  void _fillTestCard() {
    final now = DateTime.now();
    _number.text = CardValidators.formatNumber(CardValidators.successTestCard);
    _holder.text = 'Ayşe Yılmaz';
    _expiry.text = '${now.month.toString().padLeft(2, '0')}/${(now.year + 3) % 100}';
    _cvv.text = '123';
    FocusScope.of(context).unfocus();
  }

  Future<void> _pay() async {
    if (!_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _processing = true);
    try {
      final order = await ref.read(checkoutProvider.notifier).pay(cardNumber: _number.text);
      if (!mounted) return;
      unawaited(HapticFeedback.heavyImpact());
      context.go('/order-success/${order.id}');
    } on PaymentDeclined {
      if (!mounted) return;
      setState(() => _processing = false);
      unawaited(HapticFeedback.vibrate());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: context.scheme.error,
        content: Text(AppLocalizations.of(context).paymentDeclined),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final delivery = ref.watch(checkoutProvider.select((s) => s.delivery));
    final total = ref.watch(cartProvider.select((c) => c.summary(delivery).total));
    final brand = CardValidators.brandOf(_number.text);
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;

    return PopScope(
      canPop: !_processing,
      child: Scaffold(
        appBar: AppBar(title: Text(l.paymentTitle)),
        body: Column(
          children: [
            const CheckoutSteps(current: 1),
            Expanded(
              child: Form(
                key: _form,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    // Shrink the preview while the keyboard is open so the card
                    // and the field being typed stay on screen together.
                    AnimatedPadding(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      padding: EdgeInsets.symmetric(horizontal: keyboardOpen ? 44 : 0),
                      child: CreditCardView(
                        number: _number.text,
                        holder: _holder.text,
                        expiry: _expiry.text,
                        cvv: _cvv.text,
                        showBack: _cvvFocus.hasFocus,
                        holderPlaceholder: l.cardHolderPlaceholder,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _number,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [_CardNumberFormatter()],
                      decoration: InputDecoration(
                        labelText: l.cardNumber,
                        prefixIcon: const Icon(Icons.credit_card_rounded),
                      ),
                      validator: (v) => CardValidators.luhn(v ?? '') ? null : l.invalidCardNumber,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _holder,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: l.cardHolder,
                        prefixIcon: const Icon(Icons.person_outline_rounded),
                      ),
                      validator: (v) => (v ?? '').trim().length < 3 ? l.fieldRequired : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _expiry,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            inputFormatters: [_ExpiryFormatter()],
                            decoration: InputDecoration(
                              labelText: l.expiry,
                              prefixIcon: const Icon(Icons.event_outlined),
                            ),
                            validator: (v) => CardValidators.expiry(v ?? '') ? null : l.invalidExpiry,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _cvv,
                            focusNode: _cvvFocus,
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(brand == CardBrand.amex ? 4 : 3),
                            ],
                            decoration: InputDecoration(
                              labelText: l.cvv,
                              prefixIcon: const Icon(Icons.lock_outline_rounded),
                            ),
                            validator: (v) => CardValidators.cvv(v ?? '', brand) ? null : l.invalidCvv,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: context.colors.accentSoft,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline_rounded, color: context.scheme.primary, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l.demoPaymentNote,
                                    style: context.text.bodySmall?.copyWith(height: 1.4)),
                                const SizedBox(height: 6),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(0, 36),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: _fillTestCard,
                                  child: Text(l.fillTestCard),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: FilledButton(
              style: FilledButton.styleFrom(
                disabledBackgroundColor: context.scheme.primary.withValues(alpha: 0.75),
                disabledForegroundColor: Colors.white,
              ),
              onPressed: _processing ? null : _pay,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _processing
                    ? Row(
                        key: const ValueKey('processing'),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(l.processingPayment),
                        ],
                      )
                    : Row(
                        key: const ValueKey('pay'),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.lock_rounded, size: 18),
                          const SizedBox(width: 8),
                          Text(l.payAmount(context.money(total))),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Keeps only digits and groups them in fours.
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = CardValidators.digitsOnly(newValue.text);
    final text = CardValidators.formatNumber(digits.length > 19 ? digits.substring(0, 19) : digits);
    return TextEditingValue(text: text, selection: TextSelection.collapsed(offset: text.length));
  }
}

/// Inserts the slash in "MM/YY" automatically.
class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var digits = CardValidators.digitsOnly(newValue.text);
    if (digits.length > 4) digits = digits.substring(0, 4);
    final deleting = newValue.text.length < oldValue.text.length;
    final String text;
    if (digits.length > 2) {
      text = '${digits.substring(0, 2)}/${digits.substring(2)}';
    } else if (digits.length == 2 && !deleting) {
      text = '$digits/';
    } else {
      text = digits;
    }
    return TextEditingValue(text: text, selection: TextSelection.collapsed(offset: text.length));
  }
}
