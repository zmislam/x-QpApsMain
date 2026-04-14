import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../models/reel_v2_model.dart';
import '../../services/reels_v2_api_service.dart';

/// Share sheet for reels — DM, Stories, Feed, Copy Link, WhatsApp, More.
class ReelShareSheet extends StatelessWidget {
  final ReelV2Model reel;

  const ReelShareSheet({super.key, required this.reel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Share to',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const Divider(color: Colors.white12, height: 1),

          // Share options grid
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ShareOption(
                  icon: Icons.send_rounded,
                  label: 'DM',
                  color: const Color(0xFF1DA1F2),
                  onTap: () => _shareToDM(context),
                ),
                _ShareOption(
                  icon: Icons.add_circle_outline,
                  label: 'Stories',
                  color: const Color(0xFFE1306C),
                  onTap: () => _shareToStories(context),
                ),
                _ShareOption(
                  icon: Icons.feed_outlined,
                  label: 'Feed',
                  color: const Color(0xFF4CAF50),
                  onTap: () => _shareToFeed(context),
                ),
                _ShareOption(
                  icon: Icons.link,
                  label: 'Copy Link',
                  color: Colors.grey,
                  onTap: () => _copyLink(context),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ShareOption(
                  icon: Icons.chat,
                  label: 'WhatsApp',
                  color: const Color(0xFF25D366),
                  onTap: () => _shareToWhatsApp(context),
                ),
                _ShareOption(
                  icon: Icons.share_outlined,
                  label: 'More',
                  color: Colors.blueGrey,
                  onTap: () => _shareMore(context),
                ),
                const SizedBox(width: 60), // spacer
                const SizedBox(width: 60), // spacer
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Report / Not Interested
          const Divider(color: Colors.white12, height: 1),
          ListTile(
            leading: const Icon(Icons.not_interested, color: Colors.white54),
            title: const Text('Not interested',
                style: TextStyle(color: Colors.white70, fontSize: 14)),
            onTap: () {
              Navigator.pop(context);
              final api = Get.find<ReelsV2ApiService>();
              api.notInterested(reel.id ?? '');
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.white54),
            title: const Text('Why am I seeing this?',
                style: TextStyle(color: Colors.white70, fontSize: 14)),
            onTap: () => Navigator.pop(context),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }

  void _shareToDM(BuildContext context) {
    Navigator.pop(context);
    _trackShare('dm');
  }

  void _shareToStories(BuildContext context) {
    Navigator.pop(context);
    _trackShare('story');
  }

  void _shareToFeed(BuildContext context) {
    Navigator.pop(context);
    _trackShare('feed');
  }

  void _copyLink(BuildContext context) {
    final link = 'https://qposs.com/reel/${reel.id}';
    Clipboard.setData(ClipboardData(text: link));
    Navigator.pop(context);
    Get.snackbar(
      'Link copied',
      'Reel link copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white12,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
    _trackShare('copy_link');
  }

  void _shareToWhatsApp(BuildContext context) {
    Navigator.pop(context);
    _trackShare('whatsapp');
  }

  void _shareMore(BuildContext context) {
    Navigator.pop(context);
    _trackShare('system');
  }

  void _trackShare(String platform) {
    try {
      final api = Get.find<ReelsV2ApiService>();
      api.shareReel(reel.id ?? '', {'platform': platform});
    } catch (_) {}
  }
}

class _ShareOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ShareOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
