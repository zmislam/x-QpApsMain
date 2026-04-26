import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/constants/feed_design_tokens.dart';

/// Single-button feed mode switcher.
///
/// Tapping opens a popup with all available feed modes.
class FeedModeSwitcherButton extends StatelessWidget {
  const FeedModeSwitcherButton({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
    this.isLoading = false,
    this.compact = false,
  });

  final String currentMode;
  final ValueChanged<String> onModeChanged;
  final bool isLoading;
  final bool compact;

  static const List<_FeedModeOption> _modes = [
    _FeedModeOption(
      key: 'for_you',
      label: 'For You',
      icon: Icons.auto_awesome_rounded,
    ),
    _FeedModeOption(
      key: 'friends_first',
      label: 'Friends',
      icon: Icons.people_alt_rounded,
    ),
    _FeedModeOption(
      key: 'latest',
      label: 'Latest',
      icon: Icons.schedule_rounded,
    ),
  ];

  _FeedModeOption _resolveCurrentMode() {
    for (final mode in _modes) {
      if (mode.key == currentMode) {
        return mode;
      }
    }
    return _modes.first;
  }

  Color _modeAccent(BuildContext context, String modeKey) {
    switch (modeKey) {
      case 'friends_first':
        return const Color(0xFF2E9E61);
      case 'latest':
        return const Color(0xFFF2994A);
      case 'for_you':
      default:
        return FeedDesignTokens.brand(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeMode = _resolveCurrentMode();
    final modeAccent = _modeAccent(context, activeMode.key);

    final backgroundColor = compact
        ? modeAccent.withValues(alpha: 0.96)
        : FeedDesignTokens.cardBg(context);

    final borderColor = compact
        ? Colors.white.withValues(alpha: 0.35)
        : modeAccent.withValues(alpha: 0.25);

    return PopupMenuButton<String>(
      enabled: !isLoading,
      tooltip: 'Switch feed mode'.tr,
      onSelected: onModeChanged,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      itemBuilder: (context) {
        return _modes.map((mode) {
          final isSelected = mode.key == currentMode;
          final optionAccent = _modeAccent(context, mode.key);
          return PopupMenuItem<String>(
            value: mode.key,
            enabled: !isSelected && !isLoading,
            child: Row(
              children: [
                Icon(
                  mode.icon,
                  size: 18,
                  color: isSelected
                      ? optionAccent
                      : FeedDesignTokens.textSecondary(context),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    mode.label.tr,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: FeedDesignTokens.textPrimary(context),
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: optionAccent,
                  ),
              ],
            ),
          );
        }).toList();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        height: compact ? 34 : 36,
        width: compact ? 34 : 36,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(compact ? 17 : 19),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: compact ? 0.16 : 0.06),
              blurRadius: compact ? 10 : 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: compact
            ? Center(
                child: isLoading
                    ? SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.tune_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
              )
            : Center(
                child: isLoading
                    ? SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: modeAccent,
                        ),
                      )
                    : Icon(
                        Icons.tune_rounded,
                        size: 19,
                        color: modeAccent,
                      ),
              ),
      ),
    );
  }
}

class _FeedModeOption {
  const _FeedModeOption({
    required this.key,
    required this.label,
    required this.icon,
  });

  final String key;
  final String label;
  final IconData icon;
}
