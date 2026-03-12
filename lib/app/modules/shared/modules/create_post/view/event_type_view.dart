import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../components/post_create/event_body.dart';
import '../controller/create_post_controller.dart';

class EventTypeView extends GetView<CreatePostController> {
  List<String> item = ['New Job', 'Promotion', 'Left Job', 'Retirement'];

  EventTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          // iconTheme: const IconThemeData(
          //   color: Colors.black, //change your color here
          // ),
          title: Text('Create life event'.tr,
          ),
          // backgroundColor: Colors.white,
        ),
        body: EventBody(
          item: item,
          imageLink: 'assets/icon/live_event/work_event_icon.png',
          title: 'Work Life Event'.tr,
        ));
  }
}
