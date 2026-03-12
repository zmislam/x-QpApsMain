import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../components/post_create/event_body.dart';
import '../controller/create_post_controller.dart';

class EducationTypeView extends GetView<CreatePostController> {
  const EducationTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> item = [
      'New School',
      'Graduate',
      'Post Graduated',
      'Left School',
    ];
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Create life event'.tr,
          ),
          // backgroundColor: Colors.white,
        ),
        body: EventBody(
          imageLink: 'assets/icon/live_event/education_event_icon.png',
          title: 'Education Life Event'.tr,
          item: item,
        ));
  }
}
