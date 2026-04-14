import 'package:flutter/material.dart';

/// Reusable supporter badge — bronze, silver, gold, diamond.
/// Badge level comes from API — not hardcoded.
class SupporterBadge extends StatelessWidget {
  final String level; // 'bronze', 'silver', 'gold', 'diamond'

  const SupporterBadge({super.key, required this.level});

  Color get _color {
    switch (level) {
      case 'diamond':
        return Colors.cyan;
      case 'gold':
        return Colors.amber;
      case 'silver':
        return Colors.blueGrey;
      case 'bronze':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  String get _icon {
    switch (level) {
      case 'diamond':
        return '💎';
      case 'gold':
        return '🥇';
      case 'silver':
        return '🥈';
      case 'bronze':
        return '🥉';
      default:
        return '⭐';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _color.withOpacity(0.3), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_icon, style: const TextStyle(fontSize: 10)),
          const SizedBox(width: 3),
          Text(
            level[0].toUpperCase() + level.substring(1),
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: _color,
            ),
          ),
        ],
      ),
    );
  }
}
