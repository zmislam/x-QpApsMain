import 'package:flutter/material.dart';

/// Viral post overlay badge — shows tier icon + label + multiplier.
/// All labels, multipliers from API — NEVER hardcoded.
/// Position on top-right corner of post card.
/// Animated pulse for viral/mega_viral tiers.
class ViralBadge extends StatefulWidget {
  final String tierKey; // 'rising', 'viral', 'mega_viral', 'expired'
  final String label;
  final double multiplier;
  final VoidCallback? onTap;

  const ViralBadge({
    super.key,
    required this.tierKey,
    required this.label,
    required this.multiplier,
    this.onTap,
  });

  @override
  State<ViralBadge> createState() => _ViralBadgeState();
}

class _ViralBadgeState extends State<ViralBadge>
    with SingleTickerProviderStateMixin {
  AnimationController? _pulseController;
  Animation<double>? _pulseAnimation;

  bool get _shouldPulse =>
      widget.tierKey == 'viral' || widget.tierKey == 'mega_viral';

  @override
  void initState() {
    super.initState();
    if (_shouldPulse) {
      _pulseController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1200),
      )..repeat(reverse: true);
      _pulseAnimation =
          Tween<double>(begin: 1.0, end: 1.08).animate(CurvedAnimation(
        parent: _pulseController!,
        curve: Curves.easeInOut,
      ));
    }
  }

  @override
  void dispose() {
    _pulseController?.dispose();
    super.dispose();
  }

  Color get _bgColor {
    switch (widget.tierKey) {
      case 'rising':
        return Colors.orange;
      case 'viral':
        return Colors.red;
      case 'mega_viral':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tierKey == 'expired') return const SizedBox.shrink();

    Widget badge = GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _bgColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: _bgColor.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🔥', style: TextStyle(fontSize: 12)),
            const SizedBox(width: 3),
            Text(
              widget.label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 3),
            Text(
              '${widget.multiplier}x',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );

    if (_shouldPulse && _pulseAnimation != null) {
      return AnimatedBuilder(
        animation: _pulseAnimation!,
        builder: (_, child) =>
            Transform.scale(scale: _pulseAnimation!.value, child: child),
        child: badge,
      );
    }
    return badge;
  }
}
