import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../components/dropdown.dart';
import '../../../../../../../data/post_local_data.dart';
import '../controllers/group_settings_controller.dart';
import '../../../../../../../config/constants/color.dart';

class GroupPrivacyView extends GetView<GroupSettingsController> {
  const GroupPrivacyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        // backgroundColor: Colors.white,
        title: Text(' Group Privacy'.tr,
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        leading: const BackButton(
          color: Colors.black,
        ),
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                Text('Group Privacy'.tr,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text('Group Type'.tr,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                SecondaryDropDownField(
                    list: groupPrivacyList,
                    hint: '',
                    onChanged: (changed) {
                      controller.selectedGroupPrivacy.value =
                          changed.toString();
                    },
                    selectedItem: controller.allGroupModel.value?.groupPrivacy
                            ?.capitalizeFirst ??
                        controller.selectedGroupPrivacy.value),
                const SizedBox(
                  height: 10,
                ),
                Text('Require Post Approval'.tr,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                SecondaryDropDownField(
                  list: onOffList,
                  hint: '',
                  onChanged: (changed) {},
                  selectedItem: onOffList.first,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text('Who Can Approve Group Posts?'.tr,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                SecondaryDropDownField(
                    list: groupAdminList,
                    hint: '',
                    onChanged: (changed) {
                      controller.selectedPostApprovalAuthority.value =
                          changed.toString();
                    },
                    selectedItem: controller.allGroupModel.value?.postApproveBy
                            ?.capitalizeFirst ??
                        controller.selectedPostApprovalAuthority.value),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: PRIMARY_COLOR,
                      borderRadius: BorderRadius.circular(10)),
                  child: TextButton(
                    onPressed: () {
                      controller.editGroupInfo();
                    },
                    child: Text('Save Changes'.tr,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
