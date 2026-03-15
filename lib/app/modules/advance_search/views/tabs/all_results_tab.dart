// =============================================================================
// All Results Tab — Shows mixed results from unified search
// =============================================================================
// Displays sections: Groups → "See all", Pages → "See all", Reels → "See all"
// Similar to Facebook's "All" tab in search.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/advance_search_controller.dart';
import '../widgets/search_empty_state.dart';
import '../widgets/search_group_card.dart';
import '../widgets/search_marketplace_card.dart';
import '../widgets/search_page_card.dart';
import '../widgets/search_person_card.dart';
import '../widgets/search_reel_card.dart';

class AllResultsTab extends GetView<AdvanceSearchController> {
  const AllResultsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final isLoading = controller.tabLoading[SearchTab.all] ?? false;
      final unified = controller.unifiedResult.value;

      if (isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (!controller.hasSearched.value) {
        return const SizedBox.shrink();
      }

      // Check if all empty
      final totalItems = unified.people.items.length +
          unified.reels.items.length +
          unified.pages.items.length +
          unified.groups.items.length +
          unified.marketplace.items.length;

      if (totalItems == 0) {
        return SearchEmptyState(query: controller.query.value);
      }

      return ListView(
        controller: controller.scrollControllers[SearchTab.all],
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          // ── People Section ──────────────────────────────────────────
          if (unified.people.items.isNotEmpty) ...[
            _SectionHeader(
              title: 'People',
              onSeeAll: () => controller.tabController.animateTo(
                SearchTab.values.indexOf(SearchTab.people),
              ),
              showSeeAll: unified.people.hasMore || unified.people.items.length > 3,
              isDark: isDark,
            ),
            ...unified.people.items.take(3).map(
                  (p) => SearchPersonCard(
                    person: p,
                    onTap: () => controller.onTapPerson(p),
                    onActionTap: () => controller.toggleFriendRequest(p),
                  ),
                ),
          ],

          // ── Groups Section ──────────────────────────────────────────
          if (unified.groups.items.isNotEmpty) ...[
            _SectionHeader(
              title: 'Groups',
              onSeeAll: () => controller.tabController.animateTo(
                SearchTab.values.indexOf(SearchTab.groups),
              ),
              showSeeAll: unified.groups.hasMore || unified.groups.items.length > 3,
              isDark: isDark,
            ),
            ...unified.groups.items.take(3).map(
                  (g) => SearchGroupCard(
                    group: g,
                    onTap: () => controller.onTapGroup(g),
                    onActionTap: () => controller.toggleJoinGroup(g),
                  ),
                ),
          ],

          // ── Pages Section ───────────────────────────────────────────
          if (unified.pages.items.isNotEmpty) ...[
            _SectionHeader(
              title: 'Pages',
              onSeeAll: () => controller.tabController.animateTo(
                SearchTab.values.indexOf(SearchTab.pages),
              ),
              showSeeAll: unified.pages.hasMore || unified.pages.items.length > 3,
              isDark: isDark,
            ),
            ...unified.pages.items.take(3).map(
                  (pg) => SearchPageCard(
                    page: pg,
                    onTap: () => controller.onTapPage(pg),
                    onActionTap: () => controller.toggleFollowPage(pg),
                  ),
                ),
          ],

          // ── Reels Section (2-column grid preview) ───────────────────
          if (unified.reels.items.isNotEmpty) ...[
            _SectionHeader(
              title: 'Reels',
              onSeeAll: () => controller.tabController.animateTo(
                SearchTab.values.indexOf(SearchTab.reels),
              ),
              showSeeAll: unified.reels.hasMore || unified.reels.items.length > 4,
              isDark: isDark,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: unified.reels.items.take(4).length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, i) {
                  final reel = unified.reels.items[i];
                  return SearchReelCard(
                    reel: reel,
                    onTap: () => controller.onTapReel(reel),
                  );
                },
              ),
            ),
          ],

          // ── Marketplace Section ─────────────────────────────────────
          if (unified.marketplace.items.isNotEmpty) ...[
            _SectionHeader(
              title: 'Marketplace',
              onSeeAll: () => controller.tabController.animateTo(
                SearchTab.values.indexOf(SearchTab.marketplace),
              ),
              showSeeAll: unified.marketplace.hasMore || unified.marketplace.items.length > 4,
              isDark: isDark,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: unified.marketplace.items.take(4).length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, i) {
                  final product = unified.marketplace.items[i];
                  return SearchMarketplaceCard(
                    product: product,
                    onTap: () => controller.onTapMarketplaceItem(product),
                  );
                },
              ),
            ),
          ],
        ],
      );
    });
  }
}

// =============================================================================
// Section Header with "See all" button
// =============================================================================

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;
  final bool showSeeAll;
  final bool isDark;

  const _SectionHeader({
    required this.title,
    required this.onSeeAll,
    this.showSeeAll = true,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          if (showSeeAll)
            GestureDetector(
              onTap: onSeeAll,
              child: Text(
                'See all',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
