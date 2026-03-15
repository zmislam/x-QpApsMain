import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/constants/color.dart';
import '../../../config/constants/feed_design_tokens.dart';
import '../../../extension/string/string_image_path.dart';
import '../../../routes/app_pages.dart';
import '../controllers/events_controller.dart';
import '../models/event_model.dart';

class EventsView extends GetView<EventsController> {
  const EventsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final cardBg = FeedDesignTokens.cardBg(context);
    final textPrimary = FeedDesignTokens.textPrimary(context);
    final textSecondary = FeedDesignTokens.textSecondary(context);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Events',
          style: TextStyle(
            color: textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add_box_outlined, color: textPrimary, size: 26),
            onPressed: () async {
              final result = await Get.toNamed(Routes.CREATE_EVENT);
              if (result == true) controller.refreshEvents();
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle_outlined,
                color: textPrimary, size: 26),
            onPressed: () {
              // My events / profile
            },
          ),
          IconButton(
            icon: Icon(Icons.search, color: textPrimary, size: 26),
            onPressed: () {
              // Search events
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ─── Tab bar ─────────────────────────────────────────────
          _buildTabBar(context, isDark, cardBg, textPrimary),
          // ─── Event list ──────────────────────────────────────────
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return _buildShimmerLoader(isDark);
              }
              if (controller.eventsList.isEmpty) {
                return _buildEmptyState(textSecondary);
              }
              return _buildEventList(
                  context, isDark, cardBg, textPrimary, textSecondary);
            }),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  TAB BAR — horizontal scrollable filter chips
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildTabBar(
      BuildContext context, bool isDark, Color cardBg, Color textPrimary) {
    return Container(
      color: cardBg,
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Obx(() {
        final selected = controller.selectedTabIndex.value;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              // City chip (only visible when Local is available)
              if (controller.selectedCity.value.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _CityChip(
                    city: controller.selectedCity.value,
                    onTap: () {
                      // Could open city picker
                    },
                  ),
                ),
              ...List.generate(controller.tabs.length, (i) {
                final isSelected = selected == i;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => controller.onTabChanged(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? PRIMARY_COLOR.withOpacity(0.12)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? PRIMARY_COLOR
                              : (isDark
                                  ? Colors.white24
                                  : Colors.grey.shade300),
                          width: 1.2,
                        ),
                      ),
                      child: Text(
                        controller.tabs[i],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? PRIMARY_COLOR : textPrimary,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  EVENT LIST
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildEventList(BuildContext context, bool isDark, Color cardBg,
      Color textPrimary, Color textSecondary) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scroll) {
        if (scroll is ScrollEndNotification &&
            scroll.metrics.pixels >= scroll.metrics.maxScrollExtent - 200) {
          controller.loadMore();
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: controller.refreshEvents,
        color: PRIMARY_COLOR,
        child: Obx(() {
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            itemCount: controller.eventsList.length +
                (controller.isLoadingMore.value ? 1 : 0) +
                1, // +1 for section header
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildSectionHeader(textPrimary);
              }
              final eventIndex = index - 1;
              if (eventIndex >= controller.eventsList.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: PRIMARY_COLOR),
                    ),
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _EventCard(
                  event: controller.eventsList[eventIndex],
                  isDark: isDark,
                  cardBg: cardBg,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  onInterested: () =>
                      controller.toggleInterested(eventIndex),
                  onShare: () {
                    // Share event
                  },
                  onMore: () {
                    // 3-dot menu
                  },
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildSectionHeader(Color textPrimary) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Obx(() => Text(
            controller.sectionTitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          )),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  SHIMMER LOADER
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildShimmerLoader(bool isDark) {
    final baseColor = isDark ? Colors.grey.shade800 : Colors.grey.shade200;
    final highlightColor =
        isDark ? Colors.grey.shade700 : Colors.grey.shade100;
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                // Image placeholder
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: highlightColor,
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 12,
                        width: 120,
                        decoration: BoxDecoration(
                          color: highlightColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 16,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: highlightColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 12,
                        width: 180,
                        decoration: BoxDecoration(
                          color: highlightColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: highlightColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  EMPTY STATE
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildEmptyState(Color textSecondary) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy_outlined, size: 64, color: textSecondary),
          const SizedBox(height: 16),
          Text(
            'No events found',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later or create your own event',
            style: TextStyle(fontSize: 14, color: textSecondary),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  EVENT CARD WIDGET
// ═══════════════════════════════════════════════════════════════════════════
class _EventCard extends StatelessWidget {
  final EventModel event;
  final bool isDark;
  final Color cardBg;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onInterested;
  final VoidCallback onShare;
  final VoidCallback onMore;

  const _EventCard({
    required this.event,
    required this.isDark,
    required this.cardBg,
    required this.textPrimary,
    required this.textSecondary,
    required this.onInterested,
    required this.onShare,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Cover image ───────────────────────────────────────
          _buildCoverImage(),
          // ─── Content ───────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date label
                Text(
                  event.dateLabel ?? event.formattedDateRange,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: event.dateLabel == 'Happening now'
                        ? Colors.red.shade600
                        : textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                // Title
                Text(
                  event.title ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (event.venueDisplay.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    event.venueDisplay,
                    style: TextStyle(
                      fontSize: 13,
                      color: textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (event.statsDisplay.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    event.statsDisplay,
                    style: TextStyle(fontSize: 13, color: textSecondary),
                  ),
                ],
                const SizedBox(height: 12),
                // ─── Action row ──────────────────────────────────
                Row(
                  children: [
                    // Interested button
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: OutlinedButton.icon(
                          onPressed: onInterested,
                          icon: Icon(
                            event.isInterested
                                ? Icons.star
                                : Icons.star_border,
                            size: 20,
                            color: event.isInterested
                                ? PRIMARY_COLOR
                                : textPrimary,
                          ),
                          label: Text(
                            'Interested',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: event.isInterested
                                  ? PRIMARY_COLOR
                                  : textPrimary,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: event.isInterested
                                  ? PRIMARY_COLOR
                                  : (isDark
                                      ? Colors.white24
                                      : Colors.grey.shade300),
                            ),
                            backgroundColor: event.isInterested
                                ? PRIMARY_COLOR.withOpacity(0.08)
                                : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Share button
                    SizedBox(
                      height: 40,
                      width: 48,
                      child: OutlinedButton(
                        onPressed: onShare,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          side: BorderSide(
                            color: isDark
                                ? Colors.white24
                                : Colors.grey.shade300,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Icon(
                          Icons.share_outlined,
                          size: 20,
                          color: textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverImage() {
    return Stack(
      children: [
        // Cover
        SizedBox(
          height: 200,
          width: double.infinity,
          child: event.coverImage != null && event.coverImage!.isNotEmpty
              ? Image.network(
                  event.coverImage!.formatedProfileUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _placeholderImage(),
                )
              : _placeholderImage(),
        ),
        // Organizer avatar (top left)
        if (event.organizer?.profilePic != null &&
            event.organizer!.profilePic!.isNotEmpty)
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(
                    event.organizer!.profilePic!.formatedProfileUrl,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        // 3-dot menu (top right)
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: onMore,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.black45,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.more_horiz, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _placeholderImage() {
    return Container(
      color: PRIMARY_COLOR.withOpacity(0.15),
      child: Center(
        child: Icon(
          Icons.event,
          size: 56,
          color: PRIMARY_COLOR.withOpacity(0.4),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  CITY CHIP (location indicator)
// ═══════════════════════════════════════════════════════════════════════════
class _CityChip extends StatelessWidget {
  final String city;
  final VoidCallback onTap;

  const _CityChip({required this.city, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? Colors.white10 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? Colors.white24 : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on,
                size: 16, color: isDark ? Colors.white70 : Colors.grey.shade700),
            const SizedBox(width: 4),
            Text(
              city,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
