import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/reel_player_controller.dart';

/// Seekbar / scrubber for Reels V2.
/// Shows at bottom by default (thin line), expandable on touch.
/// Full seekbar shown during long-press scrubber overlay.
class ReelSeekbar extends StatefulWidget {
  final bool expanded;

  const ReelSeekbar({
    super.key,
    this.expanded = false,
  });

  @override
  State<ReelSeekbar> createState() => _ReelSeekbarState();
}

class _ReelSeekbarState extends State<ReelSeekbar> {
  bool _isDragging = false;
  double _dragValue = 0.0;

  @override
  Widget build(BuildContext context) {
    final playerController = Get.find<ReelPlayerController>();

    if (widget.expanded) {
      return _buildExpandedSeekbar(playerController);
    }

    return _buildCompactSeekbar(playerController);
  }

  /// Compact seekbar — thin 2px line at bottom (default).
  Widget _buildCompactSeekbar(ReelPlayerController controller) {
    return GestureDetector(
      onHorizontalDragStart: (details) {
        setState(() {
          _isDragging = true;
          _dragValue = controller.progress.value;
        });
      },
      onHorizontalDragUpdate: (details) {
        if (!_isDragging) return;
        final box = context.findRenderObject() as RenderBox;
        final width = box.size.width;
        setState(() {
          _dragValue = (_dragValue + details.delta.dx / width).clamp(0.0, 1.0);
        });
      },
      onHorizontalDragEnd: (details) {
        if (_isDragging) {
          controller.seekTo(_dragValue);
          setState(() => _isDragging = false);
        }
      },
      child: Container(
        height: 20,
        alignment: Alignment.bottomCenter,
        child: Obx(() {
          final progress = _isDragging ? _dragValue : controller.progress.value;
          return LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: _isDragging ? 4 : 2,
          );
        }),
      ),
    );
  }

  /// Expanded seekbar — full-width with thumb, shown on long-press.
  Widget _buildExpandedSeekbar(ReelPlayerController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.6),
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() {
            final progress = _isDragging ? _dragValue : controller.progress.value;
            return SliderTheme(
              data: SliderThemeData(
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                activeTrackColor: Colors.white,
                inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
                thumbColor: Colors.white,
                overlayColor: Colors.white.withValues(alpha: 0.2),
              ),
              child: Slider(
                value: progress,
                onChangeStart: (value) {
                  setState(() {
                    _isDragging = true;
                    _dragValue = value;
                  });
                },
                onChanged: (value) {
                  setState(() => _dragValue = value);
                },
                onChangeEnd: (value) {
                  controller.seekTo(value);
                  setState(() => _isDragging = false);
                },
              ),
            );
          }),
          // Time indicators
          Obx(() {
            final current = controller.currentController;
            if (current == null || !current.value.isInitialized) {
              return const SizedBox.shrink();
            }
            final position = current.value.position;
            final duration = current.value.duration;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(position),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    _formatDuration(duration),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
