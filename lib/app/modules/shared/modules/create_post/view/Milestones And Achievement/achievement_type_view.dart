import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Milestones%20And%20Achievement/achievement_type_body.dart';

import '../../controller/create_post_controller.dart';

class AchievementTypeView extends StatelessWidget {
  const AchievementTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    CreatePostController controller = Get.find();

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Create life event'.tr,
          ),
        ),
        body: AchievementTypeBody(
          imageLink: 'assets/icon/live_event/mileston_icon.png',
          title: 'Milestones And Achievements'.tr,
          onPressed: () {
            controller.eventType.value = 'milestonesandachievements';
            controller.onTapCreateAchievementPost();
          },
          controller: controller,
        ));
  }
}
