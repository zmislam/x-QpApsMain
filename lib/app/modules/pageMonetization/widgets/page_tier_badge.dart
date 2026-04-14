import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/constants/color.dart';
import '../../earnDashboard/services/earning_config_service.dart';

/// Reusable page tier badge — sizes: small / medium / large
/// All tier names, multipliers from EarningConfigService.pageTiers (dynamic)
class PageTierBadge extends StatelessWidget {
  final String tierName;
  final double multiplier;
  final String size; // 'small' | 'medium' | 'large'

  const PageTierBadge({
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
        iconSize = 18;
        padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
        break;
      case 'medium':
        fontSize = 12;
        iconSize = 15;
        padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
        break;
      default: // small
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
          Icon(Icons.workspace_premium, size: iconSize, color: color),
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

  Color _colorForTier(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('premium') || lower.contains('elite') || lower.contains('gold')) {
      return const Color(0xFFFFB300); // amber/gold
    } else if (lower.contains('growth') || lower.contains('rising') || lower.contains('pro')) {
      return Colors.blue;
    }
    return Colors.grey.shade600; // basic
  }
}
