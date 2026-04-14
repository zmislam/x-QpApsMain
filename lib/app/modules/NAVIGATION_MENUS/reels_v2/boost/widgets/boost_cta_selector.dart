import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_boost_controller.dart';

/// Widget for selecting a CTA type and entering a destination URL
/// for a boost campaign.
class BoostCtaSelector extends GetView<ReelsBoostController> {
  const BoostCtaSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      color: isDark ? Colors.grey[900] : Colors.grey[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CTA type
            Text(
              'Button Label',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Obx(() => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ReelsBoostController.ctaOptions.map((opt) {
                    final isSelected =
                        controller.ctaType.value == opt['value'];
                    return ChoiceChip(
                      label: Text(opt['label']!),
                      selected: isSelected,
                      onSelected: (_) =>
                          controller.ctaType.value = opt['value']!,
                      selectedColor:
                          Theme.of(context).primaryColor.withOpacity(0.15),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : (isDark ? Colors.white70 : Colors.black54),
                      ),
                    );
                  }).toList(),
                )),
            const SizedBox(height: 20),

            // Destination URL
            Text(
              'Destination URL',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              onChanged: (v) => controller.ctaUrl.value = v,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                hintText: 'https://yourwebsite.com',
                hintStyle: TextStyle(
                    fontSize: 13, color: Colors.grey[400]),
                prefixIcon: Icon(Icons.link, color: Colors.grey[500]),
                filled: true,
                fillColor: isDark ? Colors.grey[800] : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor, width: 1.5),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
