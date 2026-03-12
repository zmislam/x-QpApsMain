import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/create_post_controller.dart';
import 'travel_sub_type_body.dart';

class TravelTypeView extends StatelessWidget {
  const TravelTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    CreatePostController controller = Get.find();

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Create life event'.tr,
          ),
        ),
        body: TravelSubTypeBody(
            imageLink: 'assets/icon/live_event/travel_icon.png',
            title: 'Travel Life Event'.tr,
            onPressed: () {
              controller.onTapCreateTravelPost();
            },
            controller: controller));
  }
}
