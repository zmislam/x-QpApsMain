import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/reel_player_controller.dart';
import '../../controllers/reels_interaction_controller.dart';
import 'double_tap_heart.dart';

/// Gesture detection layer for Reels V2.
/// Handles: single tap (immersive toggle), double-tap (heart burst),
/// long-press (pause + dim + scrubber), pinch-to-zoom (up to 3x).
class ReelGestureLayer extends StatefulWidget {
  final Widget child;
  final String reelId;
  final int index;

  const ReelGestureLayer({
    super.key,
    required this.child,
    required this.reelId,
    required this.index,
  });

  @override
  State<ReelGestureLayer> createState() => _ReelGestureLayerState();
}

class _ReelGestureLayerState extends State<ReelGestureLayer> {
  final List<Offset> _heartPositions = [];
  int _heartKey = 0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;
  bool _isLongPressing = false;

  @override
  Widget build(BuildContext context) {
    final playerController = Get.find<ReelPlayerController>();
    final interactionController = Get.find<ReelsInteractionController>();

    return GestureDetector(
      // Single tap → toggle overlay visibility (immersive mode)
      onTap: () {
        interactionController.toggleOverlayVisibility();
      },
      // Double-tap → heart burst at tap position
      onDoubleTapDown: (details) {
        _triggerHeartAt(details.localPosition);
        interactionController.likeReel(widget.reelId);
      },
      onDoubleTap: () {
        // Required for onDoubleTapDown to fire
      },
      // Long-press → pause + dim overlay + show scrubber
      onLongPressStart: (details) {
        _isLongPressing = true;
        playerController.pauseCurrent();
        interactionController.showScrubberOverlay(true);
      },
      onLongPressEnd: (details) {
        if (_isLongPressing) {
          _isLongPressing = false;
          playerController.resumeCurrent();
          interactionController.showScrubberOverlay(false);
        }
      },
      child: // Pinch-to-zoom wrapper (up to 3x)
          _buildPinchZoom(
        child: Stack(
          fit: StackFit.expand,
          children: [
            widget.child,
            // Heart burst animations
            ..._buildHearts(),
          ],
        ),
      ),
    );
  }

  Widget _buildPinchZoom({required Widget child}) {
    return GestureDetector(
      onScaleStart: (details) {
        _baseScale = _currentScale;
      },
      onScaleUpdate: (details) {
        setState(() {
          _currentScale = (_baseScale * details.scale).clamp(1.0, 3.0);
        });
      },
      onScaleEnd: (details) {
        // Snap back if close to 1x
        if (_currentScale < 1.1) {
          setState(() {
            _currentScale = 1.0;
          });
        }
      },
      child: Transform.scale(
        scale: _currentScale,
        child: child,
      ),
    );
  }

  void _triggerHeartAt(Offset position) {
    setState(() {
      _heartPositions.add(position);
      _heartKey++;
    });
    // Auto-remove after animation completes
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted && _heartPositions.isNotEmpty) {
        setState(() {
          _heartPositions.removeAt(0);
        });
      }
    });
  }

  List<Widget> _buildHearts() {
    return _heartPositions.asMap().entries.map((entry) {
      return Positioned(
        left: entry.value.dx - 30,
        top: entry.value.dy - 30,
        child: DoubleTapHeart(key: ValueKey('heart_${_heartKey}_${entry.key}')),
      );
    }).toList();
  }
}
