import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_analytics_controller.dart';

class AudienceDemographicsWidget extends GetView<ReelsAnalyticsController> {
  const AudienceDemographicsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.audienceLoading.value) {
        return const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator(color: Colors.white)),
        );
      }

      final data = controller.audienceData.value;
      if (data == null) {
        return Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text('No audience data',
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
            // Gender breakdown
            const Text('Gender',
                style: TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 8),
            _buildGenderBar(data),
            const SizedBox(height: 20),

            // Age brackets
            const Text('Age',
                style: TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 8),
            ...data.ageBrackets.entries.map(
              (e) => _buildBar(e.key, e.value),
            ),
            const SizedBox(height: 20),

            // Top Cities
            const Text('Top Cities',
                style: TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 8),
            ...data.topCities.take(5).map(
                  (city) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(city['name'] ?? '',
                            style: const TextStyle(color: Colors.white)),
                        Text('${city['percentage'] ?? 0}%',
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),

            // Peak Hours
            if (data.peakHours.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text('Peak Hours',
                  style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: data.peakHours.map((h) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('${h.toString().padLeft(2, '0')}:00',
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 12)),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildGenderBar(dynamic data) {
    final male = data.genderMale;
    final female = data.genderFemale;
    final other = 100.0 - male - female;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 12,
            child: Row(
              children: [
                Expanded(
                  flex: male.round(),
                  child: Container(color: Colors.blue),
                ),
                Expanded(
                  flex: female.round(),
                  child: Container(color: Colors.pink),
                ),
                if (other > 0)
                  Expanded(
                    flex: other.round(),
                    child: Container(color: Colors.grey),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            _legendDot(Colors.blue, 'Male ${male.toStringAsFixed(0)}%'),
            const SizedBox(width: 16),
            _legendDot(Colors.pink, 'Female ${female.toStringAsFixed(0)}%'),
            if (other > 1) ...[
              const SizedBox(width: 16),
              _legendDot(Colors.grey, 'Other ${other.toStringAsFixed(0)}%'),
            ],
          ],
        ),
      ],
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
      ],
    );
  }

  Widget _buildBar(String label, double percentage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(label,
                style: const TextStyle(color: Colors.white, fontSize: 12)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: Colors.grey[800],
                color: Colors.blue,
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 35,
            child: Text('${percentage.toStringAsFixed(0)}%',
                style: const TextStyle(color: Colors.grey, fontSize: 11),
                textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}
