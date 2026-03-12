import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../../../../../config/constants/color.dart';

import '../components/privacy_row.dart';
import '../controllers/story_settings_controller.dart';

class StorySettingsView extends GetView<StorySettingsController> {
  const StorySettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Settings'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  //======================================================= Done Button ===========================================
                  TextButton(
                    onPressed: () {
                      Get.back(result: {
                        'selected_privacy': controller.privacyGroupValue.value
                      });
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: PRIMARY_COLOR,
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text('Done'.tr),
                  )
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Who can view this story?'.tr,
                      style: TextStyle(fontSize: 16),
                    ),
                    PrivacyRow<String>(
                      value: 'public',
                      groupValue: controller.privacyGroupValue.value,
                      onChanged: controller.onChangePrivacy,
                      child: Row(
                        children: [
                          Icon(
                            Icons.public,
                            color:
                                controller.privacyGroupValue.value == 'public'
                                    ? PRIMARY_COLOR
                                    : Colors.black,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text('Public'.tr,
                            style: TextStyle(
                              color:
                                  controller.privacyGroupValue.value == 'public'
                                      ? PRIMARY_COLOR
                                      : Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                    PrivacyRow<String>(
                      value: 'friends',
                      groupValue: controller.privacyGroupValue.value,
                      onChanged: controller.onChangePrivacy,
                      child: Row(
                        children: [
                          Icon(
                            Icons.people,
                            color:
                                controller.privacyGroupValue.value == 'friends'
                                    ? PRIMARY_COLOR
                                    : Colors.black,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text('Friends'.tr,
                            style: TextStyle(
                              color: controller.privacyGroupValue.value ==
                                      'friends'
                                  ? PRIMARY_COLOR
                                  : Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                    PrivacyRow<String>(
                      value: 'only_me',
                      groupValue: controller.privacyGroupValue.value,
                      onChanged: controller.onChangePrivacy,
                      child: Row(
                        children: [
                          Icon(
                            Icons.lock,
                            color:
                                controller.privacyGroupValue.value == 'only_me'
                                    ? PRIMARY_COLOR
                                    : Colors.black,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text('Only Me'.tr,
                            style: TextStyle(
                              color: controller.privacyGroupValue.value ==
                                      'only_me'
                                  ? PRIMARY_COLOR
                                  : Colors.black,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
