import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quantum_possibilities_flutter/app/config/constants/color.dart';

/// The three available comment sort modes.
enum CommentSortMode {
  mostRelevant,
  newest,
  allComments,
}

/// Human-readable label for each sort mode.
String commentSortLabel(CommentSortMode mode) {
  switch (mode) {
    case CommentSortMode.mostRelevant:
      return 'Most relevant';
    case CommentSortMode.newest:
      return 'Newest';
    case CommentSortMode.allComments:
      return 'All comments';
  }
}

/// Description shown under each option in the bottom sheet.
String commentSortDescription(CommentSortMode mode) {
  switch (mode) {
    case CommentSortMode.mostRelevant:
      return 'Show the most engaging comments first, including from friends.';
    case CommentSortMode.newest:
      return 'Show all comments, with the newest comments first.';
    case CommentSortMode.allComments:
      return 'Show all comments, including potential spam.';
  }
}

/// Icon for each sort mode.
IconData commentSortIcon(CommentSortMode mode) {
  switch (mode) {
    case CommentSortMode.mostRelevant:
      return Icons.auto_awesome;
    case CommentSortMode.newest:
      return Icons.schedule;
    case CommentSortMode.allComments:
      return Icons.forum_outlined;
  }
}

/// A bottom sheet that lets the user pick a comment sort mode.
///
/// Usage:
/// ```dart
/// final result = await CommentSortBottomSheet.show(context, currentMode);
/// if (result != null) { /* update sort */ }
/// ```
class CommentSortBottomSheet extends StatelessWidget {
  final CommentSortMode currentMode;

  const CommentSortBottomSheet({super.key, required this.currentMode});

  /// Show the bottom sheet and return the selected [CommentSortMode] or null.
  static Future<CommentSortMode?> show(
    BuildContext context,
    CommentSortMode currentMode,
  ) {
    return showModalBottomSheet<CommentSortMode>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => CommentSortBottomSheet(currentMode: currentMode),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF242526) : Colors.white;
    final headerColor = isDark ? const Color(0xFFE4E6EB) : const Color(0xFF050505);
    final labelColor = isDark ? const Color(0xFFE4E6EB) : const Color(0xFF050505);
    final descColor = isDark ? const Color(0xFFB0B3B8) : const Color(0xFF65676B);
    final dividerColor = isDark ? const Color(0xFF3E4042) : const Color(0xFFE4E6EB);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Drag handle ──
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
              child: Row(
                children: [
                  Text(
                    'Sort comments by'.tr,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: headerColor,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: dividerColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: labelColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Divider(color: dividerColor, height: 1),

            const SizedBox(height: 8),

            // ── Options ──
            ...CommentSortMode.values.map((mode) {
              final isSelected = mode == currentMode;
              return _SortOptionTile(
                mode: mode,
                isSelected: isSelected,
                labelColor: labelColor,
                descColor: descColor,
                onTap: () => Navigator.pop(context, mode),
              );
            }),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _SortOptionTile extends StatelessWidget {
  final CommentSortMode mode;
  final bool isSelected;
  final Color labelColor;
  final Color descColor;
  final VoidCallback onTap;

  const _SortOptionTile({
    required this.mode,
    required this.isSelected,
    required this.labelColor,
    required this.descColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: isSelected
            ? BoxDecoration(
                color: isDark
                    ? const Color(0xFF3A3B3C)
                    : const Color(0xFFF0F2F5),
                border: Border(
                  left: BorderSide(
                    color: PRIMARY_COLOR,
                    width: 3,
                  ),
                ),
              )
            : null,
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? PRIMARY_COLOR.withOpacity(0.12)
                    : (isDark
                        ? const Color(0xFF3A3B3C)
                        : const Color(0xFFF0F2F5)),
                shape: BoxShape.circle,
              ),
              child: Icon(
                commentSortIcon(mode),
                size: 20,
                color: isSelected ? PRIMARY_COLOR : descColor,
              ),
            ),
            const SizedBox(width: 14),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    commentSortLabel(mode),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: labelColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    commentSortDescription(mode),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: descColor,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            // Check icon
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: PRIMARY_COLOR,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}
