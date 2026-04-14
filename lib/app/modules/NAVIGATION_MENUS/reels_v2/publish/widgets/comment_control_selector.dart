import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Comment control selector — Everyone / Friends / Off.
class CommentControlSelector extends StatelessWidget {
  final RxString commentPermission;

  const CommentControlSelector({super.key, required this.commentPermission});

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.comment_outlined),
          title: const Text('Allow comments'),
          subtitle: Text(_labelFor(commentPermission.value)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showPicker(context),
        ));
  }

  String _labelFor(String value) {
    switch (value) {
      case 'friends':
        return 'Friends Only';
      case 'off':
        return 'Off';
      default:
        return 'Everyone';
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
              child: Text('Who can comment?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            ...['everyone', 'friends', 'off'].map((opt) => Obx(
                  () => RadioListTile<String>(
                    value: opt,
                    groupValue: commentPermission.value,
                    onChanged: (v) {
                      if (v != null) commentPermission.value = v;
                      Navigator.pop(ctx);
                    },
                    title: Text(_labelFor(opt)),
                    secondary: Icon(
                      opt == 'everyone'
                          ? Icons.public
                          : opt == 'friends'
                              ? Icons.people
                              : Icons.comments_disabled,
                    ),
                  ),
                )),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
