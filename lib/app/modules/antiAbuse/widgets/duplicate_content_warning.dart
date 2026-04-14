import 'package:flutter/material.dart';

/// Warning banner shown during post creation if duplicate content detected.
/// Message is dynamic from API response — not hardcoded.
class DuplicateContentWarning extends StatelessWidget {
  final String message;
  final double similarityScore;
  final VoidCallback? onDismiss;

  const DuplicateContentWarning({
    super.key,
    required this.message,
    required this.similarityScore,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.amber.shade200, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.content_copy, size: 20, color: Colors.amber.shade700),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.amber.shade900,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Similarity: ${(similarityScore * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.amber.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (onDismiss != null)
            GestureDetector(
              onTap: onDismiss,
              child: Icon(Icons.close,
                  size: 16, color: Colors.amber.shade400),
            ),
        ],
      ),
    );
  }
}
