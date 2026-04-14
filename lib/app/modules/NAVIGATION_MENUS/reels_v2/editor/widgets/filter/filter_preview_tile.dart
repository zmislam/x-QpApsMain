import 'package:flutter/material.dart';

/// Individual filter preview tile showing a thumbnail with the filter applied.
class FilterPreviewTile extends StatelessWidget {
  final String filterId;
  final String filterName;
  final List<double>? colorMatrix;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterPreviewTile({
    super.key,
    required this.filterId,
    required this.filterName,
    this.colorMatrix,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Thumbnail with filter applied
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.transparent,
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: ColorFiltered(
                  colorFilter: colorMatrix != null
                      ? ColorFilter.matrix(colorMatrix!)
                      : const ColorFilter.mode(
                          Colors.transparent,
                          BlendMode.dst,
                        ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: _previewGradient(),
                    ),
                    child: filterId == 'none'
                        ? const Center(
                            child: Icon(
                              Icons.block,
                              color: Colors.white54,
                              size: 24,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            // Filter name
            SizedBox(
              width: 64,
              child: Text(
                filterName,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white60,
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LinearGradient _previewGradient() {
    // Sample gradient to simulate a scene for filter preview
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF1A237E),
        Color(0xFF4A148C),
        Color(0xFFFF6F00),
        Color(0xFFFFD54F),
      ],
      stops: [0.0, 0.33, 0.66, 1.0],
    );
  }
}
