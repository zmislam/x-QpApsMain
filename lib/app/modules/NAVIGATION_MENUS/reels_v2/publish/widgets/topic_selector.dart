import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Select up to 3 topics/categories for the reel.
class TopicSelector extends StatelessWidget {
  final RxList<String> selectedTopicIds;
  final RxList<String> selectedTopicNames;
  final int maxTopics;
  final void Function(String topicId, String topicName) onToggle;

  const TopicSelector({
    super.key,
    required this.selectedTopicIds,
    required this.selectedTopicNames,
    required this.maxTopics,
    required this.onToggle,
  });

  // Available topics — real impl fetches from API
  static const List<Map<String, String>> _topics = [
    {'id': 'comedy', 'name': 'Comedy', 'icon': '😂'},
    {'id': 'music', 'name': 'Music', 'icon': '🎵'},
    {'id': 'dance', 'name': 'Dance', 'icon': '💃'},
    {'id': 'food', 'name': 'Food', 'icon': '🍕'},
    {'id': 'travel', 'name': 'Travel', 'icon': '✈️'},
    {'id': 'beauty', 'name': 'Beauty', 'icon': '💄'},
    {'id': 'fitness', 'name': 'Fitness', 'icon': '💪'},
    {'id': 'fashion', 'name': 'Fashion', 'icon': '👗'},
    {'id': 'art', 'name': 'Art', 'icon': '🎨'},
    {'id': 'tech', 'name': 'Technology', 'icon': '💻'},
    {'id': 'gaming', 'name': 'Gaming', 'icon': '🎮'},
    {'id': 'education', 'name': 'Education', 'icon': '📚'},
    {'id': 'pets', 'name': 'Pets', 'icon': '🐾'},
    {'id': 'sports', 'name': 'Sports', 'icon': '⚽'},
    {'id': 'nature', 'name': 'Nature', 'icon': '🌿'},
    {'id': 'diy', 'name': 'DIY & Crafts', 'icon': '🔨'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => Text(
              'Select up to $maxTopics (${selectedTopicIds.length}/$maxTopics)',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            )),
        const SizedBox(height: 8),
        Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _topics.map((topic) {
                final isSelected =
                    selectedTopicIds.contains(topic['id']);
                final canSelect =
                    selectedTopicIds.length < maxTopics || isSelected;
                return FilterChip(
                  selected: isSelected,
                  label: Text('${topic['icon']} ${topic['name']}'),
                  onSelected: canSelect
                      ? (_) => onToggle(topic['id']!, topic['name']!)
                      : null,
                  selectedColor: Colors.blue.withOpacity(0.2),
                  checkmarkColor: Colors.blue,
                  disabledColor: Colors.grey[900],
                );
              }).toList(),
            )),
      ],
    );
  }
}
