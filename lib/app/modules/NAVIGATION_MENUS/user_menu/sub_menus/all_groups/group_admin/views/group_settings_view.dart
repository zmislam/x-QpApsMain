import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../../../../../routes/app_pages.dart';

import '../controllers/group_settings_controller.dart';

class GroupSettingsView extends GetView<GroupSettingsController> {
  const GroupSettingsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // AdminPageController adminPageController = Get.find();
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        // backgroundColor: Colors.white,
        title: Text(' Group Settings '.tr,
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        leading: const BackButton(
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                // Get.to(() => const PageBasicInformatio());
                Get.toNamed(Routes.GROUP_BASIC_INFO,
                    arguments: controller.allGroupModel);
              },
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    Icon(Icons.info_outline),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Group Basic information'.tr)
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: () {
                Get.toNamed(Routes.GROUP_PRIVACY,
                    arguments: controller.allGroupModel);
              },
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    Icon(Icons.privacy_tip_outlined),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Group Privacy'.tr)
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            // InkWell(
            //   onTap: () {},
            //   child: Container(
            //     height: 50,
            //     width: double.infinity,
            //     decoration: BoxDecoration(
            //         border: Border.all(color: Colors.grey),
            //         borderRadius: BorderRadius.circular(10)),
            //     child: const Row(
            //       children: [
            //         SizedBox(
            //           width: 15,
            //         ),
            //         Icon(Icons.block_outlined),
            //         SizedBox(
            //           width: 10,
            //         ),
            //         Text('Blocking'.tr)
            //       ],
            //     ),
            //   ),
            // ),
            // const SizedBox(
            //   height: 15,
            // ),
   controller.groupProfileController.groupRole.value == 'admin'
                ?         InkWell(
              onTap: () {
                Get.toNamed(Routes.LIST_GROUP_ADMIN_MODERATOR,
                    arguments:{
                      'group_model': controller.allGroupModel,
                      'group_role': ''
                    });
              },
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    Icon(Icons.add_moderator_outlined),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Admin & Moderator'.tr)
                  ],
                ),
              ),
            ):const SizedBox(),
            const SizedBox(
              height: 15,
            ),
            controller.groupProfileController.groupRole.value == 'admin'
                ? InkWell(
                    onTap: () {
                      controller.deleteGroup();
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Delete Group'.tr,
                            style: TextStyle(color: Colors.red),
                          )
                        ],
                      ),
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
