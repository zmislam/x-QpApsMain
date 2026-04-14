import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../editor/controllers/reels_effects_controller.dart';

/// Full adjustment sliders panel: brightness, contrast, saturation,
/// warmth, vignette, sharpen, fade, highlights, shadows.
class AdjustmentSliders extends StatelessWidget {
  const AdjustmentSliders({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReelsEffectsController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Reset button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => _resetAll(controller),
                  icon: const Icon(Icons.refresh, size: 16, color: Colors.white60),
                  label: const Text(
                    'Reset',
                    style: TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                ),
              ),
              _AdjustmentSlider(
                icon: Icons.brightness_6,
                label: 'Brightness',
                value: controller.brightness.value,
                min: -1.0,
                max: 1.0,
                onChanged: (v) => controller.brightness.value = v,
              ),
              _AdjustmentSlider(
                icon: Icons.contrast,
                label: 'Contrast',
                value: controller.contrast.value,
                min: -1.0,
                max: 1.0,
                onChanged: (v) => controller.contrast.value = v,
              ),
              _AdjustmentSlider(
                icon: Icons.color_lens,
                label: 'Saturation',
                value: controller.saturation.value,
                min: -1.0,
                max: 1.0,
                onChanged: (v) => controller.saturation.value = v,
              ),
              _AdjustmentSlider(
                icon: Icons.wb_sunny,
                label: 'Warmth',
                value: controller.warmth.value,
                min: -1.0,
                max: 1.0,
                onChanged: (v) => controller.warmth.value = v,
              ),
              _AdjustmentSlider(
                icon: Icons.vignette,
                label: 'Vignette',
                value: controller.vignette.value,
                min: 0.0,
                max: 1.0,
                onChanged: (v) => controller.vignette.value = v,
              ),
              _AdjustmentSlider(
                icon: Icons.blur_on,
                label: 'Sharpen',
                value: controller.sharpen.value,
                min: 0.0,
                max: 1.0,
                onChanged: (v) => controller.sharpen.value = v,
              ),
              _AdjustmentSlider(
                icon: Icons.gradient,
                label: 'Fade',
                value: controller.fade.value,
                min: 0.0,
                max: 1.0,
                onChanged: (v) => controller.fade.value = v,
              ),
              _AdjustmentSlider(
                icon: Icons.wb_incandescent,
                label: 'Highlights',
                value: controller.highlights.value,
                min: -1.0,
                max: 1.0,
                onChanged: (v) => controller.highlights.value = v,
              ),
              _AdjustmentSlider(
                icon: Icons.nights_stay,
                label: 'Shadows',
                value: controller.shadows.value,
                min: -1.0,
                max: 1.0,
                onChanged: (v) => controller.shadows.value = v,
              ),
            ],
          )),
    );
  }

  void _resetAll(ReelsEffectsController controller) {
    controller.brightness.value = 0.0;
    controller.contrast.value = 0.0;
    controller.saturation.value = 0.0;
    controller.warmth.value = 0.0;
    controller.vignette.value = 0.0;
    controller.sharpen.value = 0.0;
    controller.fade.value = 0.0;
    controller.highlights.value = 0.0;
    controller.shadows.value = 0.0;
  }
}

class _AdjustmentSlider extends StatelessWidget {
  final IconData icon;
  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const _AdjustmentSlider({
    required this.icon,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isCenter = min < 0; // centered sliders have negative min
    final displayValue = (value * 100).round();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.white54),
          const SizedBox(width: 8),
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: value != 0 ? Colors.white : Colors.white38,
                inactiveTrackColor: Colors.white12,
                thumbColor: Colors.white,
                trackHeight: 2,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              ),
              child: Slider(
                value: value,
                min: min,
                max: max,
                onChanged: onChanged,
              ),
            ),
          ),
          SizedBox(
            width: 36,
            child: Text(
              isCenter
                  ? (displayValue > 0 ? '+$displayValue' : '$displayValue')
                  : '$displayValue',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: value != 0 ? Colors.white : Colors.white38,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
