import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'NovaShop'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get navHome;

  /// No description provided for @navFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get navFavorites;

  /// No description provided for @navCart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get navCart;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @homeHello.
  ///
  /// In en, this message translates to:
  /// **'Hello there'**
  String get homeHello;

  /// No description provided for @homeHeadline.
  ///
  /// In en, this message translates to:
  /// **'Find something\nyou\'ll love'**
  String get homeHeadline;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search products, brands…'**
  String get searchHint;

  /// No description provided for @categoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get categoryAll;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @sortRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get sortRecommended;

  /// No description provided for @sortPriceLowHigh.
  ///
  /// In en, this message translates to:
  /// **'Price: low to high'**
  String get sortPriceLowHigh;

  /// No description provided for @sortPriceHighLow.
  ///
  /// In en, this message translates to:
  /// **'Price: high to low'**
  String get sortPriceHighLow;

  /// No description provided for @sortBestDeals.
  ///
  /// In en, this message translates to:
  /// **'Biggest discounts'**
  String get sortBestDeals;

  /// No description provided for @sortNameAZ.
  ///
  /// In en, this message translates to:
  /// **'Name (A–Z)'**
  String get sortNameAZ;

  /// No description provided for @priceRange.
  ///
  /// In en, this message translates to:
  /// **'Price range'**
  String get priceRange;

  /// No description provided for @minRating.
  ///
  /// In en, this message translates to:
  /// **'Minimum rating'**
  String get minRating;

  /// No description provided for @anyRating.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get anyRating;

  /// No description provided for @ratingAndUp.
  ///
  /// In en, this message translates to:
  /// **'{rating}+'**
  String ratingAndUp(String rating);

  /// No description provided for @inStockOnly.
  ///
  /// In en, this message translates to:
  /// **'In stock only'**
  String get inStockOnly;

  /// No description provided for @showResults.
  ///
  /// In en, this message translates to:
  /// **'Show results'**
  String get showResults;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @productCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No products} =1{1 product} other{{count} products}}'**
  String productCount(int count);

  /// No description provided for @productCountMore.
  ///
  /// In en, this message translates to:
  /// **'{count}+ products'**
  String productCountMore(int count);

  /// No description provided for @promo1Title.
  ///
  /// In en, this message translates to:
  /// **'Up to 40% off'**
  String get promo1Title;

  /// No description provided for @promo1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Beauty & fragrance week'**
  String get promo1Subtitle;

  /// No description provided for @promo2Title.
  ///
  /// In en, this message translates to:
  /// **'Free shipping'**
  String get promo2Title;

  /// No description provided for @promo2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'On every order over \$100'**
  String get promo2Subtitle;

  /// No description provided for @promo3Title.
  ///
  /// In en, this message translates to:
  /// **'New tech drops'**
  String get promo3Title;

  /// No description provided for @promo3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Phones, laptops & more'**
  String get promo3Subtitle;

  /// No description provided for @shopNow.
  ///
  /// In en, this message translates to:
  /// **'Shop now'**
  String get shopNow;

  /// No description provided for @popularNow.
  ///
  /// In en, this message translates to:
  /// **'Popular right now'**
  String get popularNow;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorTitle;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'You seem to be offline. Check your connection and try again.'**
  String get errorNetwork;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'The server took too long to answer. Please try again.'**
  String get errorTimeout;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'The store is not responding right now. Please try again in a moment.'**
  String get errorServer;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred.'**
  String get errorUnknown;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @noResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get noResultsTitle;

  /// No description provided for @noResultsBody.
  ///
  /// In en, this message translates to:
  /// **'Try another search or loosen your filters.'**
  String get noResultsBody;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get addToCart;

  /// No description provided for @addedToCart.
  ///
  /// In en, this message translates to:
  /// **'Added to your cart'**
  String get addedToCart;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @outOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get outOfStock;

  /// No description provided for @inStockCount.
  ///
  /// In en, this message translates to:
  /// **'In stock · {count}'**
  String inStockCount(int count);

  /// No description provided for @lowStock.
  ///
  /// In en, this message translates to:
  /// **'Only {count} left'**
  String lowStock(int count);

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @reviewCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No reviews} =1{1 review} other{{count} reviews}}'**
  String reviewCount(int count);

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brand;

  /// No description provided for @warranty.
  ///
  /// In en, this message translates to:
  /// **'Warranty'**
  String get warranty;

  /// No description provided for @shipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get shipping;

  /// No description provided for @returns.
  ///
  /// In en, this message translates to:
  /// **'Returns'**
  String get returns;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @favoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritesTitle;

  /// No description provided for @favoritesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get favoritesEmptyTitle;

  /// No description provided for @favoritesEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart on any product to keep it here for later.'**
  String get favoritesEmptyBody;

  /// No description provided for @cartTitle.
  ///
  /// In en, this message translates to:
  /// **'My cart'**
  String get cartTitle;

  /// No description provided for @cartEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cartEmptyTitle;

  /// No description provided for @cartEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Looks like you haven\'t added anything yet.'**
  String get cartEmptyBody;

  /// No description provided for @startShopping.
  ///
  /// In en, this message translates to:
  /// **'Start shopping'**
  String get startShopping;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @shippingFee.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get shippingFee;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @couponHint.
  ///
  /// In en, this message translates to:
  /// **'Coupon code'**
  String get couponHint;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @couponApplied.
  ///
  /// In en, this message translates to:
  /// **'{code} applied · {percent}% off'**
  String couponApplied(String code, int percent);

  /// No description provided for @couponInvalid.
  ///
  /// In en, this message translates to:
  /// **'That coupon code isn\'t valid'**
  String get couponInvalid;

  /// No description provided for @couponTip.
  ///
  /// In en, this message translates to:
  /// **'Tip: try NOVA10 or FLUTTER20'**
  String get couponTip;

  /// No description provided for @freeShippingProgress.
  ///
  /// In en, this message translates to:
  /// **'Add {amount} more for free shipping'**
  String freeShippingProgress(String amount);

  /// No description provided for @freeShippingUnlocked.
  ///
  /// In en, this message translates to:
  /// **'You\'ve unlocked free shipping'**
  String get freeShippingUnlocked;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @removedFromCart.
  ///
  /// In en, this message translates to:
  /// **'{name} removed'**
  String removedFromCart(String name);

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @itemCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String itemCount(int count);

  /// No description provided for @stepAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get stepAddress;

  /// No description provided for @stepPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get stepPayment;

  /// No description provided for @stepDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get stepDone;

  /// No description provided for @deliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Delivery address'**
  String get deliveryAddress;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Street address'**
  String get address;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @zip.
  ///
  /// In en, this message translates to:
  /// **'Postal code'**
  String get zip;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get invalidPhone;

  /// No description provided for @deliveryMethod.
  ///
  /// In en, this message translates to:
  /// **'Delivery method'**
  String get deliveryMethod;

  /// No description provided for @deliveryStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get deliveryStandard;

  /// No description provided for @deliveryStandardEta.
  ///
  /// In en, this message translates to:
  /// **'3–5 business days'**
  String get deliveryStandardEta;

  /// No description provided for @deliveryExpress.
  ///
  /// In en, this message translates to:
  /// **'Express'**
  String get deliveryExpress;

  /// No description provided for @deliveryExpressEta.
  ///
  /// In en, this message translates to:
  /// **'Next business day'**
  String get deliveryExpressEta;

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order summary'**
  String get orderSummary;

  /// No description provided for @continueToPayment.
  ///
  /// In en, this message translates to:
  /// **'Continue to payment'**
  String get continueToPayment;

  /// No description provided for @paymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get paymentTitle;

  /// No description provided for @cardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card number'**
  String get cardNumber;

  /// No description provided for @cardHolder.
  ///
  /// In en, this message translates to:
  /// **'Card holder'**
  String get cardHolder;

  /// No description provided for @cardHolderPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'YOUR NAME'**
  String get cardHolderPlaceholder;

  /// No description provided for @expiry.
  ///
  /// In en, this message translates to:
  /// **'MM/YY'**
  String get expiry;

  /// No description provided for @cvv.
  ///
  /// In en, this message translates to:
  /// **'CVV'**
  String get cvv;

  /// No description provided for @invalidCardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card number is not valid'**
  String get invalidCardNumber;

  /// No description provided for @invalidExpiry.
  ///
  /// In en, this message translates to:
  /// **'Invalid or expired date'**
  String get invalidExpiry;

  /// No description provided for @invalidCvv.
  ///
  /// In en, this message translates to:
  /// **'Invalid security code'**
  String get invalidCvv;

  /// No description provided for @demoPaymentNote.
  ///
  /// In en, this message translates to:
  /// **'Demo checkout — no real payment is taken. Use 4242 4242 4242 4242 to succeed or 4000 0000 0000 0002 to see a decline.'**
  String get demoPaymentNote;

  /// No description provided for @fillTestCard.
  ///
  /// In en, this message translates to:
  /// **'Fill test card'**
  String get fillTestCard;

  /// No description provided for @payAmount.
  ///
  /// In en, this message translates to:
  /// **'Pay {amount}'**
  String payAmount(String amount);

  /// No description provided for @processingPayment.
  ///
  /// In en, this message translates to:
  /// **'Processing payment…'**
  String get processingPayment;

  /// No description provided for @paymentDeclined.
  ///
  /// In en, this message translates to:
  /// **'Your card was declined. Try another card.'**
  String get paymentDeclined;

  /// No description provided for @orderSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Order confirmed!'**
  String get orderSuccessTitle;

  /// No description provided for @orderSuccessBody.
  ///
  /// In en, this message translates to:
  /// **'Order {id} is being prepared. We\'ll let you know when it ships.'**
  String orderSuccessBody(String id);

  /// No description provided for @viewOrders.
  ///
  /// In en, this message translates to:
  /// **'View my orders'**
  String get viewOrders;

  /// No description provided for @continueShopping.
  ///
  /// In en, this message translates to:
  /// **'Continue shopping'**
  String get continueShopping;

  /// No description provided for @ordersTitle.
  ///
  /// In en, this message translates to:
  /// **'My orders'**
  String get ordersTitle;

  /// No description provided for @ordersEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get ordersEmptyTitle;

  /// No description provided for @ordersEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Orders you place will show up here.'**
  String get ordersEmptyBody;

  /// No description provided for @orderPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing'**
  String get orderPreparing;

  /// No description provided for @paidWithCard.
  ///
  /// In en, this message translates to:
  /// **'Card •••• {last4}'**
  String paidWithCard(String last4);

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @guestName.
  ///
  /// In en, this message translates to:
  /// **'Guest shopper'**
  String get guestName;

  /// No description provided for @guestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Demo account'**
  String get guestSubtitle;

  /// No description provided for @statOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get statOrders;

  /// No description provided for @statFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get statFavorites;

  /// No description provided for @statInCart.
  ///
  /// In en, this message translates to:
  /// **'In cart'**
  String get statInCart;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutBody.
  ///
  /// In en, this message translates to:
  /// **'NovaShop is a portfolio project built with Flutter and Riverpod. Product data comes from the public DummyJSON API.'**
  String get aboutBody;

  /// No description provided for @sourceCode.
  ///
  /// In en, this message translates to:
  /// **'Source code on GitHub'**
  String get sourceCode;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
