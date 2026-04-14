import 'package:flutter/material.dart';

/// Three-dot menu for sponsored reel actions:
/// - Hide Ad
/// - Not Interested
/// - Report Ad
/// - Why this ad?
class AdFeedbackMenu extends StatelessWidget {
  final VoidCallback onHideAd;
  final VoidCallback onNotInterested;
  final VoidCallback onReportAd;
  final VoidCallback onWhyThisAd;

  const AdFeedbackMenu({
    super.key,
    required this.onHideAd,
    required this.onNotInterested,
    required this.onReportAd,
    required this.onWhyThisAd,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.more_horiz, color: Colors.white, size: 20),
      ),
      color: Theme.of(context).cardTheme.color ?? Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      offset: const Offset(-10, 40),
      onSelected: (value) {
        switch (value) {
          case 'hide':
            onHideAd();
            break;
          case 'not_interested':
            onNotInterested();
            break;
          case 'report':
            onReportAd();
            break;
          case 'why':
            onWhyThisAd();
            break;
        }
      },
      itemBuilder: (_) => [
        _buildItem(
          value: 'hide',
          icon: Icons.visibility_off_outlined,
          label: 'Hide Ad',
        ),
        _buildItem(
          value: 'not_interested',
          icon: Icons.not_interested_outlined,
          label: 'Not Interested',
        ),
        const PopupMenuDivider(),
        _buildItem(
          value: 'why',
          icon: Icons.info_outline,
          label: 'Why this ad?',
        ),
        _buildItem(
          value: 'report',
          icon: Icons.flag_outlined,
          label: 'Report Ad',
          isDestructive: true,
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildItem({
    required String value,
    required IconData icon,
    required String label,
    bool isDestructive = false,
  }) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isDestructive ? Colors.red[400] : null,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isDestructive ? Colors.red[400] : null,
            ),
          ),
        ],
      ),
    );
  }
}
