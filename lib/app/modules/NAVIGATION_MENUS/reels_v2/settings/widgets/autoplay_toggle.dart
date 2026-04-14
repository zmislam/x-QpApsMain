import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_settings_controller.dart';

class AutoplayToggle extends GetView<ReelsSettingsController> {
  const AutoplayToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Autoplay Reels',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
          RadioListTile<String>(
            title: const Text('Always On'),
            subtitle: const Text('Reels autoplay on any network'),
            value: 'on',
            groupValue: controller.autoplaySetting.value,
            onChanged: (v) => controller.setAutoplay(v!),
          ),
          RadioListTile<String>(
            title: const Text('WiFi Only'),
            subtitle: const Text('Autoplay only on WiFi'),
            value: 'wifi_only',
            groupValue: controller.autoplaySetting.value,
            onChanged: (v) => controller.setAutoplay(v!),
          ),
          RadioListTile<String>(
            title: const Text('Off'),
            subtitle: const Text('Never autoplay reels'),
            value: 'off',
            groupValue: controller.autoplaySetting.value,
            onChanged: (v) => controller.setAutoplay(v!),
          ),
        ],
      );
    });
  }
}
