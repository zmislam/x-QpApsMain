import 'package:flutter/material.dart';

/// Text animation picker: typewriter, fade-in, bounce, slide.
/// Shows animation name and a small preview icon.
class TextAnimationPicker extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const TextAnimationPicker({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static const List<_AnimOption> _animations = [
    _AnimOption('none', 'None', Icons.block),
    _AnimOption('typewriter', 'Typewriter', Icons.keyboard),
    _AnimOption('fadeIn', 'Fade In', Icons.gradient),
    _AnimOption('bounce', 'Bounce', Icons.arrow_upward),
    _AnimOption('slide', 'Slide', Icons.swap_horiz),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _animations.length,
        itemBuilder: (context, index) {
          final anim = _animations[index];
          final isActive = selected == anim.id;

          return GestureDetector(
            onTap: () => onSelected(anim.id),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.blueAccent.withValues(alpha: 0.2)
                    : Colors.grey[800],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive ? Colors.blueAccent : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    anim.icon,
                    color: isActive ? Colors.blueAccent : Colors.white54,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    anim.label,
                    style: TextStyle(
                      color: isActive ? Colors.blueAccent : Colors.white54,
                      fontSize: 12,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AnimOption {
  final String id;
  final String label;
  final IconData icon;
  const _AnimOption(this.id, this.label, this.icon);
}
