import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_boost_controller.dart';

/// Widget for selecting the target audience for a boost campaign.
/// Supports automatic targeting or custom targeting (age, gender, interests, locations).
class BoostAudiencePicker extends GetView<ReelsBoostController> {
  const BoostAudiencePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      color: isDark ? Colors.grey[900] : Colors.grey[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Audience type toggle
                Row(
                  children: [
                    Expanded(
                      child: _audienceTypeChip(
                        context,
                        label: 'Automatic',
                        value: 'automatic',
                        icon: Icons.auto_awesome,
                        description: 'Let our system find the best audience',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _audienceTypeChip(
                        context,
                        label: 'Custom',
                        value: 'custom',
                        icon: Icons.tune,
                        description: 'Choose your target audience',
                      ),
                    ),
                  ],
                ),

                // Custom targeting options
                if (controller.audienceType.value == 'custom') ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),

                  // Age range
                  Text(
                    'Age Range',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RangeSlider(
                    values: RangeValues(
                      controller.minAge.value.toDouble(),
                      controller.maxAge.value.toDouble(),
                    ),
                    min: 13,
                    max: 65,
                    divisions: 52,
                    labels: RangeLabels(
                      '${controller.minAge.value}',
                      controller.maxAge.value >= 65
                          ? '65+'
                          : '${controller.maxAge.value}',
                    ),
                    onChanged: (range) {
                      controller.minAge.value = range.start.round();
                      controller.maxAge.value = range.end.round();
                    },
                  ),
                  Text(
                    '${controller.minAge.value} - ${controller.maxAge.value >= 65 ? "65+" : controller.maxAge.value}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 16),

                  // Gender
                  Text(
                    'Gender',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      {'value': 'all', 'label': 'All'},
                      {'value': 'male', 'label': 'Male'},
                      {'value': 'female', 'label': 'Female'},
                    ].map((opt) {
                      final isSelected = controller.gender.value == opt['value'];
                      return ChoiceChip(
                        label: Text(opt['label']!),
                        selected: isSelected,
                        onSelected: (_) =>
                            controller.gender.value = opt['value']!,
                        selectedColor:
                            Theme.of(context).primaryColor.withOpacity(0.15),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Interests
                  Text(
                    'Interests',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: _availableInterests.map((interest) {
                      final isSelected =
                          controller.interests.contains(interest);
                      return FilterChip(
                        label: Text(interest),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            controller.interests.add(interest);
                          } else {
                            controller.interests.remove(interest);
                          }
                        },
                        selectedColor:
                            Theme.of(context).primaryColor.withOpacity(0.15),
                        labelStyle: TextStyle(
                          fontSize: 12,
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : (isDark ? Colors.white60 : Colors.black54),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            )),
      ),
    );
  }

  Widget _audienceTypeChip(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required String description,
  }) {
    final isSelected = controller.audienceType.value == value;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => controller.audienceType.value = value,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.05)
              : null,
        ),
        child: Column(
          children: [
            Icon(icon,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey[500],
                size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : (isDark ? Colors.white70 : Colors.black87),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  static const List<String> _availableInterests = [
    'Technology',
    'Fashion',
    'Food',
    'Travel',
    'Fitness',
    'Music',
    'Gaming',
    'Beauty',
    'Photography',
    'Sports',
    'Business',
    'Art',
    'Education',
    'Health',
    'Entertainment',
  ];
}
