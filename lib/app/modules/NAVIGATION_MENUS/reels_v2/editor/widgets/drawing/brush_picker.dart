import 'package:flutter/material.dart';

/// Brush picker for drawing tool.
/// Offers multiple brush types (pen, marker, neon, chalk, spray)
/// and a brush size slider.
class BrushPicker extends StatelessWidget {
  final String selectedBrush;
  final double brushSize;
  final Color brushColor;
  final ValueChanged<String> onBrushSelected;
  final ValueChanged<double> onSizeChanged;
  final ValueChanged<Color> onColorChanged;

  const BrushPicker({
    super.key,
    required this.selectedBrush,
    required this.brushSize,
    required this.brushColor,
    required this.onBrushSelected,
    required this.onSizeChanged,
    required this.onColorChanged,
  });

  static const List<_BrushOption> brushes = [
    _BrushOption('pen', 'Pen', Icons.edit, StrokeCap.round),
    _BrushOption('marker', 'Marker', Icons.format_paint, StrokeCap.square),
    _BrushOption('neon', 'Neon', Icons.auto_awesome, StrokeCap.round),
    _BrushOption('chalk', 'Chalk', Icons.texture, StrokeCap.butt),
    _BrushOption('spray', 'Spray', Icons.blur_on, StrokeCap.round),
  ];

  static const List<Color> colors = [
    Colors.white,
    Colors.black,
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Brush type selector
          SizedBox(
            height: 64,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: brushes.length,
              itemBuilder: (context, index) {
                final brush = brushes[index];
                final isActive = selectedBrush == brush.id;

                return GestureDetector(
                  onTap: () => onBrushSelected(brush.id),
                  child: Container(
                    width: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.blueAccent.withValues(alpha: 0.2)
                          : Colors.grey[800],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color:
                            isActive ? Colors.blueAccent : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          brush.icon,
                          color:
                              isActive ? Colors.blueAccent : Colors.white54,
                          size: 22,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          brush.label,
                          style: TextStyle(
                            color: isActive
                                ? Colors.blueAccent
                                : Colors.white54,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Brush size slider with preview
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Min size indicator
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: brushColor,
                    shape: BoxShape.circle,
                  ),
                ),
                // Slider
                Expanded(
                  child: Slider(
                    value: brushSize,
                    min: 1.0,
                    max: 30.0,
                    activeColor: Colors.blueAccent,
                    inactiveColor: Colors.grey[700],
                    onChanged: onSizeChanged,
                  ),
                ),
                // Max size indicator
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: brushColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Color picker row
          SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: colors.length,
              itemBuilder: (context, index) {
                final color = colors[index];
                final isSelected = brushColor == color;

                return GestureDetector(
                  onTap: () => onColorChanged(color),
                  child: Container(
                    width: 28,
                    height: 28,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? Colors.blueAccent
                            : color == Colors.white
                                ? Colors.grey
                                : Colors.transparent,
                        width: isSelected ? 2.5 : 1,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BrushOption {
  final String id;
  final String label;
  final IconData icon;
  final StrokeCap cap;
  const _BrushOption(this.id, this.label, this.icon, this.cap);
}
