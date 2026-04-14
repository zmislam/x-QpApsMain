import 'package:flutter/material.dart';

/// Pre-viral / rising indicator badge — subtle orange badge
/// for content that's approaching viral thresholds.
/// Label comes from API/config — NEVER hardcoded.
class RisingBadge extends StatelessWidget {
  final String label;
  final double score;

  const RisingBadge({
    super.key,
    required this.label,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange.shade200, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.trending_up, size: 12, color: Colors.orange.shade700),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.orange.shade800,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '${score.toStringAsFixed(0)}%',
            style: TextStyle(
              color: Colors.orange.shade600,
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
