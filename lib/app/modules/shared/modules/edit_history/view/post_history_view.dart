import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../components/image.dart';
import '../../../../../config/constants/feed_design_tokens.dart';
import '../../../../../data/post_background.dart';
import '../../../../../extension/string/string_image_path.dart';
import '../../../../../utils/image_utils.dart';
import '../controller/post_history_controller.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Post Edit History — Facebook-style timeline view
// ─────────────────────────────────────────────────────────────────────────────
class PostHistoryView extends GetView<PostHistoryController> {
  const PostHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: FeedDesignTokens.surfaceBg(context),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0.5,
        backgroundColor: FeedDesignTokens.cardBg(context),
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: FeedDesignTokens.textPrimary(context)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Edit History'.tr,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: FeedDesignTokens.textPrimary(context),
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Divider(
              height: 0.5, thickness: 0.5, color: FeedDesignTokens.divider(context)),
        ),
      ),
      body: Obx(() {
        // ── Loading ──
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }

        // ── Error ──
        if (controller.hasError.value) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline,
                      size: 48, color: FeedDesignTokens.textSecondary(context)),
                  const SizedBox(height: 12),
                  Text(
                    controller.errorMessage.value,
                    style: TextStyle(
                      fontSize: 15,
                      color: FeedDesignTokens.textSecondary(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: controller.refreshHistory,
                    child: Text('Retry'.tr,
                        style: TextStyle(
                            color: FeedDesignTokens.brand(context),
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          );
        }

        // ── Empty ──
        if (controller.entries.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.history,
                    size: 48, color: FeedDesignTokens.textSecondary(context)),
                const SizedBox(height: 12),
                Text(
                  'No edit history found'.tr,
                  style: TextStyle(
                    fontSize: 15,
                    color: FeedDesignTokens.textSecondary(context),
                  ),
                ),
              ],
            ),
          );
        }

        // ── List ──
        final entries = controller.entries;
        return RefreshIndicator(
          onRefresh: controller.refreshHistory,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: entries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final entry = entries[index];
              final isOriginal = index == entries.length - 1;
              return _HistoryCard(
                entry: entry,
                isOriginal: isOriginal,
                isDark: isDark,
              );
            },
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Single history entry card
// ─────────────────────────────────────────────────────────────────────────────
class _HistoryCard extends StatelessWidget {
  const _HistoryCard({
    required this.entry,
    required this.isOriginal,
    required this.isDark,
  });

  final EditHistoryEntry entry;
  final bool isOriginal;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('MMM d, yyyy · h:mm a').format(entry.createdAt.toLocal());
    final hasMedia = entry.postMedia.isNotEmpty;
    final hasBgColor = entry.postBackgroundColor != null &&
        entry.postBackgroundColor!.isNotEmpty;
    final hasDescription = entry.description != null &&
        entry.description!.trim().isNotEmpty;
    final hasFeeling = entry.feelingName != null;
    final hasActivity = entry.activityName != null;
    final hasLocation = entry.locationName != null &&
        entry.locationName!.isNotEmpty;

    return Container(
      color: FeedDesignTokens.cardBg(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: label + timestamp ──
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: FeedDesignTokens.cardPaddingH, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: FeedDesignTokens.divider(context), width: 0.5),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isOriginal
                        ? FeedDesignTokens.brand(context).withValues(alpha: 0.1)
                        : FeedDesignTokens.inputBg(context),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isOriginal ? 'Original'.tr : 'Edited'.tr,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isOriginal
                          ? FeedDesignTokens.brand(context)
                          : FeedDesignTokens.textSecondary(context),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    dateStr,
                    style: TextStyle(
                      fontSize: FeedDesignTokens.timeSize,
                      color: FeedDesignTokens.textSecondary(context),
                    ),
                  ),
                ),
                // Privacy icon
                if (entry.postPrivacy != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Icon(
                      _privacyIcon(entry.postPrivacy!),
                      size: 14,
                      color: FeedDesignTokens.textSecondary(context),
                    ),
                  ),
              ],
            ),
          ),

          // ── Feeling / Activity / Location metadata ──
          if (hasFeeling || hasActivity || hasLocation)
            Padding(
              padding: const EdgeInsets.only(
                left: FeedDesignTokens.cardPaddingH,
                right: FeedDesignTokens.cardPaddingH,
                top: 10,
              ),
              child: Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  if (hasFeeling)
                    _MetaChip(
                      icon: Icons.emoji_emotions_outlined,
                      label: entry.feelingName!,
                      context: context,
                    ),
                  if (hasActivity)
                    _MetaChip(
                      icon: Icons.local_activity_outlined,
                      label: entry.activityName!,
                      context: context,
                    ),
                  if (hasLocation)
                    _MetaChip(
                      icon: Icons.location_on_outlined,
                      label: entry.locationName!,
                      context: context,
                    ),
                ],
              ),
            ),

          // ── Description ──
          if (hasDescription && !hasBgColor)
            Padding(
              padding: EdgeInsets.only(
                left: FeedDesignTokens.cardPaddingH,
                right: FeedDesignTokens.cardPaddingH,
                top: 10,
                bottom: hasMedia ? 10 : 14,
              ),
              child: Text(
                entry.description!,
                style: TextStyle(
                  fontSize: FeedDesignTokens.bodyTextSize,
                  color: FeedDesignTokens.textPrimary(context),
                  height: 1.35,
                ),
              ),
            ),

          // ── Background-color description ──
          if (hasDescription && hasBgColor)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              decoration: PostBackground.decorationFromStoredValue(entry.postBackgroundColor),
              child: Text(
                entry.description!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: PostBackground.textColorFromStoredValue(entry.postBackgroundColor),
                  height: 1.4,
                ),
              ),
            ),

          // ── Media thumbnails ──
          if (hasMedia)
            Padding(
              padding: EdgeInsets.only(
                left: FeedDesignTokens.cardPaddingH,
                right: FeedDesignTokens.cardPaddingH,
                top: hasDescription && !hasBgColor ? 0 : 10,
                bottom: 14,
              ),
              child: SizedBox(
                height: 72,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: entry.postMedia.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 6),
                  itemBuilder: (context, i) {
                    final mediaFilename =
                        entry.postMedia[i]['media']?.toString() ?? '';
                    if (mediaFilename.isEmpty) return const SizedBox.shrink();

                    final url = mediaFilename.formatedPostUrl;
                    final isImage = isImageUrl(url);

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 72,
                        height: 72,
                        color: FeedDesignTokens.inputBg(context),
                        child: isImage
                            ? RoundCornerNetworkImage(
                                height: 72,
                                width: 72,
                                imageUrl: url,
                              )
                            : Center(
                                child: Icon(
                                  Icons.videocam_rounded,
                                  size: 28,
                                  color:
                                      FeedDesignTokens.textSecondary(context),
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ),
            ),

          // ── No description and no media = empty edit (e.g. privacy only) ──
          if (!hasDescription && !hasMedia && !hasBgColor)
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: FeedDesignTokens.cardPaddingH, vertical: 14),
              child: Text(
                'No text content'.tr,
                style: TextStyle(
                  fontSize: FeedDesignTokens.bodyTextSize,
                  color: FeedDesignTokens.textSecondary(context),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  IconData _privacyIcon(String privacy) {
    switch (privacy) {
      case 'public':
        return Icons.public;
      case 'only_me':
        return Icons.lock;
      case 'friends':
        return Icons.people;
      default:
        return Icons.public;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Small metadata chip (feeling / activity / location)
// ─────────────────────────────────────────────────────────────────────────────
class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
    required this.context,
  });

  final IconData icon;
  final String label;
  final BuildContext context;

  @override
  Widget build(BuildContext _) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: FeedDesignTokens.inputBg(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: FeedDesignTokens.textSecondary(context)),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: FeedDesignTokens.textSecondary(context),
            ),
          ),
        ],
      ),
    );
  }
}

