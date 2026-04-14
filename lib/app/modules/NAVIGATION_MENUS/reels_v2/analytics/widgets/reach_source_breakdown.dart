import 'package:flutter/material.dart';

class ReachSourceBreakdown extends StatelessWidget {
  final Map<String, double> sources;
  const ReachSourceBreakdown({super.key, required this.sources});

  static const _sourceColors = {
    'For You': Colors.blue,
    'Following': Colors.green,
    'Hashtag': Colors.orange,
    'Sound': Colors.purple,
    'Share': Colors.teal,
    'Profile': Colors.amber,
    'Other': Colors.grey,
  };

  @override
  Widget build(BuildContext context) {
    if (sources.isEmpty) {
      return Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text('No reach data',
              style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    final sorted = sources.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 16,
              child: Row(
                children: sorted.map((e) {
                  final color =
                      _sourceColors[e.key] ?? Colors.grey;
                  return Expanded(
                    flex: (e.value * 10).round().clamp(1, 1000),
                    child: Container(color: color),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Legend
          ...sorted.map((e) {
            final color = _sourceColors[e.key] ?? Colors.grey;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        color: color, borderRadius: BorderRadius.circular(2)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(e.key,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 13)),
                  ),
                  Text('${e.value.toStringAsFixed(1)}%',
                      style: const TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
