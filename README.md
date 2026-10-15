<div align="center">

<img src="docs/banner.png" alt="NovaShop – Flutter e-commerce app" width="100%" />

# NovaShop · Flutter E-commerce App

A production-style shopping app: product catalog with search, filters and infinite scroll, favorites, a persistent cart with coupons, and a three-step demo checkout.

[![Flutter](https://img.shields.io/badge/Flutter-3.44-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.12-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![State](https://img.shields.io/badge/state-Riverpod%203-6C3BFF)](https://riverpod.dev)
[![CI](https://github.com/SafaSenturk/flutter-ecommerce-app/actions/workflows/ci.yml/badge.svg)](https://github.com/SafaSenturk/flutter-ecommerce-app/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-green)](LICENSE)

**[⬇️ Download the APK](https://github.com/SafaSenturk/flutter-ecommerce-app/releases/latest)** · [🇹🇷 Türkçe açıklama](#-türkçe)

</div>

---

## Demo

<p align="center">
  <img src="docs/demo.gif" alt="Browsing, adding to cart, applying a coupon and paying" width="300" />
</p>

<p align="center"><i>Browse → product details → add to cart → coupon → address → card payment → order confirmed</i></p>

## Features

**Catalog**
- Product grid with **infinite scroll**, pull-to-refresh and skeleton (shimmer) loading
- **Debounced search**, category chips and an auto-rotating promo carousel
- **Filter sheet**: sort (recommended, biggest discount, price, name), price range, minimum rating, in-stock only
- Product page with image gallery, **Hero animation**, stock status, details and customer reviews

**Cart & favorites**
- Favorites and cart are **saved on the device** and survive app restarts
- Quantity stepper, **swipe to delete with undo**, live totals
- Free-shipping progress bar and **coupon codes** (`NOVA10`, `FLUTTER20`)

**Checkout (demo)**
- Three-step flow: address form with validation → card payment → confirmation
- **Animated credit card** that detects the brand (Visa, Mastercard, Amex, Troy) and flips to show the CVV
- Real-world checks: **Luhn** card number validation, expiry date, CVV length per brand
- Test cards: `4242 4242 4242 4242` succeeds, `4000 0000 0000 0002` is declined — no real payment is ever taken
- Order history with delivery address and payment summary

**Quality**
- **Turkish and English** (switch in Profile, follows the device by default)
- **Light and dark theme**
- Every network screen handles **loading, empty and error states** with a retry button (offline, timeout and server errors get their own message)
- Unit tests for pricing, cart logic, filters and card validation; GitHub Actions runs `analyze` + `test` on every push

## Screenshots

| Home | Product | Filters | Results |
|:---:|:---:|:---:|:---:|
| <img src="docs/screenshots/01_home.jpg" width="200"/> | <img src="docs/screenshots/02_detail.jpg" width="200"/> | <img src="docs/screenshots/03_filters.jpg" width="200"/> | <img src="docs/screenshots/04_filtered.jpg" width="200"/> |
| **Cart + coupon** | **Address** | **Payment** | **CVV (card flips)** |
| <img src="docs/screenshots/05_cart.jpg" width="200"/> | <img src="docs/screenshots/06_checkout.jpg" width="200"/> | <img src="docs/screenshots/07_payment.jpg" width="200"/> | <img src="docs/screenshots/08_cvv.jpg" width="200"/> |
| **Order confirmed** | **Order history** | **Dark · Turkish** | **Dark · Turkish** |
| <img src="docs/screenshots/09_success.jpg" width="200"/> | <img src="docs/screenshots/10_orders.jpg" width="200"/> | <img src="docs/screenshots/12_home_dark_tr.jpg" width="200"/> | <img src="docs/screenshots/13_cart_dark_tr.jpg" width="200"/> |

## Tech stack

| Area | Choice |
|---|---|
| UI | Flutter 3.44, Material 3, custom design tokens (`ThemeExtension`), bundled Plus Jakarta Sans |
| State management | **Riverpod 3** (`Notifier`, `AsyncNotifier`, `FutureProvider.family`) |
| Navigation | **go_router** with `StatefulShellRoute` (each tab keeps its own stack) and route guards |
| Networking | **Dio** + a single `AppException` type mapped to user-friendly messages |
| Data | [DummyJSON](https://dummyjson.com) products API (194 products, 24 categories) |
| Persistence | `shared_preferences` (cart, favorites, orders, settings) |
| Images | `cached_network_image` |
| Localization | `flutter_localizations` + ARB files (`gen-l10n`), Turkish & English |
| Testing / CI | `flutter_test`, GitHub Actions |

## Architecture

Feature-first folders; each feature keeps its **domain** (plain Dart models and logic), **application** (Riverpod controllers) and **presentation** (widgets) apart, so business rules can be tested without Flutter.

```
lib/
├── main.dart                 # ProviderScope, theme, localization, router
├── core/
│   ├── network/              # Dio client + AppException
│   ├── router/               # go_router config, bottom-navigation shell
│   ├── storage/              # SharedPreferences provider
│   ├── theme/                # Light/dark theme + design tokens
│   ├── utils/                # Money/date formatting, Turkish category names
│   └── widgets/              # Shimmer, error/empty views, price tag, stepper…
├── features/
│   ├── catalog/              # Products: repository, query + infinite feed, screens
│   ├── cart/                 # Cart state, price summary (shipping, coupons)
│   ├── favorites/
│   ├── checkout/             # Address, card validation (Luhn), payment, success
│   ├── orders/
│   └── settings/             # Language & theme, profile screen
└── l10n/                     # app_en.arb, app_tr.arb (+ generated code)
```

How the product feed works: the user's filters live in one immutable `ProductQuery`. `ProductFeedNotifier` watches it, so any change (category, search, sort) automatically refetches page one. Category, search and sort go to the API; price and rating are filtered on the device, and the notifier keeps loading pages until enough matching products are on screen.

## Run it yourself

```bash
git clone https://github.com/SafaSenturk/flutter-ecommerce-app.git
cd flutter-ecommerce-app
flutter pub get
flutter run
```

```bash
flutter test      # 19 unit tests
flutter analyze   # strict lints, no issues
```

No API keys are needed. Release builds are signed with a local key when `android/key.properties` exists and fall back to debug keys otherwise.

---

## 🇹🇷 Türkçe

**NovaShop**, gerçek bir mağaza uygulamasında olması gereken her şeyi gösteren bir Flutter e-ticaret uygulamasıdır.

**Neler var?**
- Sonsuz kaydırmalı ürün listesi, anlık arama, kategori çipleri ve kampanya afişleri
- Filtre paneli: sıralama, fiyat aralığı, en düşük puan, sadece stoktakiler
- Ürün sayfası: görsel galerisi, Hero animasyonu, stok durumu, detaylar ve yorumlar
- Cihazda saklanan **favoriler** ve **sepet** (uygulama kapansa da kaybolmaz)
- Sepette adet değiştirme, kaydırarak silme ve geri alma, ücretsiz kargo çubuğu, **kupon kodu** (`NOVA10`, `FLUTTER20`)
- 3 adımlı **demo ödeme**: adres formu → kart bilgileri → sipariş onayı. Kart markasını tanıyan, CVV'de dönen animasyonlu kart; Luhn algoritmasıyla kart doğrulama. Gerçek ödeme alınmaz.
- Sipariş geçmişi
- **Türkçe / İngilizce** dil seçeneği, **açık / koyu tema**
- Her ekranda yükleniyor, boş ve hata durumları (internet yok, zaman aşımı, sunucu hatası) ve "Tekrar dene" düğmesi

**Teknik:** Flutter 3.44 · Riverpod 3 · go_router · Dio · SharedPreferences · ARB ile yerelleştirme · birim testleri · GitHub Actions

**Denemek için:** [Releases](https://github.com/SafaSenturk/flutter-ecommerce-app/releases/latest) sayfasından APK'yı indirip Android telefonuna kurabilirsin.

Bu tarz bir uygulamaya ihtiyacın varsa (kendi ürünlerin, kendi ödeme altyapın, kendi tasarımın ile) benimle iletişime geçebilirsin: **[safasenturk.github.io](https://safasenturk.github.io)**

---

<div align="center">

Built by **[Safa Şentürk](https://github.com/SafaSenturk)** · Flutter Mobile Developer · [Portfolio](https://safasenturk.github.io)

<sub>Product data and images come from the public <a href="https://dummyjson.com">DummyJSON</a> API and are used for demonstration only.</sub>

</div>
