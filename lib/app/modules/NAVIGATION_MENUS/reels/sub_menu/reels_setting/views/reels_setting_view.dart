import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/reels_setting_controller.dart';

class ReelsSettingView extends GetView<ReelsSettingController> {
  const ReelsSettingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ReelsSettingView'.tr),
        centerTitle: true,
      ),
      body: Center(
        child: Text('ReelsSettingView is working'.tr,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
