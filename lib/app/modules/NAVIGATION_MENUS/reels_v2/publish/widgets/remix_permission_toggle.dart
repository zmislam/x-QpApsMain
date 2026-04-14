import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Toggle to allow/disable remixing of this reel.
class RemixPermissionToggle extends StatelessWidget {
  final RxBool allowRemix;

  const RemixPermissionToggle({super.key, required this.allowRemix});

  @override
  Widget build(BuildContext context) {
    return Obx(() => SwitchListTile(
          contentPadding: EdgeInsets.zero,
          secondary: const Icon(Icons.repeat_outlined),
          title: const Text('Allow Remix'),
          subtitle: const Text('Others can duet or stitch your reel'),
          value: allowRemix.value,
          onChanged: (v) => allowRemix.value = v,
        ));
  }
}
