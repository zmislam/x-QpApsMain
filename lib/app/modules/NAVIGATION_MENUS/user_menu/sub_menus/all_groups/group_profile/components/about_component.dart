import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/group_profile_controller.dart';

class GroupProfileAboutComponent extends StatelessWidget {
  final GroupProfileController controller;

  const GroupProfileAboutComponent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text('About'.tr,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              controller.allGroupModel.value?.groupDescription ?? '',
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              maxLines: 15,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                const Icon(
                  Icons.public,
                  size: 30,
                ),
                const SizedBox(width: 5),
                Text(
                  controller
                          .allGroupModel.value?.groupPrivacy?.capitalizeFirst ??
                      '',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          const Padding(
            padding: EdgeInsets.only(left: 40),
            child: Text(
              'Anyone can see who\'s in the group and what they post.',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Icon(
                  Icons.visibility,
                  size: 30,
                ),
                SizedBox(width: 5),
                Text('Visible'.tr,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          const Padding(
            padding: EdgeInsets.only(left: 40),
            child: Text(
              'Anyone can see who\'s in the group and what they post.',
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Icon(
                  Icons.history,
                  size: 30,
                ),
                SizedBox(width: 10),
                Text('Location'.tr,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Text(
              controller.allGroupModel.value?.location?.capitalizeFirst ?? '',
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
