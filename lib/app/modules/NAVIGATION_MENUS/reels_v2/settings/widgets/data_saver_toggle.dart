import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_settings_controller.dart';

class DataSaverToggle extends GetView<ReelsSettingsController> {
  const DataSaverToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SwitchListTile(
        title: const Text('Data Saver'),
        subtitle: const Text('Lower video quality on cellular to save data'),
        secondary: const Icon(Icons.data_saver_on),
        value: controller.dataSaverEnabled.value,
        onChanged: controller.toggleDataSaver,
      );
    });
  }
}
