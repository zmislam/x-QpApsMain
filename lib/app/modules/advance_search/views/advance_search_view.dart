// =============================================================================
// Advance Search View — Main scaffold with search bar + tabs + content
// =============================================================================
// Layout:
//   - Initial state: Search bar + History/Suggestions list (like Facebook)
//   - After search: Search bar + Tab pills + TabBarView results
//   - Focused while results shown: Suggestions overlay on top of results
// =============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/advance_search_controller.dart';
import 'tabs/all_results_tab.dart';
import 'tabs/events_tab.dart';
import 'tabs/groups_tab.dart';
import 'tabs/marketplace_tab.dart';
import 'tabs/pages_tab.dart';
import 'tabs/people_tab.dart';
import 'tabs/reels_tab.dart';
import 'widgets/search_suggestion_list.dart';

class AdvanceSearchView extends GetView<AdvanceSearchController> {
  const AdvanceSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF000000) : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Search bar ─────────────────────────────────────────────
            _buildSearchBar(context, isDark),

            // ── Divider below search bar ──────────────────────────────
            Divider(
              height: 1,
              thickness: 0.5,
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
            ),

            // ── Main content area ──────────────────────────────────────
            Expanded(
              child: Obx(() {
                // Before any search: show history/suggestions as main content
                if (!controller.hasSearched.value) {
                  return const SearchSuggestionList();
                }

                // After search: show tabs + results, with suggestions overlay
                return Column(
                  children: [
                    _buildTabBar(context, isDark, primaryColor),
                    Expanded(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Tab content
                          TabBarView(
                            controller: controller.tabController,
                            children: const [
                              AllResultsTab(),
                              PeopleTab(),
                              ReelsTab(),
                              GroupsTab(),
                              PagesTab(),
                              EventsTab(),
                              MarketplaceTab(),
                            ],
                          ),

                          // Suggestions overlay when refocused
                          Obx(() {
                            if (!controller.showSuggestions.value) {
                              return const SizedBox.shrink();
                            }
                            return GestureDetector(
                              onTap: () => controller.dismissSuggestions(),
                              behavior: HitTestBehavior.opaque,
                              child: const SearchSuggestionList(),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Search Bar (Facebook-style rounded pill) ─────────────────────────

  Widget _buildSearchBar(BuildContext context, bool isDark) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Get.back(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                Icons.arrow_back,
                size: 24,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),

          // Search TextField — fully rounded pill
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFEFEFF0),
                borderRadius: BorderRadius.circular(22),
              ),
              child: TextField(
                controller: controller.searchController,
                focusNode: controller.searchFocusNode,
                textInputAction: TextInputAction.search,
                onSubmitted: (value) => controller.executeSearch(value.trim()),
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: 'Search QP...',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: Icon(
                      Icons.search,
                      size: 20,
                      color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(minWidth: 36, minHeight: 20),
                  suffixIcon: Obx(() {
                    if (controller.query.value.isEmpty) return const SizedBox.shrink();
                    return GestureDetector(
                      onTap: () {
                        controller.searchController.clear();
                        controller.searchFocusNode.requestFocus();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                      ),
                    );
                  }),
                  suffixIconConstraints: const BoxConstraints(minWidth: 30, minHeight: 20),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  isDense: true,
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),
        ],
      ),
    );
  }

  // ─── Tab Bar (scrollable pills) ───────────────────────────────────────

  Widget _buildTabBar(BuildContext context, bool isDark, Color primaryColor) {
    return Container(
      height: 48,
      color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
      child: TabBar(
        controller: controller.tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        labelPadding: const EdgeInsets.symmetric(horizontal: 6),
        indicatorColor: Colors.transparent,
        dividerColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        indicator: const BoxDecoration(),
        tabs: SearchTab.values.map((tab) {
          final idx = SearchTab.values.indexOf(tab);
          return Tab(
            height: 36,
            child: AnimatedBuilder(
              animation: controller.tabController,
              builder: (context, _) {
                final isSelected = controller.tabController.index == idx;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? primaryColor
                        : (isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF0F2F5)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tab.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Colors.grey.shade300 : Colors.grey.shade700),
                    ),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
