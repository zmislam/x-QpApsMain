import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_privacy_controller.dart';
import '../widgets/privacy_dropdown_widget.dart';
import '../../../../config/constants/color.dart';

class PostPrivacyView extends GetView<SettingsPrivacyController> {
  const PostPrivacyView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getPostOrStoryPrivacy('timeline_post');

    final initialSeePost = controller.privacyModel.value.whoCanSee ?? 'public';
    final initialSharePost =
        controller.privacyModel.value.whoCanShare ?? 'public';
    final initialCommentPost =
        controller.privacyModel.value.whoCanComment ?? 'public';

    return Scaffold(
      appBar: AppBar(
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            color: Colors.grey,
            thickness: 1.0,
            height: 1.0,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        title: Text('Posts Privacy'.tr,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(
        () {
          if (controller.isPrivacyLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final privacy = controller.privacyModel.value;

          return Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
            child: SingleChildScrollView(
              // Wrap the Column in SingleChildScrollView
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Posts Privacy Settings'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(() {
                    return DropdownField(
                      label: 'Who can see'.tr,
                      value: controller.seePost.value.isNotEmpty
                          ? controller.seePost.value
                          : privacy.whoCanSee ??
                              'public', // Default to 'public'
                      onChanged: (value) {
                        controller.seePost.value = value!;
                      },
                    );
                  }),
                  const SizedBox(height: 20),
                  Obx(() {
                    return DropdownField(
                      label: 'Who can share'.tr,
                      value: controller.sharePost.value.isNotEmpty
                          ? controller.sharePost.value
                          : privacy.whoCanShare ??
                              'public', // Default to 'public'
                      onChanged: (value) {
                        controller.sharePost.value = value!;
                      },
                    );
                  }),
                  const SizedBox(height: 20),
                  Obx(() {
                    return DropdownField(
                      label: 'Who can comment'.tr,
                      value: controller.commentPost.value.isNotEmpty
                          ? controller.commentPost.value
                          : privacy.whoCanComment ??
                              'public', // Default to 'public'
                      onChanged: (value) {
                        controller.commentPost.value = value!;
                      },
                    );
                  }),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: PRIMARY_COLOR,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () {
                        // Send the previous value if no change
                        final seePostValue = controller.seePost.value.isEmpty
                            ? initialSeePost
                            : controller.seePost.value;
                        final sharePostValue =
                            controller.sharePost.value.isEmpty
                                ? initialSharePost
                                : controller.sharePost.value;
                        final commentPostValue =
                            controller.commentPost.value.isEmpty
                                ? initialCommentPost
                                : controller.commentPost.value;

                        controller.updatePrivacyInfo('timeline_post',
                            seePostValue, sharePostValue, commentPostValue);
                      },
                      child: Text('Update'.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
