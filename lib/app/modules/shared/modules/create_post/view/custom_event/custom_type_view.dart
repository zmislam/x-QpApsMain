import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/create_post_controller.dart';
import 'custom_type_body.dart';

class CustomTypeView extends StatelessWidget {
  const CustomTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    CreatePostController controller = Get.find();
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('Create life event'.tr,
          )),
      body: CustomTypeBody(
        imageLink: 'assets/icon/live_event/mileston_icon.png',
        title: 'Custom Event'.tr,
        onPressed: () {
          controller.eventType.value = 'customevent';
          controller.onTapCreateCustomPost();
        },
        controller: controller,
      ),
    );
  }
}
