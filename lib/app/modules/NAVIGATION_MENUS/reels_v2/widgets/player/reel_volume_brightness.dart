import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/reel_player_controller.dart';

/// Volume/brightness gesture control for Reels V2.
/// Left-side vertical drag → brightness control.
/// Right-side vertical drag → volume control.
class ReelVolumeBrightness extends StatefulWidget {
  final Widget child;

  const ReelVolumeBrightness({
    super.key,
    required this.child,
  });

  @override
  State<ReelVolumeBrightness> createState() => _ReelVolumeBrightnessState();
}

class _ReelVolumeBrightnessState extends State<ReelVolumeBrightness> {
  bool _isDragging = false;
  bool _isVolumeControl = false;
  double _currentValue = 1.0;
  double _startValue = 1.0;
  double _brightness = 1.0;
  double _volume = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: _onDragStart,
      onVerticalDragUpdate: _onDragUpdate,
      onVerticalDragEnd: _onDragEnd,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Brightness overlay
          Opacity(
            opacity: _brightness < 1.0 ? (1.0 - _brightness) * 0.7 : 0.0,
            child: Container(color: Colors.black),
          ),
          widget.child,
          // Indicator overlay
          if (_isDragging) _buildIndicator(),
        ],
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isRightSide = details.localPosition.dx > screenWidth / 2;

    setState(() {
      _isDragging = true;
      _isVolumeControl = isRightSide;
      _currentValue = isRightSide ? _volume : _brightness;
      _startValue = _currentValue;
    });
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (!_isDragging) return;

    final screenHeight = MediaQuery.of(context).size.height;
    // Normalize: dragging up increases, down decreases
    final delta = -details.delta.dy / (screenHeight * 0.5);
    final newValue = (_currentValue + delta).clamp(0.0, 1.0);

    setState(() {
      _currentValue = newValue;
      if (_isVolumeControl) {
        _volume = newValue;
        _applyVolume(newValue);
      } else {
        _brightness = newValue;
      }
    });
  }

  void _onDragEnd(DragEndDetails details) {
    setState(() {
      _isDragging = false;
    });
  }

  void _applyVolume(double value) {
    try {
      final playerController = Get.find<ReelPlayerController>();
      final controller = playerController.currentController;
      if (controller != null && controller.value.isInitialized) {
        controller.setVolume(value);
        if (value == 0.0) {
          playerController.isMuted.value = true;
        } else {
          playerController.isMuted.value = false;
        }
      }
    } catch (_) {}
  }

  Widget _buildIndicator() {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.3,
      left: _isVolumeControl
          ? MediaQuery.of(context).size.width - 56
          : 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isVolumeControl
                  ? (_currentValue > 0
                      ? Icons.volume_up_rounded
                      : Icons.volume_off_rounded)
                  : Icons.brightness_6_rounded,
              color: Colors.white,
              size: 22,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              width: 4,
              child: RotatedBox(
                quarterTurns: 3,
                child: LinearProgressIndicator(
                  value: _currentValue,
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${(_currentValue * 100).toInt()}%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
