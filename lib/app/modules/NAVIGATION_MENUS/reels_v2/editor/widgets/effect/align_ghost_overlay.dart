import 'dart:io';
import 'package:flutter/material.dart';

/// Ghost overlay showing the last frame of the previous clip.
/// Helps align shots for smooth transition recording.
class AlignGhostOverlay extends StatefulWidget {
  final String? previousClipPath;
  final bool isEnabled;
  final ValueChanged<bool> onToggle;
  final ValueChanged<double> onOpacityChanged;

  const AlignGhostOverlay({
    super.key,
    this.previousClipPath,
    this.isEnabled = false,
    required this.onToggle,
    required this.onOpacityChanged,
  });

  @override
  State<AlignGhostOverlay> createState() => _AlignGhostOverlayState();
}

class _AlignGhostOverlayState extends State<AlignGhostOverlay> {
  double _opacity = 0.4;

  @override
  Widget build(BuildContext context) {
    if (!widget.isEnabled || widget.previousClipPath == null) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        // Ghost image overlay
        Positioned.fill(
          child: IgnorePointer(
            child: Opacity(
              opacity: _opacity,
              child: Image.file(
                File(widget.previousClipPath!),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.white10,
                  child: const Center(
                    child: Icon(Icons.image_not_supported,
                        color: Colors.white24, size: 48),
                  ),
                ),
              ),
            ),
          ),
        ),
        // Opacity control (bottom left)
        Positioned(
          left: 12,
          bottom: 80,
          child: _GhostControls(
            opacity: _opacity,
            onOpacityChanged: (v) {
              setState(() => _opacity = v);
              widget.onOpacityChanged(v);
            },
            onDisable: () => widget.onToggle(false),
          ),
        ),
        // "ALIGN" badge (top center)
        Positioned(
          top: 12,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.grid_on, size: 14, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    'ALIGN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GhostControls extends StatelessWidget {
  final double opacity;
  final ValueChanged<double> onOpacityChanged;
  final VoidCallback onDisable;

  const _GhostControls({
    required this.opacity,
    required this.onOpacityChanged,
    required this.onDisable,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Vertical opacity slider
          RotatedBox(
            quarterTurns: -1,
            child: SizedBox(
              width: 100,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.purpleAccent,
                  inactiveTrackColor: Colors.white24,
                  thumbColor: Colors.white,
                  trackHeight: 2,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                ),
                child: Slider(
                  value: opacity,
                  min: 0.1,
                  max: 0.8,
                  onChanged: onOpacityChanged,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${(opacity * 100).round()}%',
            style: const TextStyle(color: Colors.white60, fontSize: 10),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: onDisable,
            child: const Icon(Icons.visibility_off, size: 18, color: Colors.white54),
          ),
        ],
      ),
    );
  }
}

/// Toggle button widget for the camera toolbar to enable/disable ghost overlay.
class AlignGhostToggle extends StatelessWidget {
  final bool isEnabled;
  final bool hasClip;
  final VoidCallback onTap;

  const AlignGhostToggle({
    super.key,
    required this.isEnabled,
    required this.hasClip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: hasClip ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isEnabled ? Colors.purple.withOpacity(0.3) : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: isEnabled ? Colors.purpleAccent : Colors.white24,
          ),
        ),
        child: Icon(
          Icons.grid_on,
          size: 22,
          color: hasClip
              ? (isEnabled ? Colors.purpleAccent : Colors.white70)
              : Colors.white24,
        ),
      ),
    );
  }
}
