import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_audio_controller.dart';

/// Dual audio mix panel — original audio + music with independent volume sliders.
class AudioMixPanel extends StatelessWidget {
  const AudioMixPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReelsAudioController>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Text(
                'Audio Mix',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Original audio slider
              _VolumeSlider(
                icon: Icons.videocam,
                label: 'Original',
                value: controller.originalVolume.value,
                color: Colors.blueAccent,
                onChanged: (v) => controller.setOriginalVolume(v),
              ),
              const SizedBox(height: 12),
              // Music slider
              _VolumeSlider(
                icon: Icons.music_note,
                label: 'Music',
                value: controller.musicVolume.value,
                color: Colors.purpleAccent,
                onChanged: (v) => controller.setMusicVolume(v),
                subtitle: controller.selectedSound.value?.title,
              ),
              const SizedBox(height: 12),
              // Voiceover slider
              if (controller.hasVoiceover)
                _VolumeSlider(
                  icon: Icons.mic,
                  label: 'Voiceover',
                  value: controller.voiceoverVolume.value,
                  color: Colors.orangeAccent,
                  onChanged: (v) => controller.setVoiceoverVolume(v),
                ),
              const SizedBox(height: 16),
              // Quick presets
              Row(
                children: [
                  const Text(
                    'Presets:',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(width: 8),
                  _PresetChip(
                    label: 'Music Only',
                    onTap: () {
                      controller.setOriginalVolume(0.0);
                      controller.setMusicVolume(1.0);
                    },
                  ),
                  const SizedBox(width: 6),
                  _PresetChip(
                    label: 'Original Only',
                    onTap: () {
                      controller.setOriginalVolume(1.0);
                      controller.setMusicVolume(0.0);
                    },
                  ),
                  const SizedBox(width: 6),
                  _PresetChip(
                    label: 'Balanced',
                    onTap: () {
                      controller.setOriginalVolume(0.6);
                      controller.setMusicVolume(0.8);
                    },
                  ),
                ],
              ),
            ],
          )),
    );
  }
}

class _VolumeSlider extends StatelessWidget {
  final IconData icon;
  final String label;
  final double value;
  final Color color;
  final ValueChanged<double> onChanged;
  final String? subtitle;

  const _VolumeSlider({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.onChanged,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Mute/unmute toggle
        GestureDetector(
          onTap: () => onChanged(value > 0 ? 0.0 : 1.0),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: value > 0 ? color.withOpacity(0.2) : Colors.white10,
              shape: BoxShape.circle,
            ),
            child: Icon(
              value > 0 ? icon : Icons.volume_off,
              color: value > 0 ? color : Colors.white38,
              size: 18,
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Label
        SizedBox(
          width: 60,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white38, fontSize: 9),
                ),
            ],
          ),
        ),
        // Slider
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: color,
              inactiveTrackColor: Colors.white12,
              thumbColor: Colors.white,
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
            ),
            child: Slider(
              value: value,
              min: 0.0,
              max: 1.0,
              onChanged: onChanged,
            ),
          ),
        ),
        // Percentage
        SizedBox(
          width: 36,
          child: Text(
            '${(value * 100).round()}%',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: value > 0 ? Colors.white70 : Colors.white38,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}

class _PresetChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PresetChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 10),
        ),
      ),
    );
  }
}
