import 'package:flutter/material.dart';

/// Trending sounds badge (🔥) — shown on sounds with high trending score.
class TrendingSoundBadge extends StatelessWidget {
  final int trendingScore;
  final bool compact;

  const TrendingSoundBadge({
    super.key,
    required this.trendingScore,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (trendingScore < 10) return const SizedBox.shrink();

    final tier = _getTier();

    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        decoration: BoxDecoration(
          color: tier.color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          tier.emoji,
          style: const TextStyle(fontSize: 10),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [tier.color.withOpacity(0.3), tier.color.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: tier.color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(tier.emoji, style: const TextStyle(fontSize: 11)),
          const SizedBox(width: 3),
          Text(
            tier.label,
            style: TextStyle(
              color: tier.color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  _TrendingTier _getTier() {
    if (trendingScore >= 90) {
      return _TrendingTier(
        emoji: '🔥',
        label: 'VIRAL',
        color: Colors.redAccent,
      );
    } else if (trendingScore >= 70) {
      return _TrendingTier(
        emoji: '🔥',
        label: 'HOT',
        color: Colors.orangeAccent,
      );
    } else if (trendingScore >= 50) {
      return _TrendingTier(
        emoji: '📈',
        label: 'RISING',
        color: Colors.amberAccent,
      );
    } else {
      return _TrendingTier(
        emoji: '✨',
        label: 'NEW',
        color: Colors.white60,
      );
    }
  }
}

class _TrendingTier {
  final String emoji;
  final String label;
  final Color color;

  const _TrendingTier({
    required this.emoji,
    required this.label,
    required this.color,
  });
}

/// Animated trending badge with pulse effect for high-trending sounds.
class AnimatedTrendingBadge extends StatefulWidget {
  final int trendingScore;

  const AnimatedTrendingBadge({
    super.key,
    required this.trendingScore,
  });

  @override
  State<AnimatedTrendingBadge> createState() => _AnimatedTrendingBadgeState();
}

class _AnimatedTrendingBadgeState extends State<AnimatedTrendingBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.trendingScore >= 80) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: TrendingSoundBadge(trendingScore: widget.trendingScore),
        );
      },
    );
  }
}
