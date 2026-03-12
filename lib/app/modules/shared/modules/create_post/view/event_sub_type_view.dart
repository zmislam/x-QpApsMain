import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../components/post_create/event_sub_type_body.dart';
import '../controller/create_post_controller.dart';

class EventSubTypeView extends GetView<CreatePostController> {
  var eventTypeTitle = Get.arguments;

  EventSubTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.eventSubType.value = eventTypeTitle.toString();

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Create life event'.tr,
          ),
        ),
        body: SingleChildScrollView(
          child: EventSubTypeBody(
            imageLink: 'assets/icon/live_event/work_event_icon.png',
            title: eventTypeTitle,
            onPressed: () {
              controller.onTapCreateEventPost();
            },
            controller: controller,
          ),
        ));
  }
}
