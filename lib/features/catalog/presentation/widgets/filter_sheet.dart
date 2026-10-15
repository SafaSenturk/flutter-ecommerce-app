import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/catalog_providers.dart';
import '../../domain/product_query.dart';

Future<void> showFilterSheet(BuildContext context) => showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const FilterSheet(),
    );

/// Edits a draft copy of the query and only applies it on "Show results".
class FilterSheet extends ConsumerStatefulWidget {
  const FilterSheet({super.key});

  @override
  ConsumerState<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<FilterSheet> {
  late ProductQuery _draft = ref.read(productQueryProvider);

  static const _ratings = [0.0, 3.0, 4.0, 4.5];

  String _sortLabel(AppLocalizations l, ProductSort s) => switch (s) {
        ProductSort.recommended => l.sortRecommended,
        ProductSort.priceLowHigh => l.sortPriceLowHigh,
        ProductSort.priceHighLow => l.sortPriceHighLow,
        ProductSort.bestDeals => l.sortBestDeals,
        ProductSort.nameAZ => l.sortNameAZ,
      };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    const ceiling = ProductQuery.priceCeiling;
    final values = RangeValues(_draft.minPrice ?? 0, _draft.maxPrice ?? ceiling);
    final maxLabel =
        _draft.maxPrice == null ? '${context.money(ceiling)}+' : context.money(values.end);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(l.filters, style: context.text.headlineSmall)),
              TextButton(
                onPressed: () => setState(() => _draft = _draft.clearFilters()),
                child: Text(l.reset),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _Label(l.sortBy),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in ProductSort.values)
                ChoiceChip(
                  label: Text(_sortLabel(l, s)),
                  selected: _draft.sort == s,
                  onSelected: (_) => setState(() => _draft = _draft.copyWith(sort: s)),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _Label(l.priceRange)),
              Text(
                '${context.money(values.start)} – $maxLabel',
                style: context.text.labelLarge?.copyWith(color: context.scheme.primary),
              ),
            ],
          ),
          RangeSlider(
            values: values,
            max: ceiling,
            divisions: 40,
            onChanged: (v) => setState(() {
              _draft = _draft.copyWith(
                minPrice: () => v.start <= 0 ? null : v.start,
                maxPrice: () => v.end >= ceiling ? null : v.end,
              );
            }),
          ),
          const SizedBox(height: 16),
          _Label(l.minRating),
          Wrap(
            spacing: 8,
            children: [
              for (final r in _ratings)
                ChoiceChip(
                  avatar: r == 0
                      ? null
                      : Icon(Icons.star_rounded, size: 18, color: context.colors.star),
                  label: Text(r == 0 ? l.anyRating : l.ratingAndUp(r.toString())),
                  selected: _draft.minRating == r,
                  onSelected: (_) => setState(() => _draft = _draft.copyWith(minRating: r)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: Text(l.inStockOnly, style: context.text.titleSmall),
            value: _draft.inStockOnly,
            onChanged: (v) => setState(() => _draft = _draft.copyWith(inStockOnly: v)),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              ref.read(productQueryProvider.notifier).apply(_draft);
              Navigator.pop(context);
            },
            child: Text(l.showResults),
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(text, style: context.text.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
      );
}
