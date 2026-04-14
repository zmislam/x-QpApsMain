import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Layout picker for duet remix — side-by-side / top-bottom / picture-in-picture.
class RemixLayoutPicker extends StatelessWidget {
  final RxString currentLayout;
  final ValueChanged<String> onLayoutChanged;

  const RemixLayoutPicker({
    super.key,
    required this.currentLayout,
    required this.onLayoutChanged,
  });

  static const _layouts = [
    {
      'value': 'side-by-side',
      'label': 'Side by Side',
      'icon': Icons.view_column,
    },
    {
      'value': 'top-bottom',
      'label': 'Top & Bottom',
      'icon': Icons.view_agenda,
    },
    {
      'value': 'pip',
      'label': 'Picture in Picture',
      'icon': Icons.picture_in_picture,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.black87,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _layouts.map((layout) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Obx(() {
              final isSelected = currentLayout.value == layout['value'];
              return GestureDetector(
                onTap: () => onLayoutChanged(layout['value'] as String),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.blue.withOpacity(0.2)
                            : Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.white24,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Icon(
                        layout['icon'] as IconData,
                        color: isSelected ? Colors.blue : Colors.white54,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      layout['label'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        color: isSelected ? Colors.blue : Colors.white54,
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        }).toList(),
      ),
    );
  }
}
