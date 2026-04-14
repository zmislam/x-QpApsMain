import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_settings_controller.dart';

class HiddenWordsEditor extends GetView<ReelsSettingsController> {
  const HiddenWordsEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Comments containing these words will be hidden:',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 12),

            // Add word input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Add a word...',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onSubmitted: (value) {
                      controller.addHiddenWord(value);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.blue),
                  onPressed: () {
                    // Use the text field controller if needed
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Word chips
            if (controller.hiddenWords.isEmpty)
              const Text(
                'No hidden words yet',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.hiddenWords.map((word) {
                  return Chip(
                    label: Text(word),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () => controller.removeHiddenWord(word),
                  );
                }).toList(),
              ),
          ],
        ),
      );
    });
  }
}
