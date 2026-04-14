import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../earnDashboard/services/earning_config_service.dart';

/// Reusable creator tier badge - all tier names/multipliers from EarningConfigService.userTiers
class CreatorTierBadge extends StatelessWidget {
  final String tierName;
  final double multiplier;
  final String size; // 'small' | 'medium' | 'large'

  const CreatorTierBadge({
    super.key,
    required this.tierName,
    required this.multiplier,
    this.size = 'small',
  });

  @override
  Widget build(BuildContext context) {
    final color = _colorForTier(tierName);
    final double fontSize;
    final double iconSize;
    final EdgeInsets padding;

    switch (size) {
      case 'large':
        fontSize = 14;
        iconSize = 20;
        padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 7);
        break;
      case 'medium':
        fontSize = 12;
        iconSize = 16;
        padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 5);
        break;
      default:
        fontSize = 10;
        iconSize = 12;
        padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 2);
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.emoji_events, size: iconSize, color: color),
          const SizedBox(width: 3),
          Text('$tierName ${multiplier.toStringAsFixed(1)}x',
              style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w700,
                  color: color)),
        ],
      ),
    );
  }

  /// Map tier key/name to color — admin can change names so match broadly
  Color _colorForTier(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('elite') || lower.contains('premium') || lower.contains('gold')) {
      return const Color(0xFFFFB300); // gold
    } else if (lower.contains('pro') || lower.contains('platinum')) {
      return Colors.purple;
    } else if (lower.contains('rising') || lower.contains('growth')) {
      return Colors.blue;
    }
    return Colors.grey.shade600; // starter/basic
  }
}
