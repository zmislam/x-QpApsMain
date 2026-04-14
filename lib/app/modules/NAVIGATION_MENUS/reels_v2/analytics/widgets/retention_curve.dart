import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_analytics_controller.dart';

class RetentionCurve extends GetView<ReelsAnalyticsController> {
  const RetentionCurve({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = controller.retentionData;
      if (data.isEmpty) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text('No retention data',
                style: TextStyle(color: Colors.grey)),
          ),
        );
      }

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomPaint(
                size: const Size(double.infinity, 140),
                painter: _RetentionPainter(data: data),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('0%',
                    style: TextStyle(color: Colors.grey, fontSize: 11)),
                Text('25%',
                    style: TextStyle(color: Colors.grey, fontSize: 11)),
                Text('50%',
                    style: TextStyle(color: Colors.grey, fontSize: 11)),
                Text('75%',
                    style: TextStyle(color: Colors.grey, fontSize: 11)),
                Text('100%',
                    style: TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class _RetentionPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;

  _RetentionPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = Colors.green.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    final stepX =
        data.length > 1 ? size.width / (data.length - 1) : size.width;

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final pct = (data[i]['percentage'] ?? 100).toDouble().clamp(0.0, 100.0);
      final y = size.height - (pct / 100 * size.height);

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

    // Average retention line
    final avg = data.fold<double>(
          0,
          (prev, e) => prev + (e['percentage'] ?? 0).toDouble(),
        ) /
        data.length;
    final avgY = size.height - (avg / 100 * size.height);
    final avgPaint = Paint()
      ..color = Colors.orange.withOpacity(0.6)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
        Offset(0, avgY), Offset(size.width, avgY), avgPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
