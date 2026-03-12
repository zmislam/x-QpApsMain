import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../modules/shared/modules/create_post/view/Milestones%20And%20Achievement/achievement_type_view.dart';
import '../../modules/shared/modules/create_post/view/custom_event/custom_type_view.dart';
import '../../modules/shared/modules/create_post/view/travel/travel_sub_type_view.dart';

import '../../modules/shared/modules/create_post/view/education_sub_type_view.dart';
import '../../modules/shared/modules/create_post/view/event_sub_type_view.dart';
import '../../modules/shared/modules/create_post/view/relationship/relationship_sub_type_view.dart';

class EventBody extends StatelessWidget {
  const EventBody(
      {super.key,
      required this.item,
      required this.imageLink,
      required this.title});
  final List<String> item;
  final String imageLink;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Image.asset(
          imageLink,
          width: 60,
          height: 60,
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
          child: Divider(
            height: 1,
            color: Colors.grey.withValues(alpha: 0.5),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(
            item.length,
            (index) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 5),
                  child: GestureDetector(
                    onTap: () {
                      if (title.contains('Work')) {
                        Get.to(() => EventSubTypeView(),
                            arguments: item[index]);
                      } else if (title.contains('Relationship')) {
                        Get.to(() => const RelationshipSubTypeView(),
                            arguments: item[index]);
                      } else if (title.contains('Travel')) {
                        Get.to(() => const TravelSubTypeView(),
                            arguments: item[index]);
                      } else if (title
                          .contains('Milestones and Achievements')) {
                        Get.to(() => const AchievementTypeView(),
                            arguments: item[index]);
                      } else if (title.contains('Custom Event')) {
                        Get.to(() => const CustomTypeView(),
                            arguments: item[index]);
                      } else {
                        Get.to(() => const EducationSubTypeView(),
                            arguments: item[index]);
                      }
                    },
                    child: Text(
                      item[index].toUpperCase(),
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
                  child: Divider(
                    height: 1,
                    color: Colors.grey.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
