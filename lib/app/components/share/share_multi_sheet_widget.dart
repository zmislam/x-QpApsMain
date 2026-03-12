import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/constants/api_constant.dart';
import '../../models/chat/chat_model.dart';
import 'share_controller.dart';
import '../image.dart';
import '../../models/chat/required_info.dart';
import '../../utils/chat_utils/chat_utils.dart';

class ShareMultiSheetWidget extends StatelessWidget {
  final String? reelsId;
  final String? postId;
  const ShareMultiSheetWidget({
    super.key,
    this.reelsId,
    this.postId,
  });

  String getShareableUrl() {
    if (reelsId != null) {
      return '${ApiConstant.SERVER_IP}/reels?reels_id=$reelsId';
    } else if (postId != null) {
      return '${ApiConstant.SERVER_IP}/notification/$postId';
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ShareController controller = Get.find();
    controller.shareDescriptionController.clear();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ========================== top bar ==========================
        Align(
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 5,
                width: 30,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text('Send To'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
        const SizedBox(height: 12),
        // ============================= search field =======================
        SearchBar(
          shape: WidgetStatePropertyAll(
            OutlinedBorder.lerp(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              null,
              0,
            ),
          ),
          leading: const Icon(
            Icons.search,
          ),
          hintText: 'Search'.tr,
          elevation: WidgetStateProperty.all(0.0),
          onChanged: (value) {
            controller.searchChats(value);
          },
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: 12),
        // ============================= user list ==========================
        Obx(
          () => controller.messengerUserSearchList.value.isNotEmpty
              ? ListView.separated(
                  shrinkWrap: true,
                  itemCount: controller.messengerUserSearchList.value.length,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    RequiredInfo info = RequiredInfo();

                    info = getRequiredInfoFromChat(
                        controller.messengerUserSearchList.value[index],
                        controller.currentUserModel.id ?? '');

                    ChatModel chatModel =
                        controller.messengerUserSearchList.value[index];

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              NetworkCircleAvatar(
                                  imageUrl: info.profilePicture.toString()),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  info.username ?? '',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Checkbox(
                            value: chatModel.isSelected,
                            onChanged: (value) {
                              chatModel.isSelected = value ?? false;
                              controller.messengerUserSearchList.refresh();
                            }),
                      ],
                    );
                  },
                )
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: controller.messengerUserList.value.length,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    RequiredInfo info = RequiredInfo();

                    info = getRequiredInfoFromChat(
                        controller.messengerUserList.value[index],
                        controller.currentUserModel.id ?? '');
                    ChatModel chatModel =
                        controller.messengerUserList.value[index];

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              NetworkCircleAvatar(
                                  imageUrl: info.profilePicture.toString()),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  info.username ?? '',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Checkbox(
                            value: chatModel.isSelected,
                            onChanged: (value) {
                              chatModel.isSelected = value ?? false;
                              controller.messengerUserList.refresh();
                            }),
                      ],
                    );
                  },
                ),
        ),

        const SizedBox(height: 16),
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            controller.sendMutipleMessage(getShareableUrl());
          },
          child: Container(
            width: Get.width,
            alignment: Alignment.center,
            padding: const EdgeInsetsDirectional.symmetric(
                vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
                color: Colors.teal, borderRadius: BorderRadius.circular(12)),
            child: Text('Send'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
