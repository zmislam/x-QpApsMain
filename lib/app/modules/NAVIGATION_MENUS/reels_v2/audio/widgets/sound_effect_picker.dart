import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/reel_sound_model.dart';
import '../controllers/reels_audio_controller.dart';

/// Sound effects library — 10+ categories of sound effects.
class SoundEffectPicker extends StatefulWidget {
  final ValueChanged<ReelSoundModel> onSelectEffect;

  const SoundEffectPicker({
    super.key,
    required this.onSelectEffect,
  });

  @override
  State<SoundEffectPicker> createState() => _SoundEffectPickerState();
}

class _SoundEffectPickerState extends State<SoundEffectPicker> {
  String _selectedCategory = 'Transitions';

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReelsAudioController>();

    return Container(
      constraints: const BoxConstraints(maxHeight: 360),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 8, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.surround_sound, color: Colors.tealAccent, size: 20),
                SizedBox(width: 8),
                Text(
                  'Sound Effects',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Category tabs
          SizedBox(
            height: 36,
            child: Obx(() => ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: controller.soundEffectCategories.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _selectedCategory = cat);
                          controller.fetchSoundEffects(cat);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.tealAccent.withOpacity(0.2) : Colors.white10,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isSelected ? Colors.tealAccent : Colors.transparent,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _categoryIcon(cat),
                                size: 14,
                                color: isSelected ? Colors.tealAccent : Colors.white54,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                cat,
                                style: TextStyle(
                                  color: isSelected ? Colors.tealAccent : Colors.white60,
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )),
          ),
          const SizedBox(height: 8),
          // Effects list
          Expanded(
            child: Obx(() {
              if (controller.soundEffects.isEmpty) {
                // Show placeholder effects for the category
                return _PlaceholderEffects(
                  category: _selectedCategory,
                  onSelect: widget.onSelectEffect,
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: controller.soundEffects.length,
                itemBuilder: (context, index) {
                  final effect = controller.soundEffects[index];
                  return _SoundEffectTile(
                    effect: effect,
                    onTap: () => widget.onSelectEffect(effect),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Transitions':
        return Icons.swap_horiz;
      case 'Comedy':
        return Icons.emoji_emotions;
      case 'Nature':
        return Icons.park;
      case 'Action':
        return Icons.flash_on;
      case 'Horror':
        return Icons.nights_stay;
      case 'Ambient':
        return Icons.air;
      case 'UI':
        return Icons.touch_app;
      case 'Animals':
        return Icons.pets;
      case 'Musical':
        return Icons.piano;
      case 'Weather':
        return Icons.cloud;
      default:
        return Icons.audiotrack;
    }
  }
}

class _SoundEffectTile extends StatelessWidget {
  final ReelSoundModel effect;
  final VoidCallback onTap;

  const _SoundEffectTile({required this.effect, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.tealAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.play_arrow, color: Colors.tealAccent, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    effect.title ?? 'Effect',
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  if (effect.durationMs != null)
                    Text(
                      '${(effect.durationMs! / 1000).toStringAsFixed(1)}s',
                      style: const TextStyle(color: Colors.white38, fontSize: 11),
                    ),
                ],
              ),
            ),
            const Icon(Icons.add_circle_outline, color: Colors.tealAccent, size: 22),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderEffects extends StatelessWidget {
  final String category;
  final ValueChanged<ReelSoundModel> onSelect;

  const _PlaceholderEffects({required this.category, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final effects = _getPlaceholderEffects(category);
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: effects.length,
      itemBuilder: (context, index) {
        final effect = effects[index];
        return _SoundEffectTile(
          effect: effect,
          onTap: () => onSelect(effect),
        );
      },
    );
  }

  List<ReelSoundModel> _getPlaceholderEffects(String category) {
    switch (category) {
      case 'Transitions':
        return [
          ReelSoundModel(id: 'sfx_whoosh', title: 'Whoosh', durationMs: 500),
          ReelSoundModel(id: 'sfx_swoosh', title: 'Swoosh', durationMs: 400),
          ReelSoundModel(id: 'sfx_swipe', title: 'Swipe', durationMs: 300),
          ReelSoundModel(id: 'sfx_pop', title: 'Pop', durationMs: 200),
          ReelSoundModel(id: 'sfx_slide', title: 'Slide', durationMs: 600),
        ];
      case 'Comedy':
        return [
          ReelSoundModel(id: 'sfx_boing', title: 'Boing', durationMs: 400),
          ReelSoundModel(id: 'sfx_rimshot', title: 'Rimshot', durationMs: 1000),
          ReelSoundModel(id: 'sfx_laugh', title: 'Laugh Track', durationMs: 3000),
          ReelSoundModel(id: 'sfx_sad_trombone', title: 'Sad Trombone', durationMs: 2000),
          ReelSoundModel(id: 'sfx_fart', title: 'Fart', durationMs: 500),
        ];
      case 'Nature':
        return [
          ReelSoundModel(id: 'sfx_birds', title: 'Birds Chirping', durationMs: 5000),
          ReelSoundModel(id: 'sfx_ocean', title: 'Ocean Waves', durationMs: 8000),
          ReelSoundModel(id: 'sfx_rain', title: 'Rain', durationMs: 6000),
          ReelSoundModel(id: 'sfx_wind', title: 'Wind', durationMs: 4000),
          ReelSoundModel(id: 'sfx_thunder', title: 'Thunder', durationMs: 3000),
        ];
      default:
        return [
          ReelSoundModel(id: 'sfx_generic1', title: 'Effect 1', durationMs: 1000),
          ReelSoundModel(id: 'sfx_generic2', title: 'Effect 2', durationMs: 1500),
          ReelSoundModel(id: 'sfx_generic3', title: 'Effect 3', durationMs: 800),
        ];
    }
  }
}
