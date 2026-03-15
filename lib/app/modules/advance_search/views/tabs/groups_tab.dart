// =============================================================================
// Groups Tab — List of SearchGroupCard with infinite scroll
// =============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/advance_search_controller.dart';
import '../../models/search_result_models.dart';
import '../widgets/search_empty_state.dart';
import '../widgets/search_group_card.dart';

class GroupsTab extends GetView<AdvanceSearchController> {
  const GroupsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.tabLoading[SearchTab.groups] ?? false;
      final isLoadingMore = controller.tabLoadingMore[SearchTab.groups] ?? false;
      final items = controller.tabResults[SearchTab.groups] ?? [];

      if (isLoading && items.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (!controller.hasSearched.value) {
        return const SizedBox.shrink();
      }

      if (items.isEmpty) {
        return SearchEmptyState(
          query: controller.query.value,
          subtitle: 'No groups found matching "${controller.query.value}".',
        );
      }

      return ListView.builder(
        controller: controller.scrollControllers[SearchTab.groups],
        padding: const EdgeInsets.only(top: 4, bottom: 24),
        itemCount: items.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= items.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          }

          final group = items[index] as SearchGroupResult;
          return SearchGroupCard(
            group: group,
            onTap: () => controller.onTapGroup(group),
            onActionTap: () => controller.toggleJoinGroup(group),
          );
        },
      );
    });
  }
}
