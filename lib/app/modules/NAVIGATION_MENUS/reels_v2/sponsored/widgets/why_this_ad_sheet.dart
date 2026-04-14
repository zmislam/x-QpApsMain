import 'package:flutter/material.dart';

/// Bottom sheet explaining why a particular ad is being shown.
/// Displays targeting reason and interest categories.
class WhyThisAdSheet extends StatelessWidget {
  final String advertiserName;
  final String reason;
  final List<String> categories;

  const WhyThisAdSheet({
    super.key,
    required this.advertiserName,
    required this.reason,
    this.categories = const [],
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: isDark ? Colors.white70 : Colors.black87,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  'Why this ad?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Advertiser
            Text(
              'Ad by $advertiserName',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 12),

            // Reason
            Text(
              reason,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white60 : Colors.black54,
                height: 1.5,
              ),
            ),

            // Interest categories
            if (categories.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Based on your interests:',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: categories.map((cat) {
                  return Chip(
                    label: Text(
                      cat,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 20),

            // Manage settings link
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                // Navigate to ad preferences / privacy settings
              },
              child: Text(
                'Manage your ad preferences',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[600],
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
