import 'package:flutter/material.dart';
import '../../models/reel_template_model.dart';

/// Visual beat marker widget for template timeline.
/// Shows beat positions on a horizontal track with different styles
/// for beat, drop, and transition markers.
/// Auto-places clips at beat timestamps when template is applied.
class TemplateBeatMarker extends StatelessWidget {
  final ReelTemplate template;
  final int currentPositionMs;
  final ValueChanged<int>? onBeatTap;

  const TemplateBeatMarker({
    super.key,
    required this.template,
    this.currentPositionMs = 0,
    this.onBeatTap,
  });

  @override
  Widget build(BuildContext context) {
    if (template.beatMarkers.isEmpty || template.durationMs <= 0) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Legend
          Row(
            children: [
              _LegendDot(color: Colors.white70, label: 'Beat'),
              const SizedBox(width: 12),
              _LegendDot(color: Colors.amber, label: 'Drop'),
              const SizedBox(width: 12),
              _LegendDot(color: Colors.purpleAccent, label: 'Transition'),
              const Spacer(),
              Text(
                '${template.beatMarkers.length} beats',
                style: const TextStyle(color: Colors.white38, fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Timeline track with beat markers
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final trackWidth = constraints.maxWidth;
                final playProgress = template.durationMs > 0
                    ? currentPositionMs / template.durationMs
                    : 0.0;

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Track background
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 10,
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                      ),
                    ),
                    // Progress fill
                    Positioned(
                      left: 0,
                      top: 10,
                      child: Container(
                        width: trackWidth * playProgress.clamp(0.0, 1.0),
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                      ),
                    ),
                    // Clip slot regions
                    ...template.clipSlots.map((slot) {
                      final startFraction = slot.startMs / template.durationMs;
                      final widthFraction = slot.durationMs / template.durationMs;
                      return Positioned(
                        left: trackWidth * startFraction,
                        top: 8,
                        child: Container(
                          width: (trackWidth * widthFraction).clamp(2.0, double.infinity),
                          height: 7,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white10, width: 0.5),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Center(
                            child: Text(
                              '${slot.index + 1}',
                              style: const TextStyle(
                                color: Colors.white24,
                                fontSize: 6,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    // Beat markers
                    ...template.beatMarkers.asMap().entries.map((entry) {
                      final beat = entry.value;
                      final fraction = beat.timestampMs / template.durationMs;
                      final isPast = beat.timestampMs <= currentPositionMs;

                      return Positioned(
                        left: (trackWidth * fraction) - _markerRadius(beat),
                        top: 11 - _markerRadius(beat),
                        child: GestureDetector(
                          onTap: onBeatTap != null
                              ? () => onBeatTap!(beat.timestampMs)
                              : null,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: _markerRadius(beat) * 2,
                            height: _markerRadius(beat) * 2,
                            decoration: BoxDecoration(
                              color: isPast
                                  ? _markerColor(beat).withOpacity(0.5)
                                  : _markerColor(beat),
                              shape: BoxShape.circle,
                              boxShadow: beat.type == 'drop'
                                  ? [
                                      BoxShadow(
                                        color: Colors.amber.withOpacity(0.4),
                                        blurRadius: 6,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : null,
                            ),
                          ),
                        ),
                      );
                    }),
                    // Playhead
                    Positioned(
                      left: (trackWidth * playProgress.clamp(0.0, 1.0)) - 1,
                      top: 4,
                      child: Container(
                        width: 2,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.3),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  double _markerRadius(BeatMarker beat) {
    switch (beat.type) {
      case 'drop':
        return 6.0 * beat.intensity;
      case 'transition':
        return 4.0;
      default:
        return 3.0;
    }
  }

  Color _markerColor(BeatMarker beat) {
    switch (beat.type) {
      case 'drop':
        return Colors.amber;
      case 'transition':
        return Colors.purpleAccent;
      default:
        return Colors.white70;
    }
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 3),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 9)),
      ],
    );
  }
}

/// Utility to auto-place clips at template beat timestamps.
class TemplateClipPlacer {
  /// Given a template and a list of clip file paths, returns a map of
  /// clip index to the start timestamp (ms) where it should be placed.
  static Map<int, int> autoPlaceClips({
    required ReelTemplate template,
    required int availableClipCount,
  }) {
    final placements = <int, int>{};
    final slots = template.clipSlots;

    for (int i = 0; i < slots.length && i < availableClipCount; i++) {
      placements[i] = slots[i].startMs;
    }

    return placements;
  }

  /// Returns recommended clip durations based on template beat markers.
  static List<int> getClipDurations(ReelTemplate template) {
    return template.clipSlots.map((s) => s.durationMs).toList();
  }
}
