// =============================================================================
// People Tab — List of SearchPersonCard with infinite scroll
// =============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/advance_search_controller.dart';
import '../../models/search_result_models.dart';
import '../widgets/search_empty_state.dart';
import '../widgets/search_person_card.dart';

class PeopleTab extends GetView<AdvanceSearchController> {
  const PeopleTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.tabLoading[SearchTab.people] ?? false;
      final isLoadingMore = controller.tabLoadingMore[SearchTab.people] ?? false;
      final items = controller.tabResults[SearchTab.people] ?? [];

      if (isLoading && items.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (!controller.hasSearched.value) {
        return const SizedBox.shrink();
      }

      if (items.isEmpty) {
        return SearchEmptyState(
          query: controller.query.value,
          subtitle: 'No people found matching "${controller.query.value}".',
        );
      }

      return ListView.builder(
        controller: controller.scrollControllers[SearchTab.people],
        padding: const EdgeInsets.only(top: 4, bottom: 24),
        itemCount: items.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= items.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          }

          final person = items[index] as SearchPersonResult;
          return SearchPersonCard(
            person: person,
            onTap: () => controller.onTapPerson(person),
            onActionTap: () => controller.toggleFriendRequest(person),
          );
        },
      );
    });
  }
}
