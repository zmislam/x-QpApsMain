import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'travel_sub_type_body.dart';

import '../../controller/create_post_controller.dart';

class TravelSubTypeView extends StatelessWidget {
  const TravelSubTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    String eventTypeTitle = Get.arguments;
    CreatePostController controller = Get.find();
    controller.eventSubType.value = eventTypeTitle;
    return Scaffold(
        // backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text('Create life event'.tr,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          // backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: TravelSubTypeBody(
            imageLink: 'assets/icon/live_event/travel.png',
            title: eventTypeTitle,
            onPressed: () {
              controller.onTapCreateTravelPost();
            },
            controller: controller,
          ),
        ));
  }
}
