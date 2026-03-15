// =============================================================================
// Marketplace Tab — 2-column grid of SearchMarketplaceCard with infinite scroll
// =============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/advance_search_controller.dart';
import '../../models/search_result_models.dart';
import '../widgets/search_empty_state.dart';
import '../widgets/search_marketplace_card.dart';

class MarketplaceTab extends GetView<AdvanceSearchController> {
  const MarketplaceTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.tabLoading[SearchTab.marketplace] ?? false;
      final isLoadingMore = controller.tabLoadingMore[SearchTab.marketplace] ?? false;
      final items = controller.tabResults[SearchTab.marketplace] ?? [];

      if (isLoading && items.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (!controller.hasSearched.value) {
        return const SizedBox.shrink();
      }

      if (items.isEmpty) {
        return SearchEmptyState(
          query: controller.query.value,
          subtitle: 'No marketplace items found matching "${controller.query.value}".',
        );
      }

      return CustomScrollView(
        controller: controller.scrollControllers[SearchTab.marketplace],
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = items[index] as SearchMarketplaceResult;
                  return SearchMarketplaceCard(
                    product: product,
                    onTap: () => controller.onTapMarketplaceItem(product),
                  );
                },
                childCount: items.length,
              ),
            ),
          ),
          if (isLoadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
            ),
        ],
      );
    });
  }
}
