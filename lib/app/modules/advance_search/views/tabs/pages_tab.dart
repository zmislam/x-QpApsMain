// =============================================================================
// Pages Tab — List of SearchPageCard with infinite scroll
// =============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/advance_search_controller.dart';
import '../../models/search_result_models.dart';
import '../widgets/search_empty_state.dart';
import '../widgets/search_page_card.dart';

class PagesTab extends GetView<AdvanceSearchController> {
  const PagesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.tabLoading[SearchTab.pages] ?? false;
      final isLoadingMore = controller.tabLoadingMore[SearchTab.pages] ?? false;
      final items = controller.tabResults[SearchTab.pages] ?? [];

      if (isLoading && items.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (!controller.hasSearched.value) {
        return const SizedBox.shrink();
      }

      if (items.isEmpty) {
        return SearchEmptyState(
          query: controller.query.value,
          subtitle: 'No pages found matching "${controller.query.value}".',
        );
      }

      return ListView.builder(
        controller: controller.scrollControllers[SearchTab.pages],
        padding: const EdgeInsets.only(top: 4, bottom: 24),
        itemCount: items.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= items.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          }

          final page = items[index] as SearchPageResult;
          return SearchPageCard(
            page: page,
            onTap: () => controller.onTapPage(page),
            onActionTap: () => controller.toggleFollowPage(page),
          );
        },
      );
    });
  }
}
