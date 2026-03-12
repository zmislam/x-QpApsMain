import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/custom_group_card.dart';
import '../../../routes/app_pages.dart';
import '../controllers/global_search_controller.dart';

class GroupSearch extends GetView<GlobalSearchController> {
    GroupSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.allGroupList.value.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text('Searched Groups'.tr,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GridView.builder(
                  physics:   NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate:   SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 250,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 0,
                  ),
                  itemCount: controller.allGroupList.value.length.clamp(0, 6),
                  itemBuilder: (context, index) {
                    final group = controller.allGroupList.value[index];
                    return CustomGroupCard(
                      groupCoverUrl: group.groupCoverPic ?? '',
                      groupName: group.groupName ?? '',
                      groupPrivacy: group.groupPrivacy ?? '',
                      joinedGroupsCount: group.joinedGroupsCount,
                      groupDescription: group.groupDescription ?? '',
                      groupId: group.id ?? '',
                      onTap: () {
                        Get.toNamed(Routes.GROUP_PROFILE, arguments: {
                          'id': group.id,
                          'group_type': '',
                        });
                      },
                    );
                  },
                ),
              ],
            )
          :   SizedBox(),
    );
  }
}
