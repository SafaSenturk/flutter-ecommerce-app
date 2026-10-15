// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'NovaShop';

  @override
  String get navHome => 'Keşfet';

  @override
  String get navFavorites => 'Favoriler';

  @override
  String get navCart => 'Sepet';

  @override
  String get navProfile => 'Profil';

  @override
  String get homeHello => 'Merhaba';

  @override
  String get homeHeadline => 'Seveceğin bir\nşey bul';

  @override
  String get searchHint => 'Ürün, marka ara…';

  @override
  String get categoryAll => 'Tümü';

  @override
  String get filters => 'Filtreler';

  @override
  String get sortBy => 'Sırala';

  @override
  String get sortRecommended => 'Önerilen';

  @override
  String get sortPriceLowHigh => 'Fiyat: artan';

  @override
  String get sortPriceHighLow => 'Fiyat: azalan';

  @override
  String get sortBestDeals => 'En çok indirim';

  @override
  String get sortNameAZ => 'İsim (A–Z)';

  @override
  String get priceRange => 'Fiyat aralığı';

  @override
  String get minRating => 'En düşük puan';

  @override
  String get anyRating => 'Hepsi';

  @override
  String ratingAndUp(String rating) {
    return '$rating+';
  }

  @override
  String get inStockOnly => 'Sadece stoktakiler';

  @override
  String get showResults => 'Sonuçları göster';

  @override
  String get reset => 'Sıfırla';

  @override
  String productCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ürün',
      zero: 'Ürün yok',
    );
    return '$_temp0';
  }

  @override
  String productCountMore(int count) {
    return '$count+ ürün';
  }

  @override
  String get promo1Title => '%40\'a varan indirim';

  @override
  String get promo1Subtitle => 'Güzellik ve parfüm haftası';

  @override
  String get promo2Title => 'Ücretsiz kargo';

  @override
  String get promo2Subtitle => '100\$ üzeri tüm siparişlerde';

  @override
  String get promo3Title => 'Yeni teknoloji ürünleri';

  @override
  String get promo3Subtitle => 'Telefon, dizüstü ve dahası';

  @override
  String get shopNow => 'Alışverişe başla';

  @override
  String get popularNow => 'Şu an popüler';

  @override
  String get errorTitle => 'Bir şeyler ters gitti';

  @override
  String get errorNetwork =>
      'İnternet bağlantın yok gibi görünüyor. Bağlantını kontrol edip tekrar dene.';

  @override
  String get errorTimeout => 'Sunucu çok geç yanıt verdi. Lütfen tekrar dene.';

  @override
  String get errorServer =>
      'Mağaza şu an yanıt vermiyor. Birazdan tekrar dene.';

  @override
  String get errorUnknown => 'Beklenmeyen bir hata oluştu.';

  @override
  String get retry => 'Tekrar dene';

  @override
  String get noResultsTitle => 'Ürün bulunamadı';

  @override
  String get noResultsBody => 'Başka bir arama dene ya da filtreleri gevşet.';

  @override
  String get clearFilters => 'Filtreleri temizle';

  @override
  String get addToCart => 'Sepete ekle';

  @override
  String get addedToCart => 'Sepetine eklendi';

  @override
  String get view => 'Görüntüle';

  @override
  String get outOfStock => 'Stokta yok';

  @override
  String inStockCount(int count) {
    return 'Stokta · $count';
  }

  @override
  String lowStock(int count) {
    return 'Son $count ürün';
  }

  @override
  String get description => 'Açıklama';

  @override
  String get reviews => 'Yorumlar';

  @override
  String reviewCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yorum',
      zero: 'Yorum yok',
    );
    return '$_temp0';
  }

  @override
  String get details => 'Detaylar';

  @override
  String get brand => 'Marka';

  @override
  String get warranty => 'Garanti';

  @override
  String get shipping => 'Kargo';

  @override
  String get returns => 'İade';

  @override
  String get quantity => 'Adet';

  @override
  String get favoritesTitle => 'Favorilerim';

  @override
  String get favoritesEmptyTitle => 'Henüz favorin yok';

  @override
  String get favoritesEmptyBody =>
      'Bir üründeki kalbe dokun, sonrası için burada saklayalım.';

  @override
  String get cartTitle => 'Sepetim';

  @override
  String get cartEmptyTitle => 'Sepetin boş';

  @override
  String get cartEmptyBody => 'Henüz bir şey eklememişsin gibi görünüyor.';

  @override
  String get startShopping => 'Alışverişe başla';

  @override
  String get subtotal => 'Ara toplam';

  @override
  String get discount => 'İndirim';

  @override
  String get shippingFee => 'Kargo';

  @override
  String get free => 'Ücretsiz';

  @override
  String get total => 'Toplam';

  @override
  String get couponHint => 'Kupon kodu';

  @override
  String get apply => 'Uygula';

  @override
  String couponApplied(String code, int percent) {
    return '$code uygulandı · %$percent indirim';
  }

  @override
  String get couponInvalid => 'Bu kupon kodu geçerli değil';

  @override
  String get couponTip => 'İpucu: NOVA10 ya da FLUTTER20 dene';

  @override
  String freeShippingProgress(String amount) {
    return 'Ücretsiz kargo için $amount daha ekle';
  }

  @override
  String get freeShippingUnlocked => 'Ücretsiz kargo kazandın';

  @override
  String get checkout => 'Ödemeye geç';

  @override
  String removedFromCart(String name) {
    return '$name kaldırıldı';
  }

  @override
  String get undo => 'Geri al';

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ürün',
    );
    return '$_temp0';
  }

  @override
  String get stepAddress => 'Adres';

  @override
  String get stepPayment => 'Ödeme';

  @override
  String get stepDone => 'Tamam';

  @override
  String get deliveryAddress => 'Teslimat adresi';

  @override
  String get fullName => 'Ad soyad';

  @override
  String get phone => 'Telefon';

  @override
  String get address => 'Açık adres';

  @override
  String get city => 'Şehir';

  @override
  String get zip => 'Posta kodu';

  @override
  String get fieldRequired => 'Bu alan zorunlu';

  @override
  String get invalidPhone => 'Geçerli bir telefon numarası gir';

  @override
  String get deliveryMethod => 'Teslimat yöntemi';

  @override
  String get deliveryStandard => 'Standart';

  @override
  String get deliveryStandardEta => '3–5 iş günü';

  @override
  String get deliveryExpress => 'Hızlı';

  @override
  String get deliveryExpressEta => 'Ertesi iş günü';

  @override
  String get orderSummary => 'Sipariş özeti';

  @override
  String get continueToPayment => 'Ödemeye devam et';

  @override
  String get paymentTitle => 'Ödeme';

  @override
  String get cardNumber => 'Kart numarası';

  @override
  String get cardHolder => 'Kart sahibi';

  @override
  String get cardHolderPlaceholder => 'AD SOYAD';

  @override
  String get expiry => 'AA/YY';

  @override
  String get cvv => 'CVV';

  @override
  String get invalidCardNumber => 'Kart numarası geçersiz';

  @override
  String get invalidExpiry => 'Geçersiz ya da geçmiş tarih';

  @override
  String get invalidCvv => 'Güvenlik kodu geçersiz';

  @override
  String get demoPaymentNote =>
      'Demo ödeme — gerçek bir ücret alınmaz. Başarılı ödeme için 4242 4242 4242 4242, reddedilen ödemeyi görmek için 4000 0000 0000 0002 kullan.';

  @override
  String get fillTestCard => 'Test kartını doldur';

  @override
  String payAmount(String amount) {
    return '$amount öde';
  }

  @override
  String get processingPayment => 'Ödeme işleniyor…';

  @override
  String get paymentDeclined => 'Kartın reddedildi. Başka bir kart dene.';

  @override
  String get orderSuccessTitle => 'Siparişin alındı!';

  @override
  String orderSuccessBody(String id) {
    return '$id numaralı siparişin hazırlanıyor. Kargoya verildiğinde haber vereceğiz.';
  }

  @override
  String get viewOrders => 'Siparişlerime git';

  @override
  String get continueShopping => 'Alışverişe devam et';

  @override
  String get ordersTitle => 'Siparişlerim';

  @override
  String get ordersEmptyTitle => 'Henüz siparişin yok';

  @override
  String get ordersEmptyBody => 'Verdiğin siparişler burada görünecek.';

  @override
  String get orderPreparing => 'Hazırlanıyor';

  @override
  String paidWithCard(String last4) {
    return 'Kart •••• $last4';
  }

  @override
  String get profileTitle => 'Profil';

  @override
  String get guestName => 'Misafir kullanıcı';

  @override
  String get guestSubtitle => 'Demo hesap';

  @override
  String get statOrders => 'Sipariş';

  @override
  String get statFavorites => 'Favori';

  @override
  String get statInCart => 'Sepette';

  @override
  String get settings => 'Ayarlar';

  @override
  String get language => 'Dil';

  @override
  String get theme => 'Tema';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeDark => 'Koyu';

  @override
  String get about => 'Hakkında';

  @override
  String get aboutBody =>
      'NovaShop, Flutter ve Riverpod ile geliştirilmiş bir portföy projesidir. Ürün verileri herkese açık DummyJSON API\'sinden gelir.';

  @override
  String get sourceCode => 'GitHub\'da kaynak kod';
}
