// =============================================================================
// Search Suggestion List — Shows history, suggestions, trending
// =============================================================================
// Facebook-style initial screen:
//   "Recent" header + "See all"  → list of recent items
//   Each item: clock-circle / profile pic + text + "..." menu
// =============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/constants/api_constant.dart';
import '../../controllers/advance_search_controller.dart';

class SearchSuggestionList extends GetView<AdvanceSearchController> {
  const SearchSuggestionList({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final query = controller.query.value;
      final hasQuery = query.isNotEmpty;

      return Material(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // ── Suggestions (when typing) ────────────────────────────────
            if (hasQuery) ...[
              if (controller.loadingSuggestions.value)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                )
              else ...[
                // Search query item at top
                _buildQueryItem(context, query, isDark),

                // Suggestion items
                for (final s in controller.suggestions)
                  _buildSuggestionItem(context, s, isDark),
              ],
            ],

            // ── Recent Searches (when empty / initial state) ─────────────
            if (!hasQuery && controller.recentSearches.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.clearAllHistory(),
                      child: Text(
                        'See all',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              for (final h in controller.recentSearches)
                _buildHistoryItem(context, h, isDark),
            ],

            // ── Trending Searches ────────────────────────────────────────
            if (!hasQuery && controller.trendingSearches.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
                child: Text(
                  'Trending',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              for (final t in controller.trendingSearches)
                _buildTrendingItem(context, t, isDark),
            ],

            // ── Empty state when nothing loaded yet ──────────────────────
            if (!hasQuery &&
                controller.recentSearches.isEmpty &&
                controller.trendingSearches.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
                child: Center(
                  child: Text(
                    'Search for people, groups, pages, reels and more',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade500,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }

  // ─── Build individual items ─────────────────────────────────────────────

  Widget _buildQueryItem(BuildContext context, String query, bool isDark) {
    return InkWell(
      onTap: () => controller.executeSearch(query),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // Search icon in circle
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF3A3A3C) : const Color(0xFFE4E6EB),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search,
                size: 18,
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                query,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionItem(BuildContext context, dynamic s, bool isDark) {
    final primaryColor = Theme.of(context).primaryColor;

    Widget leadingWidget;

    if (s.avatar != null && s.avatar.toString().isNotEmpty) {
      leadingWidget = CircleAvatar(
        radius: 18,
        backgroundImage: NetworkImage(
          s.avatar.toString().startsWith('http')
              ? s.avatar.toString()
              : '${ApiConstant.SERVER_IP_PORT}/${s.avatar}',
        ),
      );
    } else {
      IconData iconData;
      switch (s.type) {
        case 'user':
          iconData = Icons.person;
          break;
        case 'page':
          iconData = Icons.flag;
          break;
        case 'group':
          iconData = Icons.group;
          break;
        default:
          iconData = Icons.search;
      }
      leadingWidget = Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF3A3A3C) : const Color(0xFFE4E6EB),
          shape: BoxShape.circle,
        ),
        child: Icon(iconData, size: 18, color: isDark ? Colors.grey.shade300 : Colors.grey.shade700),
      );
    }

    return InkWell(
      onTap: () => controller.onTapSuggestion(s),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            leadingWidget,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          s.text,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (s.verified == true) ...[
                        const SizedBox(width: 4),
                        Icon(Icons.verified, size: 14, color: primaryColor),
                      ],
                    ],
                  ),
                  if (s.subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        s.subtitle,
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Facebook-style history row: clock-circle icon | text | "..." menu
  Widget _buildHistoryItem(BuildContext context, dynamic h, bool isDark) {
    return InkWell(
      onTap: () => controller.onTapHistoryItem(h),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // Clock icon in grey circle (like Facebook)
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF3A3A3C) : const Color(0xFFE4E6EB),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.access_time,
                size: 18,
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
              ),
            ),
            const SizedBox(width: 12),
            // Query text
            Expanded(
              child: Text(
                h.query,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // "..." menu button (like Facebook)
            GestureDetector(
              onTap: () => _showHistoryItemMenu(context, h, isDark),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.more_horiz,
                  size: 20,
                  color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingItem(BuildContext context, dynamic t, bool isDark) {
    return InkWell(
      onTap: () => controller.onTapTrending(t),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF3A3A3C) : const Color(0xFFE4E6EB),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.trending_up,
                size: 18,
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                t.query,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Bottom sheet menu for a history item (delete option)
  void _showHistoryItemMenu(BuildContext context, dynamic h, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF2C2C2E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Icon(
                Icons.delete_outline,
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
              ),
              title: Text(
                'Remove this search',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                controller.deleteHistoryItem(h);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
