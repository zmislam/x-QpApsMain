import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Reels V2 effects controller.
/// Manages: filters, color adjustments, audio mixing, speed effects,
/// visual effects (VHS, glitch, sparkle, etc.).
class ReelsEffectsController extends GetxController {
  // ─── Filter ────────────────────────────────────────────
  final RxString selectedFilter = 'none'.obs;
  final RxDouble filterIntensity = 1.0.obs;

  static const List<FilterOption> availableFilters = [
    FilterOption(id: 'none', name: 'Normal', matrix: null),
    FilterOption(id: 'warm', name: 'Warm', matrix: _warmMatrix),
    FilterOption(id: 'cool', name: 'Cool', matrix: _coolMatrix),
    FilterOption(id: 'vintage', name: 'Vintage', matrix: _vintageMatrix),
    FilterOption(id: 'bw', name: 'B&W', matrix: _bwMatrix),
    FilterOption(id: 'sepia', name: 'Sepia', matrix: _sepiaMatrix),
    FilterOption(id: 'vivid', name: 'Vivid', matrix: _vividMatrix),
    FilterOption(id: 'fade', name: 'Fade', matrix: _fadeMatrix),
    FilterOption(id: 'dramatic', name: 'Dramatic', matrix: _dramaticMatrix),
    FilterOption(id: 'golden', name: 'Golden', matrix: _goldenMatrix),
    FilterOption(id: 'noir', name: 'Noir', matrix: _noirMatrix),
    FilterOption(id: 'bloom', name: 'Bloom', matrix: _bloomMatrix),
  ];

  // ─── Color Adjustments ─────────────────────────────────
  final RxDouble brightness = 0.0.obs;
  final RxDouble contrast = 0.0.obs;
  final RxDouble saturation = 0.0.obs;
  final RxDouble warmth = 0.0.obs;
  final RxDouble sharpen = 0.0.obs;
  final RxDouble vignette = 0.0.obs;
  final RxDouble fade = 0.0.obs;
  final RxDouble highlights = 0.0.obs;
  final RxDouble shadows = 0.0.obs;

  // ─── Audio Mixing ─────────────────────────────────────
  final RxDouble originalVolume = 1.0.obs;
  final RxDouble musicVolume = 0.8.obs;
  final RxDouble voiceoverVolume = 0.0.obs;
  final RxBool isMuted = false.obs;
  final RxString? selectedSoundId = RxString('');
  final RxString? selectedSoundName = RxString('');

  // ─── Visual Effects ────────────────────────────────────
  final RxString selectedVisualEffect = 'none'.obs;
  final RxDouble effectIntensity = 1.0.obs;

  static const List<String> visualEffects = [
    'none',
    'vhs',
    'glitch',
    'sparkle',
    'rain',
    'snow',
    'hearts',
    'confetti',
    'blur_bg',
    'zoom_pulse',
    'shake',
    'film_grain',
  ];

  // ─── Speed Effects ─────────────────────────────────────
  final RxBool isSlowMotion = false.obs;
  final RxBool isTimeLapse = false.obs;
  final RxBool isBoomerang = false.obs;
  final RxBool isReverse = false.obs;

  // ═══════════════════════════════════════════════════════
  // FILTER OPERATIONS
  // ═══════════════════════════════════════════════════════

  void selectFilter(String filterId) {
    selectedFilter.value = filterId;
  }

  void setFilterIntensity(double intensity) {
    filterIntensity.value = intensity.clamp(0.0, 1.0);
  }

  FilterOption? get activeFilter {
    return availableFilters.firstWhereOrNull(
      (f) => f.id == selectedFilter.value,
    );
  }

  ColorFilter? get currentColorFilter {
    final filter = activeFilter;
    if (filter == null || filter.matrix == null) return null;
    return ColorFilter.matrix(
      _interpolateMatrix(filter.matrix!, filterIntensity.value),
    );
  }

  // ═══════════════════════════════════════════════════════
  // COLOR ADJUSTMENTS
  // ═══════════════════════════════════════════════════════

  void setBrightness(double value) => brightness.value = value.clamp(-1.0, 1.0);
  void setContrast(double value) => contrast.value = value.clamp(-1.0, 1.0);
  void setSaturation(double value) => saturation.value = value.clamp(-1.0, 1.0);
  void setWarmth(double value) => warmth.value = value.clamp(-1.0, 1.0);
  void setSharpen(double value) => sharpen.value = value.clamp(0.0, 1.0);
  void setVignette(double value) => vignette.value = value.clamp(0.0, 1.0);
  void setFade(double value) => fade.value = value.clamp(0.0, 1.0);
  void setHighlights(double value) => highlights.value = value.clamp(-1.0, 1.0);
  void setShadows(double value) => shadows.value = value.clamp(-1.0, 1.0);

  void resetAdjustments() {
    brightness.value = 0.0;
    contrast.value = 0.0;
    saturation.value = 0.0;
    warmth.value = 0.0;
    sharpen.value = 0.0;
    vignette.value = 0.0;
    fade.value = 0.0;
    highlights.value = 0.0;
    shadows.value = 0.0;
  }

  // ═══════════════════════════════════════════════════════
  // AUDIO MIXING
  // ═══════════════════════════════════════════════════════

  void setOriginalVolume(double vol) =>
      originalVolume.value = vol.clamp(0.0, 1.0);

  void setMusicVolume(double vol) =>
      musicVolume.value = vol.clamp(0.0, 1.0);

  void setVoiceoverVolume(double vol) =>
      voiceoverVolume.value = vol.clamp(0.0, 1.0);

  void toggleMute() => isMuted.toggle();

  void selectSound(String soundId, String soundName) {
    selectedSoundId?.value = soundId;
    selectedSoundName?.value = soundName;
  }

  void removeSound() {
    selectedSoundId?.value = '';
    selectedSoundName?.value = '';
  }

  // ═══════════════════════════════════════════════════════
  // VISUAL EFFECTS
  // ═══════════════════════════════════════════════════════

  void selectVisualEffect(String effect) {
    selectedVisualEffect.value = effect;
  }

  void setEffectIntensity(double intensity) {
    effectIntensity.value = intensity.clamp(0.0, 1.0);
  }

  void clearVisualEffect() {
    selectedVisualEffect.value = 'none';
    effectIntensity.value = 1.0;
  }

  // ═══════════════════════════════════════════════════════
  // SPEED EFFECTS
  // ═══════════════════════════════════════════════════════

  void toggleSlowMotion() {
    isSlowMotion.toggle();
    if (isSlowMotion.value) {
      isTimeLapse.value = false;
    }
  }

  void toggleTimeLapse() {
    isTimeLapse.toggle();
    if (isTimeLapse.value) {
      isSlowMotion.value = false;
    }
  }

  void toggleBoomerang() => isBoomerang.toggle();
  void toggleReverse() => isReverse.toggle();

  // ═══════════════════════════════════════════════════════
  // RESET ALL
  // ═══════════════════════════════════════════════════════

  void resetAll() {
    selectedFilter.value = 'none';
    filterIntensity.value = 1.0;
    resetAdjustments();
    originalVolume.value = 1.0;
    musicVolume.value = 0.8;
    voiceoverVolume.value = 0.0;
    isMuted.value = false;
    selectedVisualEffect.value = 'none';
    effectIntensity.value = 1.0;
    isSlowMotion.value = false;
    isTimeLapse.value = false;
    isBoomerang.value = false;
    isReverse.value = false;
  }

  // ═══════════════════════════════════════════════════════
  // FILTER MATRICES
  // ═══════════════════════════════════════════════════════

  static List<double> _interpolateMatrix(List<double> matrix, double intensity) {
    const identity = [
      1, 0, 0, 0, 0,
      0, 1, 0, 0, 0,
      0, 0, 1, 0, 0,
      0, 0, 0, 1, 0,
    ];
    return List.generate(20, (i) {
      return identity[i] + (matrix[i] - identity[i]) * intensity;
    });
  }

  static const List<double> _warmMatrix = [
    1.2, 0, 0, 0, 10,
    0, 1.0, 0, 0, 0,
    0, 0, 0.8, 0, -10,
    0, 0, 0, 1, 0,
  ];

  static const List<double> _coolMatrix = [
    0.8, 0, 0, 0, -10,
    0, 1.0, 0, 0, 0,
    0, 0, 1.2, 0, 10,
    0, 0, 0, 1, 0,
  ];

  static const List<double> _vintageMatrix = [
    0.9, 0.1, 0.1, 0, 10,
    0.1, 0.8, 0.1, 0, 5,
    0.0, 0.1, 0.7, 0, -5,
    0, 0, 0, 1, 0,
  ];

  static const List<double> _bwMatrix = [
    0.33, 0.33, 0.33, 0, 0,
    0.33, 0.33, 0.33, 0, 0,
    0.33, 0.33, 0.33, 0, 0,
    0, 0, 0, 1, 0,
  ];

  static const List<double> _sepiaMatrix = [
    0.393, 0.769, 0.189, 0, 0,
    0.349, 0.686, 0.168, 0, 0,
    0.272, 0.534, 0.131, 0, 0,
    0, 0, 0, 1, 0,
  ];

  static const List<double> _vividMatrix = [
    1.3, -0.1, -0.1, 0, 0,
    -0.1, 1.3, -0.1, 0, 0,
    -0.1, -0.1, 1.3, 0, 0,
    0, 0, 0, 1, 0,
  ];

  static const List<double> _fadeMatrix = [
    1.0, 0, 0, 0, 30,
    0, 1.0, 0, 0, 30,
    0, 0, 1.0, 0, 30,
    0, 0, 0, 0.9, 0,
  ];

  static const List<double> _dramaticMatrix = [
    1.4, -0.2, -0.1, 0, -15,
    -0.1, 1.3, -0.1, 0, -10,
    -0.1, -0.2, 1.4, 0, -10,
    0, 0, 0, 1, 0,
  ];

  static const List<double> _goldenMatrix = [
    1.2, 0.1, 0, 0, 15,
    0.05, 1.1, 0.05, 0, 10,
    0, 0, 0.9, 0, -5,
    0, 0, 0, 1, 0,
  ];

  static const List<double> _noirMatrix = [
    0.4, 0.4, 0.2, 0, -20,
    0.3, 0.4, 0.2, 0, -15,
    0.2, 0.3, 0.3, 0, -10,
    0, 0, 0, 1, 0,
  ];

  static const List<double> _bloomMatrix = [
    1.15, 0.05, 0.05, 0, 15,
    0.05, 1.15, 0.05, 0, 15,
    0.05, 0.05, 1.1, 0, 10,
    0, 0, 0, 1, 0,
  ];
}

// ─── Data Models ────────────────────────────────────────

class FilterOption {
  final String id;
  final String name;
  final List<double>? matrix;

  const FilterOption({
    required this.id,
    required this.name,
    this.matrix,
  });
}
