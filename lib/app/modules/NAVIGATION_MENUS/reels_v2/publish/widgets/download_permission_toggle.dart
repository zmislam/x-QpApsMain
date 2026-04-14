import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Toggle to allow/disable downloading of this reel.
class DownloadPermissionToggle extends StatelessWidget {
  final RxBool allowDownload;

  const DownloadPermissionToggle({super.key, required this.allowDownload});

  @override
  Widget build(BuildContext context) {
    return Obx(() => SwitchListTile(
          contentPadding: EdgeInsets.zero,
          secondary: const Icon(Icons.download_outlined),
          title: const Text('Allow Download'),
          subtitle: const Text('Others can save your reel to their device'),
          value: allowDownload.value,
          onChanged: (v) => allowDownload.value = v,
        ));
  }
}
