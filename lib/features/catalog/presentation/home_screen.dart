import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../core/widgets/state_views.dart';
import '../../../l10n/app_localizations.dart';
import '../application/catalog_providers.dart';
import '../domain/product_query.dart';
import 'widgets/filter_sheet.dart';
import 'widgets/product_card.dart';
import 'widgets/promo_carousel.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scroll = ScrollController();
  final _search = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scroll.dispose();
    _search.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scroll.position.extentAfter < 600) {
      ref.read(productFeedProvider.notifier).loadMore();
    }
  }

  void _onSearchChanged(String text) {
    setState(() {}); // toggles the clear button
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      ref.read(productQueryProvider.notifier).setSearch(text);
    });
  }

  void _clearSearch() {
    _search.clear();
    _debounce?.cancel();
    ref.read(productQueryProvider.notifier).setSearch('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final query = ref.watch(productQueryProvider);
    final feed = ref.watch(productFeedProvider);
    final browsing = query.search.isEmpty && query.category == null && !query.hasLocalFilters;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          edgeOffset: 8,
          onRefresh: () => ref.read(productFeedProvider.notifier).refresh(),
          child: CustomScrollView(
            controller: _scroll,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _Header(l: l)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _search,
                          onChanged: _onSearchChanged,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            hintText: l.searchHint,
                            prefixIcon: const Icon(Icons.search_rounded),
                            suffixIcon: _search.text.isEmpty
                                ? null
                                : IconButton(
                                    onPressed: _clearSearch,
                                    icon: const Icon(Icons.close_rounded),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _FilterButton(count: query.activeFilterCount),
                    ],
                  ),
                ),
              ),
              if (browsing)
                const SliverToBoxAdapter(
                  child: Padding(padding: EdgeInsets.only(top: 20), child: PromoCarousel()),
                ),
              const SliverToBoxAdapter(child: _CategoryBar()),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          switch (feed.value) {
                            _ when browsing => l.popularNow,
                            FeedState(hasMore: true, :final items) => l.productCountMore(items.length),
                            final state => l.productCount(state?.items.length ?? 0),
                          },
                          style: context.text.titleMedium,
                        ),
                      ),
                      if (query.activeFilterCount > 0)
                        TextButton.icon(
                          onPressed: () => ref.read(productQueryProvider.notifier).clearFilters(),
                          icon: const Icon(Icons.filter_alt_off_rounded, size: 18),
                          label: Text(l.clearFilters),
                        ),
                    ],
                  ),
                ),
              ),
              ..._feedSlivers(context, feed),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _feedSlivers(BuildContext context, AsyncValue<FeedState> feed) {
    final l = AppLocalizations.of(context);
    const gridPadding = EdgeInsets.fromLTRB(20, 0, 20, 0);
    const delegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      childAspectRatio: 0.64,
    );

    // Keep showing old results while a new query loads, only on the first load
    // (or after an error) fall back to skeletons.
    if (feed.isLoading && !feed.hasValue || feed.isLoading && feed.hasError) {
      return [
        SliverPadding(
          padding: gridPadding,
          sliver: SliverGrid.builder(
            gridDelegate: delegate,
            itemCount: 6,
            itemBuilder: (_, _) => const ProductCardSkeleton(),
          ),
        ),
      ];
    }

    if (feed.hasError && !feed.hasValue) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: ErrorView(
            error: feed.error!,
            onRetry: () => ref.invalidate(productFeedProvider),
          ),
        ),
      ];
    }

    final state = feed.requireValue;
    if (state.items.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: MessageView(
            icon: Icons.search_off_rounded,
            title: l.noResultsTitle,
            body: l.noResultsBody,
            actionLabel: l.clearFilters,
            onAction: () {
              _search.clear();
              ref.read(productQueryProvider.notifier).apply(const ProductQuery());
            },
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: gridPadding,
        sliver: SliverOpacity(
          opacity: feed.isLoading ? 0.5 : 1,
          sliver: SliverGrid.builder(
            gridDelegate: delegate,
            itemCount: state.items.length,
            itemBuilder: (context, i) => _Entrance(
              key: ValueKey(state.items[i].id),
              delay: Duration(milliseconds: 40 * (i % 6)),
              child: ProductCard(product: state.items[i]),
            ),
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
          child: Center(
            child: switch (state) {
              FeedState(isLoadingMore: true) => const SizedBox.square(
                  dimension: 28,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
              FeedState(loadMoreError: final error?) => Column(
                  children: [
                    Text(errorMessage(context, error), textAlign: TextAlign.center),
                    TextButton(
                      onPressed: () => ref.read(productFeedProvider.notifier).loadMore(),
                      child: Text(l.retry),
                    ),
                  ],
                ),
              _ => const SizedBox.shrink(),
            },
          ),
        ),
      ),
    ];
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.l});

  final AppLocalizations l;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: context.scheme.primary,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 19),
                ),
                const SizedBox(width: 10),
                Text('NovaShop', style: context.text.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                const Spacer(),
                Text('${l.homeHello} 👋',
                    style: context.text.bodyMedium?.copyWith(color: context.colors.inkSoft)),
              ],
            ),
            const SizedBox(height: 18),
            Text(l.homeHeadline, style: context.text.headlineMedium?.copyWith(height: 1.1)),
          ],
        ),
      );
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) => Badge(
        isLabelVisible: count > 0,
        label: Text('$count'),
        backgroundColor: context.scheme.primary,
        child: SizedBox.square(
          dimension: 56,
          child: IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: context.scheme.onSurface,
              foregroundColor: context.scheme.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            tooltip: AppLocalizations.of(context).filters,
            onPressed: () => showFilterSheet(context),
            icon: const Icon(Icons.tune_rounded),
          ),
        ),
      );
}

class _CategoryBar extends ConsumerWidget {
  const _CategoryBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final selected = ref.watch(productQueryProvider.select((q) => q.category));
    final categories = ref.watch(categoriesProvider);

    Widget chip(String? slug, String label) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(label),
            selected: selected == slug,
            onSelected: (_) => ref.read(productQueryProvider.notifier).setCategory(slug),
          ),
        );

    return SizedBox(
      height: 64,
      child: categories.when(
        data: (list) => ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(20, 12, 12, 8),
          children: [
            chip(null, l.categoryAll),
            for (final c in list) chip(c.slug, categoryLabel(c.slug, c.name, locale)),
          ],
        ),
        loading: () => ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(20, 12, 12, 8),
          children: [
            for (var i = 0; i < 5; i++)
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Shimmer(child: SkeletonBox(width: 86, height: 40, radius: 20)),
              ),
          ],
        ),
        // Categories are optional; the product list shows the real error.
        error: (_, _) => ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(20, 12, 12, 8),
          children: [chip(null, l.categoryAll)],
        ),
      ),
    );
  }
}

/// Fades and slides a grid item in the first time it is built.
class _Entrance extends StatelessWidget {
  const _Entrance({super.key, required this.child, this.delay = Duration.zero});

  final Widget child;
  final Duration delay;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 420) + delay,
        curve: Interval(
          delay.inMilliseconds / (420 + delay.inMilliseconds),
          1,
          curve: Curves.easeOutCubic,
        ),
        builder: (context, t, child) => Opacity(
          opacity: t,
          child: Transform.translate(offset: Offset(0, 24 * (1 - t)), child: child),
        ),
        child: child,
      );
}
