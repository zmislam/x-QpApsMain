import 'package:flutter/material.dart';
import '../../utils/reel_enums.dart';

/// Long-press reaction picker — shows 6 emoji reactions in a floating pill.
class ReelReactionPicker extends StatelessWidget {
  final Function(ReelReactionType) onReactionSelected;
  final String? currentReaction;

  const ReelReactionPicker({
    super.key,
    required this.onReactionSelected,
    this.currentReaction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: ReelReactionType.values.map((type) {
          final isSelected = currentReaction == type.value;
          return GestureDetector(
            onTap: () => onReactionSelected(type),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.15)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: AnimatedScale(
                scale: isSelected ? 1.3 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Text(
                  type.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Show reaction picker as an overlay at a specific position.
  static void show(
    BuildContext context, {
    required Offset position,
    required Function(ReelReactionType) onSelected,
    String? currentReaction,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Dismiss on tap outside
          Positioned.fill(
            child: GestureDetector(
              onTap: () => entry.remove(),
              child: Container(color: Colors.transparent),
            ),
          ),
          Positioned(
            left: position.dx - 100,
            top: position.dy - 60,
            child: Material(
              color: Colors.transparent,
              child: ReelReactionPicker(
                currentReaction: currentReaction,
                onReactionSelected: (type) {
                  entry.remove();
                  onSelected(type);
                },
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(entry);
  }
}
