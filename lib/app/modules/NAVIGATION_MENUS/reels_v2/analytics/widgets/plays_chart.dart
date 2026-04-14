import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_analytics_controller.dart';

class PlaysChart extends GetView<ReelsAnalyticsController> {
  const PlaysChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final ov = controller.overview.value;
      if (ov == null || ov.playsOverTime.isEmpty) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text('No play data available',
                style: TextStyle(color: Colors.grey)),
          ),
        );
      }

      final dataPoints = ov.playsOverTime;
      final maxVal = dataPoints.fold<double>(
        0,
        (prev, e) => (e['count'] ?? 0).toDouble() > prev
            ? (e['count'] ?? 0).toDouble()
            : prev,
      );

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomPaint(
          size: const Size(double.infinity, 160),
          painter: _LineChartPainter(
            data: dataPoints,
            maxValue: maxVal > 0 ? maxVal : 1,
            lineColor: Colors.blue,
          ),
        ),
      );
    });
  }
}

class _LineChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final double maxValue;
  final Color lineColor;

  _LineChartPainter({
    required this.data,
    required this.maxValue,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = lineColor.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    final stepX = data.length > 1 ? size.width / (data.length - 1) : size.width;

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = size.height -
          ((data[i]['count'] ?? 0).toDouble() / maxValue * size.height);

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo((data.length - 1) * stepX, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    // Draw dots
    final dotPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = size.height -
          ((data[i]['count'] ?? 0).toDouble() / maxValue * size.height);
      canvas.drawCircle(Offset(x, y), 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
