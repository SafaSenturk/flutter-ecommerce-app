// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'NovaShop';

  @override
  String get navHome => 'Discover';

  @override
  String get navFavorites => 'Favorites';

  @override
  String get navCart => 'Cart';

  @override
  String get navProfile => 'Profile';

  @override
  String get homeHello => 'Hello there';

  @override
  String get homeHeadline => 'Find something\nyou\'ll love';

  @override
  String get searchHint => 'Search products, brands…';

  @override
  String get categoryAll => 'All';

  @override
  String get filters => 'Filters';

  @override
  String get sortBy => 'Sort by';

  @override
  String get sortRecommended => 'Recommended';

  @override
  String get sortPriceLowHigh => 'Price: low to high';

  @override
  String get sortPriceHighLow => 'Price: high to low';

  @override
  String get sortBestDeals => 'Biggest discounts';

  @override
  String get sortNameAZ => 'Name (A–Z)';

  @override
  String get priceRange => 'Price range';

  @override
  String get minRating => 'Minimum rating';

  @override
  String get anyRating => 'Any';

  @override
  String ratingAndUp(String rating) {
    return '$rating+';
  }

  @override
  String get inStockOnly => 'In stock only';

  @override
  String get showResults => 'Show results';

  @override
  String get reset => 'Reset';

  @override
  String productCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count products',
      one: '1 product',
      zero: 'No products',
    );
    return '$_temp0';
  }

  @override
  String productCountMore(int count) {
    return '$count+ products';
  }

  @override
  String get promo1Title => 'Up to 40% off';

  @override
  String get promo1Subtitle => 'Beauty & fragrance week';

  @override
  String get promo2Title => 'Free shipping';

  @override
  String get promo2Subtitle => 'On every order over \$100';

  @override
  String get promo3Title => 'New tech drops';

  @override
  String get promo3Subtitle => 'Phones, laptops & more';

  @override
  String get shopNow => 'Shop now';

  @override
  String get popularNow => 'Popular right now';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get errorNetwork =>
      'You seem to be offline. Check your connection and try again.';

  @override
  String get errorTimeout =>
      'The server took too long to answer. Please try again.';

  @override
  String get errorServer =>
      'The store is not responding right now. Please try again in a moment.';

  @override
  String get errorUnknown => 'An unexpected error occurred.';

  @override
  String get retry => 'Try again';

  @override
  String get noResultsTitle => 'No products found';

  @override
  String get noResultsBody => 'Try another search or loosen your filters.';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get addToCart => 'Add to cart';

  @override
  String get addedToCart => 'Added to your cart';

  @override
  String get view => 'View';

  @override
  String get outOfStock => 'Out of stock';

  @override
  String inStockCount(int count) {
    return 'In stock · $count';
  }

  @override
  String lowStock(int count) {
    return 'Only $count left';
  }

  @override
  String get description => 'Description';

  @override
  String get reviews => 'Reviews';

  @override
  String reviewCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews',
      one: '1 review',
      zero: 'No reviews',
    );
    return '$_temp0';
  }

  @override
  String get details => 'Details';

  @override
  String get brand => 'Brand';

  @override
  String get warranty => 'Warranty';

  @override
  String get shipping => 'Shipping';

  @override
  String get returns => 'Returns';

  @override
  String get quantity => 'Quantity';

  @override
  String get favoritesTitle => 'Favorites';

  @override
  String get favoritesEmptyTitle => 'No favorites yet';

  @override
  String get favoritesEmptyBody =>
      'Tap the heart on any product to keep it here for later.';

  @override
  String get cartTitle => 'My cart';

  @override
  String get cartEmptyTitle => 'Your cart is empty';

  @override
  String get cartEmptyBody => 'Looks like you haven\'t added anything yet.';

  @override
  String get startShopping => 'Start shopping';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get discount => 'Discount';

  @override
  String get shippingFee => 'Shipping';

  @override
  String get free => 'Free';

  @override
  String get total => 'Total';

  @override
  String get couponHint => 'Coupon code';

  @override
  String get apply => 'Apply';

  @override
  String couponApplied(String code, int percent) {
    return '$code applied · $percent% off';
  }

  @override
  String get couponInvalid => 'That coupon code isn\'t valid';

  @override
  String get couponTip => 'Tip: try NOVA10 or FLUTTER20';

  @override
  String freeShippingProgress(String amount) {
    return 'Add $amount more for free shipping';
  }

  @override
  String get freeShippingUnlocked => 'You\'ve unlocked free shipping';

  @override
  String get checkout => 'Checkout';

  @override
  String removedFromCart(String name) {
    return '$name removed';
  }

  @override
  String get undo => 'Undo';

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get stepAddress => 'Address';

  @override
  String get stepPayment => 'Payment';

  @override
  String get stepDone => 'Done';

  @override
  String get deliveryAddress => 'Delivery address';

  @override
  String get fullName => 'Full name';

  @override
  String get phone => 'Phone';

  @override
  String get address => 'Street address';

  @override
  String get city => 'City';

  @override
  String get zip => 'Postal code';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get invalidPhone => 'Enter a valid phone number';

  @override
  String get deliveryMethod => 'Delivery method';

  @override
  String get deliveryStandard => 'Standard';

  @override
  String get deliveryStandardEta => '3–5 business days';

  @override
  String get deliveryExpress => 'Express';

  @override
  String get deliveryExpressEta => 'Next business day';

  @override
  String get orderSummary => 'Order summary';

  @override
  String get continueToPayment => 'Continue to payment';

  @override
  String get paymentTitle => 'Payment';

  @override
  String get cardNumber => 'Card number';

  @override
  String get cardHolder => 'Card holder';

  @override
  String get cardHolderPlaceholder => 'YOUR NAME';

  @override
  String get expiry => 'MM/YY';

  @override
  String get cvv => 'CVV';

  @override
  String get invalidCardNumber => 'Card number is not valid';

  @override
  String get invalidExpiry => 'Invalid or expired date';

  @override
  String get invalidCvv => 'Invalid security code';

  @override
  String get demoPaymentNote =>
      'Demo checkout — no real payment is taken. Use 4242 4242 4242 4242 to succeed or 4000 0000 0000 0002 to see a decline.';

  @override
  String get fillTestCard => 'Fill test card';

  @override
  String payAmount(String amount) {
    return 'Pay $amount';
  }

  @override
  String get processingPayment => 'Processing payment…';

  @override
  String get paymentDeclined => 'Your card was declined. Try another card.';

  @override
  String get orderSuccessTitle => 'Order confirmed!';

  @override
  String orderSuccessBody(String id) {
    return 'Order $id is being prepared. We\'ll let you know when it ships.';
  }

  @override
  String get viewOrders => 'View my orders';

  @override
  String get continueShopping => 'Continue shopping';

  @override
  String get ordersTitle => 'My orders';

  @override
  String get ordersEmptyTitle => 'No orders yet';

  @override
  String get ordersEmptyBody => 'Orders you place will show up here.';

  @override
  String get orderPreparing => 'Preparing';

  @override
  String paidWithCard(String last4) {
    return 'Card •••• $last4';
  }

  @override
  String get profileTitle => 'Profile';

  @override
  String get guestName => 'Guest shopper';

  @override
  String get guestSubtitle => 'Demo account';

  @override
  String get statOrders => 'Orders';

  @override
  String get statFavorites => 'Favorites';

  @override
  String get statInCart => 'In cart';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get about => 'About';

  @override
  String get aboutBody =>
      'NovaShop is a portfolio project built with Flutter and Riverpod. Product data comes from the public DummyJSON API.';

  @override
  String get sourceCode => 'Source code on GitHub';
}
