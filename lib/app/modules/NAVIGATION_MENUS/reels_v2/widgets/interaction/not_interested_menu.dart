import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/reel_v2_model.dart';
import '../../services/reels_v2_api_service.dart';

/// Not interested menu — "Not interested" + "Why am I seeing this?"
/// Also includes report with category selection.
class NotInterestedMenu extends StatelessWidget {
  final ReelV2Model reel;

  const NotInterestedMenu({super.key, required this.reel});

  static void show(BuildContext context, ReelV2Model reel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => NotInterestedMenu(reel: reel),
    );
  }

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
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 8),

          _MenuItem(
            icon: Icons.not_interested,
            label: 'Not interested',
            subtitle: 'See fewer reels like this',
            onTap: () {
              Navigator.pop(context);
              _handleNotInterested();
            },
          ),

          _MenuItem(
            icon: Icons.visibility_off_outlined,
            label: 'Hide reels from this creator',
            onTap: () {
              Navigator.pop(context);
              _handleHideCreator();
            },
          ),

          const Divider(color: Colors.white12, height: 1),

          _MenuItem(
            icon: Icons.info_outline,
            label: 'Why am I seeing this?',
            onTap: () {
              Navigator.pop(context);
              _showWhySheet(context);
            },
          ),

          _MenuItem(
            icon: Icons.flag_outlined,
            label: 'Report',
            color: Colors.red[400],
            onTap: () {
              Navigator.pop(context);
              _showReportSheet(context);
            },
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }

  void _handleNotInterested() {
    try {
      final api = Get.find<ReelsV2ApiService>();
      api.notInterested(reel.id ?? '');
      Get.snackbar(
        'Got it',
        'We\'ll show you fewer reels like this',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white12,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (_) {}
  }

  void _handleHideCreator() {
    try {
      final api = Get.find<ReelsV2ApiService>();
      api.notInterested(reel.id ?? '');
      Get.snackbar(
        'Creator hidden',
        'You won\'t see reels from this creator',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white12,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (_) {}
  }

  void _showWhySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Why you\'re seeing this reel',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.trending_up,
              text: 'This reel is popular in your region',
            ),
            _InfoRow(
              icon: Icons.favorite_border,
              text: 'Based on reels you\'ve liked and watched',
            ),
            _InfoRow(
              icon: Icons.people_outline,
              text: 'People you follow interact with this creator',
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Got it'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReportSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _ReportSheet(reelId: reel.id ?? ''),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Color? color;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.subtitle,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.white70, size: 22),
      title: Text(
        label,
        style: TextStyle(
          color: color ?? Colors.white,
          fontSize: 14,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: const TextStyle(color: Colors.white38, fontSize: 12),
            )
          : null,
      onTap: onTap,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.white54, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportSheet extends StatefulWidget {
  final String reelId;
  const _ReportSheet({required this.reelId});

  @override
  State<_ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends State<_ReportSheet> {
  String? _selected;
  bool _submitting = false;

  static const _categories = [
    'Spam',
    'Nudity or sexual activity',
    'Hate speech or symbols',
    'Violence or dangerous organizations',
    'Bullying or harassment',
    'Intellectual property violation',
    'Scam or fraud',
    'False information',
    'Other',
  ];

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
            padding: EdgeInsets.all(16),
            child: Text(
              'Report this reel',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(color: Colors.white12, height: 1),

          ..._categories.map((cat) => RadioListTile<String>(
                value: cat,
                groupValue: _selected,
                onChanged: (v) => setState(() => _selected = v),
                title: Text(
                  cat,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                activeColor: Colors.blue,
              )),

          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selected == null || _submitting
                    ? null
                    : _submitReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                  disabledBackgroundColor: Colors.grey[800],
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Submit Report',
                        style: TextStyle(color: Colors.white)),
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }

  Future<void> _submitReport() async {
    setState(() => _submitting = true);
    try {
      final api = Get.find<ReelsV2ApiService>();
      await api.reportReel(widget.reelId, {'reason': _selected});
      if (mounted) Navigator.pop(context);
      Get.snackbar(
        'Report submitted',
        'Thank you for helping keep the community safe',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white12,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (_) {
      setState(() => _submitting = false);
    }
  }
}
