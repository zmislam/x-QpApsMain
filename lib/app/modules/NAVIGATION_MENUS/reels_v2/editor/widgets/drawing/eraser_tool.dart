import 'package:flutter/material.dart';
import '../../controllers/reels_editor_controller.dart';

/// Eraser tool widget for the drawing canvas.
/// Non-destructive eraser that removes individual strokes
/// near the touch point. Shows eraser indicator cursor.
class EraserTool extends StatefulWidget {
  final List<DrawingStroke> strokes;
  final double eraserSize;
  final ValueChanged<int> onStrokeErased;
  final VoidCallback onClearAll;
  final ValueChanged<double> onSizeChanged;

  const EraserTool({
    super.key,
    required this.strokes,
    this.eraserSize = 20.0,
    required this.onStrokeErased,
    required this.onClearAll,
    required this.onSizeChanged,
  });

  @override
  State<EraserTool> createState() => _EraserToolState();
}

class _EraserToolState extends State<EraserTool> {
  Offset? _cursorPosition;
  bool _isErasing = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Eraser canvas area (transparent overlay)
        Expanded(
          child: GestureDetector(
            onPanStart: (details) {
              setState(() {
                _isErasing = true;
                _cursorPosition = details.localPosition;
              });
              _eraseAt(details.localPosition);
            },
            onPanUpdate: (details) {
              setState(() => _cursorPosition = details.localPosition);
              _eraseAt(details.localPosition);
            },
            onPanEnd: (_) {
              setState(() {
                _isErasing = false;
                _cursorPosition = null;
              });
            },
            child: CustomPaint(
              painter: _EraserCursorPainter(
                cursorPosition: _cursorPosition,
                eraserSize: widget.eraserSize,
                isActive: _isErasing,
              ),
              size: Size.infinite,
            ),
          ),
        ),
        // Eraser controls bar
        _buildControlBar(),
      ],
    );
  }

  void _eraseAt(Offset position) {
    for (int i = widget.strokes.length - 1; i >= 0; i--) {
      final stroke = widget.strokes[i];
      for (final point in stroke.points) {
        if ((point - position).distance < widget.eraserSize) {
          widget.onStrokeErased(i);
          return;
        }
      }
    }
  }

  Widget _buildControlBar() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.grey[900],
      child: Row(
        children: [
          // Eraser icon
          const Icon(Icons.auto_fix_normal, color: Colors.blueAccent, size: 22),
          const SizedBox(width: 8),
          const Text(
            'Eraser',
            style: TextStyle(color: Colors.blueAccent, fontSize: 14),
          ),
          const SizedBox(width: 16),
          // Size slider
          Expanded(
            child: Slider(
              value: widget.eraserSize,
              min: 10.0,
              max: 60.0,
              activeColor: Colors.blueAccent,
              inactiveColor: Colors.grey[700],
              onChanged: widget.onSizeChanged,
            ),
          ),
          // Clear all button
          TextButton.icon(
            onPressed: widget.strokes.isEmpty ? null : widget.onClearAll,
            icon: Icon(
              Icons.delete_sweep,
              color: widget.strokes.isEmpty
                  ? Colors.white24
                  : Colors.redAccent,
              size: 18,
            ),
            label: Text(
              'Clear all',
              style: TextStyle(
                color: widget.strokes.isEmpty
                    ? Colors.white24
                    : Colors.redAccent,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EraserCursorPainter extends CustomPainter {
  final Offset? cursorPosition;
  final double eraserSize;
  final bool isActive;

  _EraserCursorPainter({
    this.cursorPosition,
    required this.eraserSize,
    required this.isActive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (cursorPosition == null) return;

    // Eraser circle indicator
    final paint = Paint()
      ..color = isActive
          ? Colors.white.withValues(alpha: 0.4)
          : Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(cursorPosition!, eraserSize, paint);

    // Fill when erasing
    if (isActive) {
      final fillPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.1)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(cursorPosition!, eraserSize, fillPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _EraserCursorPainter oldDelegate) {
    return oldDelegate.cursorPosition != cursorPosition ||
        oldDelegate.isActive != isActive ||
        oldDelegate.eraserSize != eraserSize;
  }
}
