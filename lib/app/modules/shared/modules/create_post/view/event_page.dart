import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'travel/travel_type_view.dart';

import '../../../../../utils/event_tile.dart';
import '../controller/create_post_controller.dart';
import 'Milestones And Achievement/achievement_type_view.dart';
import 'custom_event/custom_type_view.dart';
import 'education_type_view.dart';
import 'event_type_view.dart';
import 'relationship/relationship_type_view.dart';

class EventPage extends GetView<CreatePostController> {
  const EventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Life Events'.tr,
        ),
      ),
      body: Column(
        children: [
          Image.asset(
            'assets/icon/create_post/eventdashboard.png',
          ),
          const SizedBox(height: 16),
          Text('Share and remember important\nmoments from your life.'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              EventTile(
                name: 'Work',
                imageURL: 'assets/icon/create_post/work.png',
                onPressed: () {
                  controller.eventType.value = 'work';
                  Get.to(() => EventTypeView());
                },
              ),
              EventTile(
                name: 'Education',
                imageURL: 'assets/icon/create_post/education.png',
                onPressed: () {
                  controller.eventType.value = 'education';
                  Get.to(() => const EducationTypeView());
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              EventTile(
                name: 'Relationship',
                imageURL: 'assets/icon/create_post/love.png',
                onPressed: () {
                  controller.eventType.value = 'relationship';
                  Get.to(() => const RelationshipTypeView());
                },
              ),
              EventTile(
                name: 'Travel',
                imageURL: 'assets/icon/create_post/travel.png',
                onPressed: () {
                  controller.eventType.value = 'travel';
                  Get.to(() => const TravelTypeView());
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              EventTile(
                name: 'Milestones & Achievements',
                imageURL: 'assets/icon/create_post/education.png',
                onPressed: () {
                  controller.eventType.value = 'milestones and achievements';
                  Get.to(() => const AchievementTypeView());
                },
              ),
              EventTile(
                name: 'Custom Event',
                imageURL: 'assets/icon/create_post/interest.png',
                onPressed: () {
                  controller.eventType.value = 'Custom Event';
                  Get.to(() => const CustomTypeView());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
