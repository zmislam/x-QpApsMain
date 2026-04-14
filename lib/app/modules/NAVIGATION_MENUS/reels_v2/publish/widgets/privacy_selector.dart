import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Privacy selector — Public / Friends Only / Private.
class PrivacySelector extends StatelessWidget {
  final RxString privacy;

  const PrivacySelector({super.key, required this.privacy});

  static const _options = [
    {'value': 'public', 'label': 'Public', 'icon': Icons.public, 'desc': 'Anyone can see this reel'},
    {'value': 'friends', 'label': 'Friends Only', 'icon': Icons.people, 'desc': 'Only your friends can see'},
    {'value': 'private', 'label': 'Private', 'icon': Icons.lock, 'desc': 'Only you can see'},
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(_iconForPrivacy(privacy.value)),
          title: const Text('Who can see this'),
          subtitle: Text(_labelForPrivacy(privacy.value)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showPicker(context),
        ));
  }

  IconData _iconForPrivacy(String value) {
    switch (value) {
      case 'friends':
        return Icons.people;
      case 'private':
        return Icons.lock;
      default:
        return Icons.public;
    }
  }

  String _labelForPrivacy(String value) {
    switch (value) {
      case 'friends':
        return 'Friends Only';
      case 'private':
        return 'Private';
      default:
        return 'Public';
    }
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Who can see this reel?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            ..._options.map((opt) => Obx(() => RadioListTile<String>(
                  value: opt['value'] as String,
                  groupValue: privacy.value,
                  onChanged: (v) {
                    if (v != null) privacy.value = v;
                    Navigator.pop(ctx);
                  },
                  secondary: Icon(opt['icon'] as IconData),
                  title: Text(opt['label'] as String),
                  subtitle: Text(opt['desc'] as String),
                ))),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
