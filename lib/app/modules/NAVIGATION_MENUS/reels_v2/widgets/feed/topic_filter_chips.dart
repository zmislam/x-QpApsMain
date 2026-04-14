import 'package:flutter/material.dart';

class TopicFilterChips extends StatelessWidget {
  final List<String> topics;
  final String? selectedTopic;
  final ValueChanged<String?> onSelected;

  const TopicFilterChips({
    super.key,
    required this.topics,
    this.selectedTopic,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: topics.length + 1, // +1 for "All"
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            final isActive = selectedTopic == null;
            return GestureDetector(
              onTap: () => onSelected(null),
              child: _chip('All', isActive),
            );
          }
          final topic = topics[index - 1];
          final isActive = selectedTopic == topic;
          return GestureDetector(
            onTap: () => onSelected(topic),
            child: _chip(topic, isActive),
          );
        },
      ),
    );
  }

  Widget _chip(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey[900],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.black : Colors.white70,
          fontSize: 14,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}
