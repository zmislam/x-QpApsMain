import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Heart burst animation triggered on double-tap.
/// Shows a heart at the tap position that scales up, rises, and fades out.
class DoubleTapHeart extends StatefulWidget {
  const DoubleTapHeart({super.key});

  @override
  State<DoubleTapHeart> createState() => _DoubleTapHeartState();
}

class _DoubleTapHeartState extends State<DoubleTapHeart>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _riseAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    // Scale: burst up then settle
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.3)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.3, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 60,
      ),
    ]).animate(_scaleController);

    // Fade + rise
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );
    _riseAnimation = Tween<double>(begin: 0.0, end: -60.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOut,
      ),
    );

    // Random slight rotation for variety
    final random = math.Random();
    final rotateAngle = (random.nextDouble() - 0.5) * 0.4; // ±0.2 rad
    _rotateAnimation = Tween<double>(begin: 0.0, end: rotateAngle).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOut,
      ),
    );

    _scaleController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleController, _fadeController]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _riseAnimation.value),
          child: Transform.rotate(
            angle: _rotateAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 60,
                  shadows: [
                    Shadow(
                      color: Colors.black38,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
