import 'package:flutter/material.dart';
import '../../controllers/reels_editor_controller.dart';

/// Freehand drawing canvas overlay.
/// Captures touch points and renders strokes in real-time.
/// Supports multiple brush types and eraser mode.
class DrawingCanvas extends StatefulWidget {
  final List<DrawingStroke> strokes;
  final Color brushColor;
  final double brushSize;
  final bool isEraserMode;
  final ValueChanged<DrawingStroke> onStrokeAdded;
  final ValueChanged<int> onStrokeErased;

  const DrawingCanvas({
    super.key,
    required this.strokes,
    required this.brushColor,
    required this.brushSize,
    required this.isEraserMode,
    required this.onStrokeAdded,
    required this.onStrokeErased,
  });

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  List<Offset> _currentPoints = [];
  bool _isDrawing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: CustomPaint(
        painter: _DrawingPainter(
          strokes: widget.strokes,
          currentPoints: _currentPoints,
          currentColor: widget.brushColor,
          currentWidth: widget.brushSize,
          isDrawing: _isDrawing,
        ),
        size: Size.infinite,
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    if (widget.isEraserMode) {
      _tryEraseAt(details.localPosition);
      return;
    }
    setState(() {
      _isDrawing = true;
      _currentPoints = [details.localPosition];
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (widget.isEraserMode) {
      _tryEraseAt(details.localPosition);
      return;
    }
    setState(() {
      _currentPoints = [..._currentPoints, details.localPosition];
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (widget.isEraserMode) return;
    if (_currentPoints.length >= 2) {
      widget.onStrokeAdded(DrawingStroke(
        points: List.from(_currentPoints),
        color: widget.brushColor,
        width: widget.brushSize,
      ));
    }
    setState(() {
      _isDrawing = false;
      _currentPoints = [];
    });
  }

  void _tryEraseAt(Offset position) {
    const hitRadius = 20.0;
    for (int i = widget.strokes.length - 1; i >= 0; i--) {
      final stroke = widget.strokes[i];
      for (final point in stroke.points) {
        if ((point - position).distance < hitRadius) {
          widget.onStrokeErased(i);
          return;
        }
      }
    }
  }
}

class _DrawingPainter extends CustomPainter {
  final List<DrawingStroke> strokes;
  final List<Offset> currentPoints;
  final Color currentColor;
  final double currentWidth;
  final bool isDrawing;

  _DrawingPainter({
    required this.strokes,
    required this.currentPoints,
    required this.currentColor,
    required this.currentWidth,
    required this.isDrawing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw completed strokes
    for (final stroke in strokes) {
      _drawStroke(canvas, stroke.points, stroke.color, stroke.width);
    }

    // Draw current in-progress stroke
    if (isDrawing && currentPoints.length >= 2) {
      _drawStroke(canvas, currentPoints, currentColor, currentWidth);
    }
  }

  void _drawStroke(
    Canvas canvas,
    List<Offset> points,
    Color color,
    double width,
  ) {
    if (points.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    // Smooth curve through points using quadratic bezier
    for (int i = 1; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final midX = (p0.dx + p1.dx) / 2;
      final midY = (p0.dy + p1.dy) / 2;
      path.quadraticBezierTo(p0.dx, p0.dy, midX, midY);
    }

    // Last point
    if (points.length >= 2) {
      path.lineTo(points.last.dx, points.last.dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _DrawingPainter oldDelegate) {
    return oldDelegate.strokes != strokes ||
        oldDelegate.currentPoints != currentPoints ||
        oldDelegate.isDrawing != isDrawing;
  }
}
