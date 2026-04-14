import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/reels_v2_api_service.dart';

/// Placeholder save-to-collection bottom sheet.
/// Full implementation in Phase 9.
class SaveToCollectionSheet extends StatelessWidget {
  final String reelId;

  const SaveToCollectionSheet({super.key, required this.reelId});

  static void show(BuildContext context, String reelId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SaveToCollectionSheet(reelId: reelId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Save to collection',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),

          // Default save (no collection)
          ListTile(
            leading: const Icon(Icons.bookmark_border, color: Colors.white70),
            title: const Text('Save to default',
                style: TextStyle(color: Colors.white)),
            subtitle: const Text('Quick save without a collection',
                style: TextStyle(color: Colors.white38, fontSize: 12)),
            onTap: () {
              Navigator.pop(context);
              _save(null);
            },
          ),

          const Divider(color: Colors.white12),

          // Placeholder for future collection list (Phase 9)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Collections coming soon',
              style: TextStyle(color: Colors.white38, fontSize: 13),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }

  void _save(String? collectionId) {
    try {
      final api = Get.find<ReelsV2ApiService>();
      api.toggleBookmark(reelId, collectionId: collectionId);
      Get.snackbar(
        'Saved',
        'Reel saved to your bookmarks',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white12,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (_) {}
  }
}
