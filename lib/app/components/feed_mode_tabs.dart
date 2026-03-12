import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/constants/feed_design_tokens.dart';

/// Facebook-style feed mode tab bar: For You · Friends · Latest.
///
/// Displays a compact horizontal pill-style selector at the top of the feed.
/// Calls [onModeChanged] with 'for_you', 'friends_first', or 'latest'.
class FeedModeTabs extends StatelessWidget {
  const FeedModeTabs({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
  });

  final String currentMode;
  final ValueChanged<String> onModeChanged;

  static const _modes = [
    {'key': 'for_you', 'label': 'For You'},
    {'key': 'friends_first', 'label': 'Friends'},
    {'key': 'latest', 'label': 'Latest'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: FeedDesignTokens.cardBg(context),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: _modes.map((mode) {
          final isSelected = currentMode == mode['key'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _FeedModeChip(
              label: (mode['label'] as String).tr,
              isSelected: isSelected,
              isDark: isDark,
              onTap: () => onModeChanged(mode['key']!),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _FeedModeChip extends StatelessWidget {
  const _FeedModeChip({
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final selectedBg = FeedDesignTokens.brand(context);
    final unselectedBg = isDark
        ? const Color(0xFF3A3B3C)
        : const Color(0xFFE4E6EB);
    final selectedTextColor = Colors.white;
    final unselectedTextColor = FeedDesignTokens.textPrimary(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? selectedBg : unselectedBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? selectedTextColor : unselectedTextColor,
            ),
          ),
        ),
      ),
    );
  }
}
