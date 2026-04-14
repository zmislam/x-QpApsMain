import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../editor/controllers/reels_effects_controller.dart';
import 'filter_preview_tile.dart';

/// Horizontal scrollable carousel of 30+ filter presets with real-time preview.
class FilterCarousel extends StatelessWidget {
  const FilterCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReelsEffectsController>();
    final allFilters = _getAllFilters();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Intensity slider
        Obx(() {
          if (controller.selectedFilter.value == 'none') {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.tune, color: Colors.white70, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: Colors.white24,
                      thumbColor: Colors.white,
                      trackHeight: 2,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 6,
                      ),
                    ),
                    child: Slider(
                      value: controller.filterIntensity.value,
                      min: 0.0,
                      max: 1.0,
                      onChanged: (v) => controller.filterIntensity.value = v,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${(controller.filterIntensity.value * 100).round()}%',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          );
        }),
        // Category tabs
        SizedBox(
          height: 32,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              _CategoryChip(label: 'All', isSelected: true, onTap: () {}),
              _CategoryChip(label: 'Color', isSelected: false, onTap: () {}),
              _CategoryChip(label: 'Mood', isSelected: false, onTap: () {}),
              _CategoryChip(label: 'Vintage', isSelected: false, onTap: () {}),
              _CategoryChip(label: 'Film', isSelected: false, onTap: () {}),
              _CategoryChip(label: 'Artistic', isSelected: false, onTap: () {}),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Filter tiles
        SizedBox(
          height: 100,
          child: Obx(() {
            final selected = controller.selectedFilter.value;
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: allFilters.length,
              itemBuilder: (context, index) {
                final filter = allFilters[index];
                final isActive = selected == filter.id;
                return FilterPreviewTile(
                  filterId: filter.id,
                  filterName: filter.name,
                  colorMatrix: filter.matrix,
                  isSelected: isActive,
                  onTap: () {
                    controller.selectedFilter.value = filter.id;
                  },
                );
              },
            );
          }),
        ),
      ],
    );
  }

  List<FilterOption> _getAllFilters() {
    // 30+ filters: original 12 from effects controller + 20 additional
    return [
      ...ReelsEffectsController.availableFilters,
      // Additional color grading filters
      const FilterOption(id: 'clarendon', name: 'Clarendon', matrix: _clarendonMatrix),
      const FilterOption(id: 'gingham', name: 'Gingham', matrix: _ginghamMatrix),
      const FilterOption(id: 'moon', name: 'Moon', matrix: _moonMatrix),
      const FilterOption(id: 'lark', name: 'Lark', matrix: _larkMatrix),
      const FilterOption(id: 'reyes', name: 'Reyes', matrix: _reyesMatrix),
      const FilterOption(id: 'juno', name: 'Juno', matrix: _junoMatrix),
      const FilterOption(id: 'slumber', name: 'Slumber', matrix: _slumberMatrix),
      const FilterOption(id: 'crema', name: 'Crema', matrix: _cremaMatrix),
      const FilterOption(id: 'ludwig', name: 'Ludwig', matrix: _ludwigMatrix),
      const FilterOption(id: 'aden', name: 'Aden', matrix: _adenMatrix),
      const FilterOption(id: 'perpetua', name: 'Perpetua', matrix: _perpetuaMatrix),
      const FilterOption(id: 'amaro', name: 'Amaro', matrix: _amaroMatrix),
      const FilterOption(id: 'mayfair', name: 'Mayfair', matrix: _mayfairMatrix),
      const FilterOption(id: 'rise', name: 'Rise', matrix: _riseMatrix),
      const FilterOption(id: 'hudson', name: 'Hudson', matrix: _hudsonMatrix),
      const FilterOption(id: 'valencia', name: 'Valencia', matrix: _valenciaMatrix),
      const FilterOption(id: 'xpro2', name: 'X-Pro II', matrix: _xpro2Matrix),
      const FilterOption(id: 'sierra', name: 'Sierra', matrix: _sierraMatrix),
      const FilterOption(id: 'willow', name: 'Willow', matrix: _willowMatrix),
      const FilterOption(id: 'lofi', name: 'Lo-Fi', matrix: _lofiMatrix),
    ];
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.white12,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white70,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Additional Filter Matrices (5x4 ColorFilter) ──────────────────
// Each is a 20-element list for ColorFilter.matrix

const List<double> _clarendonMatrix = [
  1.2, 0, 0, 0, 10,
  0, 1.1, 0, 0, 5,
  0, 0, 1.3, 0, -5,
  0, 0, 0, 1, 0,
];

const List<double> _ginghamMatrix = [
  0.9, 0.1, 0, 0, 20,
  0.1, 0.9, 0, 0, 15,
  0, 0.1, 0.85, 0, 25,
  0, 0, 0, 1, 0,
];

const List<double> _moonMatrix = [
  0.33, 0.34, 0.33, 0, 10,
  0.33, 0.34, 0.33, 0, 10,
  0.33, 0.34, 0.33, 0, 20,
  0, 0, 0, 1, 0,
];

const List<double> _larkMatrix = [
  1.2, 0, 0, 0, 15,
  0, 1.05, 0, 0, 10,
  0, 0, 0.9, 0, 5,
  0, 0, 0, 1, 0,
];

const List<double> _reyesMatrix = [
  1.0, 0.05, 0.05, 0, 15,
  0.05, 0.95, 0.05, 0, 10,
  0.05, 0.05, 0.9, 0, 20,
  0, 0, 0, 0.9, 0,
];

const List<double> _junoMatrix = [
  1.2, 0, 0, 0, 0,
  0, 1.1, 0, 0, -10,
  0, 0, 0.85, 0, 10,
  0, 0, 0, 1, 0,
];

const List<double> _slumberMatrix = [
  0.9, 0.1, 0, 0, 5,
  0, 0.85, 0.1, 0, 10,
  0, 0, 0.9, 0, 15,
  0, 0, 0, 0.95, 0,
];

const List<double> _cremaMatrix = [
  1.05, 0.05, 0, 0, 10,
  0, 1.0, 0.05, 0, 10,
  0, 0, 0.95, 0, 15,
  0, 0, 0, 1, 0,
];

const List<double> _ludwigMatrix = [
  1.1, 0, 0, 0, -5,
  0, 1.05, 0, 0, 0,
  0, 0, 1.0, 0, 5,
  0, 0, 0, 1, 0,
];

const List<double> _adenMatrix = [
  0.95, 0.05, 0, 0, 15,
  0, 0.9, 0.1, 0, 10,
  0, 0.05, 0.85, 0, 20,
  0, 0, 0, 0.9, 0,
];

const List<double> _perpetuaMatrix = [
  1.0, 0.1, 0, 0, 5,
  0, 1.05, 0.1, 0, 0,
  0.05, 0, 1.1, 0, -5,
  0, 0, 0, 1, 0,
];

const List<double> _amaroMatrix = [
  1.15, 0.1, 0, 0, 5,
  0, 1.1, 0.05, 0, 0,
  0, 0, 0.95, 0, 10,
  0, 0, 0, 1, 0,
];

const List<double> _mayfairMatrix = [
  1.1, 0.05, 0, 0, 10,
  0, 1.0, 0.05, 0, 5,
  0, 0, 0.9, 0, 15,
  0, 0, 0, 1, 0,
];

const List<double> _riseMatrix = [
  1.1, 0.05, 0, 0, 15,
  0, 1.05, 0, 0, 10,
  0, 0, 0.9, 0, 5,
  0, 0, 0, 0.95, 0,
];

const List<double> _hudsonMatrix = [
  0.9, 0, 0.1, 0, 10,
  0, 0.95, 0.1, 0, 5,
  0.1, 0, 1.1, 0, -5,
  0, 0, 0, 1, 0,
];

const List<double> _valenciaMatrix = [
  1.1, 0.1, 0, 0, 10,
  0, 1.0, 0.05, 0, 5,
  0, 0, 0.85, 0, 15,
  0, 0, 0, 1, 0,
];

const List<double> _xpro2Matrix = [
  1.3, 0, 0, 0, -10,
  0, 1.0, 0, 0, 5,
  0, 0, 0.8, 0, 20,
  0, 0, 0, 1, 0,
];

const List<double> _sierraMatrix = [
  1.0, 0.1, 0, 0, 10,
  0, 0.95, 0.05, 0, 10,
  0, 0, 0.9, 0, 15,
  0, 0, 0, 0.9, 0,
];

const List<double> _willowMatrix = [
  0.4, 0.35, 0.25, 0, 10,
  0.3, 0.4, 0.3, 0, 10,
  0.25, 0.3, 0.45, 0, 10,
  0, 0, 0, 1, 0,
];

const List<double> _lofiMatrix = [
  1.3, 0, 0, 0, -15,
  0, 1.3, 0, 0, -15,
  0, 0, 1.3, 0, -15,
  0, 0, 0, 1, 0,
];
