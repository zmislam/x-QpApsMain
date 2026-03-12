import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/theme/core_app_theme.dart';
import '../controllers/feed_preferences_controller.dart';
import '../../../../utils/Localization/lib/app/modules/changeLanguage/views/change_language_view.dart';

class FeedPreferencesView extends GetView<FeedPreferencesController> {
  const FeedPreferencesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed Preferences'.tr),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Theme.of(context).appBarTheme.foregroundColor),
          onPressed: () => Get.back(),
        ),
        actions: [
          TextButton(
            onPressed: controller.resetToDefault,
            child: Text('Reset'.tr),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(context),
            const SizedBox(height: 24),
            Text(
              'Customize Your Feed'.tr,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Adjust the sliders below to train the algorithm according to your preferences.'.tr,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 24),
            Obx(() => _buildSlider(
                  context,
                  label: 'Viral Content',
                  value: controller.viralScore.value,
                  onChanged: (val) => controller.viralScore.value = val,
                  description: 'Prioritize popular and trending posts.',
                )),
            Obx(() => _buildSlider(
                  context,
                  label: 'Freshness',
                  value: controller.freshnessScore.value,
                  onChanged: (val) => controller.freshnessScore.value = val,
                  description: 'Prioritize the newest posts.',
                )),
            Obx(() => _buildSlider(
                  context,
                  label: 'Friends & Family',
                  value: controller.friendsFamilyScore.value,
                  onChanged: (val) => controller.friendsFamilyScore.value = val,
                  description: 'Prioritize posts from close connections.',
                )),
            Obx(() => _buildSlider(
                  context,
                  label: 'Discovery',
                  value: controller.discoveryScore.value,
                  onChanged: (val) => controller.discoveryScore.value = val,
                  description: 'Show me new pages and groups I might like.',
                )),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                    // controller.savePreferences
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Obx(
                  () => controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Save Preferences'.tr,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome, color: Theme.of(context).primaryColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Premium Feature',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'You have full control over your EdgeRank algorithm.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(
    BuildContext context, {
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label.tr,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            Text(
              '${(value * 100).toInt()}%',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          description.tr,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4.0,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
          ),
          child: Slider(
            value: value,
            onChanged: onChanged,
            activeColor: Theme.of(context).primaryColor,
            inactiveColor: Theme.of(context).primaryColor.withOpacity(0.2),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
