import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_analytics_controller.dart';

class FollowerGrowthChart extends GetView<ReelsAnalyticsController> {
  const FollowerGrowthChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = controller.growthData;

      if (data.isEmpty) {
        // Load growth data on first render
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.loadGrowthData();
        });

        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text('Loading growth data...',
                style: TextStyle(color: Colors.grey)),
          ),
        );
      }

      final maxVal = data.fold<double>(
        0,
        (prev, e) =>
            (e['followers'] ?? 0).toDouble() > prev
                ? (e['followers'] ?? 0).toDouble()
                : prev,
      );

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Net: +${data.last['netGain'] ?? 0}',
                    style: const TextStyle(
                        color: Colors.green,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Total: ${_formatCount((data.last['total'] ?? 0))}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            const SizedBox(height: 12),
            Expanded(
              child: CustomPaint(
                size: const Size(double.infinity, 100),
                painter: _GrowthPainter(
                  data: data,
                  maxValue: maxVal > 0 ? maxVal : 1,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}

class _GrowthPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final double maxValue;

  _GrowthPainter({required this.data, required this.maxValue});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final barWidth = data.length > 0 ? (size.width / data.length) * 0.7 : 20.0;
    final gap = data.length > 0 ? (size.width / data.length) * 0.3 : 6.0;

    for (int i = 0; i < data.length; i++) {
      final val = (data[i]['followers'] ?? 0).toDouble();
      final barHeight = (val / maxValue) * size.height;
      final x = i * (barWidth + gap);
      final y = size.height - barHeight;

      final paint = Paint()
        ..color = val >= 0 ? Colors.green : Colors.red
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barWidth, barHeight.abs()),
          const Radius.circular(3),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
