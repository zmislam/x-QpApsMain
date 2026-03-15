// =============================================================================
// Reels Tab — 2-column grid of SearchReelCard with infinite scroll
// =============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/advance_search_controller.dart';
import '../../models/search_result_models.dart';
import '../widgets/search_empty_state.dart';
import '../widgets/search_reel_card.dart';

class ReelsTab extends GetView<AdvanceSearchController> {
  const ReelsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.tabLoading[SearchTab.reels] ?? false;
      final isLoadingMore = controller.tabLoadingMore[SearchTab.reels] ?? false;
      final items = controller.tabResults[SearchTab.reels] ?? [];

      if (isLoading && items.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (!controller.hasSearched.value) {
        return const SizedBox.shrink();
      }

      if (items.isEmpty) {
        return SearchEmptyState(
          query: controller.query.value,
          subtitle: 'No reels found matching "${controller.query.value}".',
        );
      }

      return CustomScrollView(
        controller: controller.scrollControllers[SearchTab.reels],
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.65,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final reel = items[index] as SearchReelResult;
                  return SearchReelCard(
                    reel: reel,
                    onTap: () => controller.onTapReel(reel),
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
