import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../components/post_create/education_sub_type_body.dart';
import '../controller/create_post_controller.dart';

class EducationSubTypeView extends GetView<CreatePostController> {
  const EducationSubTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    String eventTypeTitle = Get.arguments;
    CreatePostController controller = Get.find();
    controller.eventSubType.value = eventTypeTitle;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Create life event'.tr,
          ),
          // backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: EducationSubTypeBody(
            imageLink: 'assets/icon/live_event/education_event_icon.png',
            title: eventTypeTitle,
            onPressed: () {
              controller.onTapCreateEventPost();
            },
            controller: controller,
          ),
        ));
  }
}
