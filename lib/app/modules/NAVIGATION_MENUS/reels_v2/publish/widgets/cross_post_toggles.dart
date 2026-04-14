import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Cross-post toggles: Feed toggle + Stories toggle.
class CrossPostToggles extends StatelessWidget {
  final RxBool postToFeed;
  final RxBool postToStories;

  const CrossPostToggles({
    super.key,
    required this.postToFeed,
    required this.postToStories,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Text(
            'Also share to',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
        Obx(() => SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: const Icon(Icons.dynamic_feed_outlined),
              title: const Text('Post to Feed'),
              subtitle: const Text('Show on your profile feed'),
              value: postToFeed.value,
              onChanged: (v) => postToFeed.value = v,
            )),
        Obx(() => SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: const Icon(Icons.amp_stories_outlined),
              title: const Text('Share to Stories'),
              subtitle: const Text('Preview clip in your story'),
              value: postToStories.value,
              onChanged: (v) => postToStories.value = v,
            )),
      ],
    );
  }
}
