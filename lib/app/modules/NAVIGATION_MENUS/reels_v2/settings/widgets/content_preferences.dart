import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_settings_controller.dart';

class ContentPreferences extends GetView<ReelsSettingsController> {
  const ContentPreferences({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.availableTopics.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'No topics available',
            style: TextStyle(color: Colors.grey),
          ),
        );
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select topics you\'re interested in:',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.availableTopics.map((topic) {
                final isSelected = controller.selectedTopics.contains(topic);
                return FilterChip(
                  label: Text(topic),
                  selected: isSelected,
                  onSelected: (_) => controller.toggleTopic(topic),
                  selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                  checkmarkColor: Theme.of(context).primaryColor,
                );
              }).toList(),
            ),
          ],
        ),
      );
    });
  }
}
