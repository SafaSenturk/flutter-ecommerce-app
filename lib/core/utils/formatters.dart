import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

extension FormatX on BuildContext {
  String get _locale => Localizations.localeOf(this).toLanguageTag();

  /// Prices come from the API in US dollars.
  String money(num value) =>
      NumberFormat.simpleCurrency(locale: _locale, name: 'USD').format(value);

  String shortDate(DateTime date) => DateFormat.yMMMd(_locale).add_Hm().format(date);
}

/// DummyJSON only returns English category names, so Turkish labels live here.
String categoryLabel(String slug, String fallback, Locale locale) {
  if (locale.languageCode != 'tr') return fallback;
  return _trCategories[slug] ?? fallback;
}

const _trCategories = {
  'beauty': 'Güzellik',
  'fragrances': 'Parfüm',
  'furniture': 'Mobilya',
  'groceries': 'Market',
  'home-decoration': 'Ev dekorasyonu',
  'kitchen-accessories': 'Mutfak',
  'laptops': 'Dizüstü',
  'mens-shirts': 'Erkek gömlek',
  'mens-shoes': 'Erkek ayakkabı',
  'mens-watches': 'Erkek saat',
  'mobile-accessories': 'Telefon aksesuarı',
  'motorcycle': 'Motosiklet',
  'skin-care': 'Cilt bakımı',
  'smartphones': 'Akıllı telefon',
  'sports-accessories': 'Spor',
  'sunglasses': 'Güneş gözlüğü',
  'tablets': 'Tablet',
  'tops': 'Üst giyim',
  'vehicle': 'Araç',
  'womens-bags': 'Kadın çanta',
  'womens-dresses': 'Elbise',
  'womens-jewellery': 'Takı',
  'womens-shoes': 'Kadın ayakkabı',
  'womens-watches': 'Kadın saat',
};

/// Turns a slug like "mens-shoes" into "Mens Shoes" when no name is known.
String prettifySlug(String slug) => slug
    .split('-')
    .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
    .join(' ');
