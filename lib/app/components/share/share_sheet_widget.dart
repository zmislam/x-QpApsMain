import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../modules/NAVIGATION_MENUS/reels/controllers/reels_controller.dart';
import '../../modules/NAVIGATION_MENUS/reels/model/reels_model.dart';
import '../../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/group_profile/components/custom_report_bottomsheet.dart';
import '../../data/login_creadential.dart';
import '../../routes/app_pages.dart';
import '../../config/constants/ui_string_constant.dart';
import '../../utils/bottom_sheet.dart';
import '../../utils/copy_to_clipboard_utils.dart';
import '../../utils/url_utils.dart';
import '../button.dart';
import '../image.dart';
import '../../config/constants/api_constant.dart';
import '../../config/constants/share_config.dart';
import '../../models/chat/required_info.dart';
import 'share_controller.dart';
import 'share_multi_sheet_widget.dart';
import '../../utils/chat_utils/chat_utils.dart';

class ShareSheetWidget extends StatelessWidget {
  final String? reelsId;
  final String? postId;
  final String userId;
  final String? report_id_key;
  final String? campaignId;
  final String? sharekey;
  const ShareSheetWidget(
      {super.key,
      this.reelsId,
      this.postId,
      required this.userId,
      this.campaignId,
      this.report_id_key, 
      this.sharekey});

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // Prevents unnecessary space
      children: [
        // ========================= top bar =================================
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
              Container(
                width: Get.width,
                padding: const EdgeInsetsDirectional.symmetric(
                    vertical: 8, horizontal: 8),
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black12, width: 0.5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        NetworkCircleAvatar(
                            imageUrl:
                                '${ApiConstant.SERVER_IP_PORT}/uploads/${controller.currentUserModel.profile_pic ?? ''}'),
                        const SizedBox(width: 12),
                        Text(
                          '${controller.currentUserModel.first_name} ${controller.currentUserModel.last_name}'
                              .tr,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    // ==================== description field ==========================
                    TextFormField(
                      cursorColor: Theme.of(context).primaryColor,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      controller: controller.shareDescriptionController,
                      minLines: 1,
                      maxLines: null,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 14, fontWeight: FontWeight.w400),
                      decoration: InputDecoration(
                          fillColor: Theme.of(context).scaffoldBackgroundColor,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          hintText: 'Say something about this'.tr,
                          hintStyle: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400)),
                    ),
                    const SizedBox(height: 16),

                    //* ================================================= SHARE NOW =================================
                    Align(
                      alignment: Alignment.bottomRight,
                      child: PrimaryButton(
                          onPressed: () {
                            // Find the reels controller (the one that holds reelsModelList)
                            final reelsController = Get.find<ReelsController>();

                            // Optimistically increment the share count for the reel
                            if (reelsId != null) {
                              final reelsIndex = reelsController
                                  .reelsModelList.value
                                  .indexWhere((reel) => reel.id == reelsId);
                              if (reelsIndex != -1) {
                                final current = reelsController
                                    .reelsModelList.value[reelsIndex];
                                final updated = current.copyWith(
                                  total_share_count:
                                      (current.total_share_count ?? 0) + 1,
                                );

                                // Make new list copy for reactive update
                                final updatedList = List<ReelsModel>.from(
                                    reelsController.reelsModelList.value);
                                updatedList[reelsIndex] = updated;
                                reelsController.reelsModelList.value =
                                    updatedList;
                              }

                              // Then call backend as usual
                              // If shareReelsOnNewsFeed returns a Future, you can await and rollback on failure.
                              reelsController.shareReelsOnNewsFeed(
                                  reelsId ?? '', sharekey ?? '');
                            }
                            // Handle post shares similarly
                            else if (postId != null) {
                              // If your posts list is elsewhere, find that controller and update similarly.
                              // For now just call existing method:
                              controller.shareUserPost(
                                postId ?? '',
                                desciption: controller
                                    .shareDescriptionController.text
                                    .trim(),
                              );
                            }
                          },
                          text: UiStringConstant.SHARE_NOW.tr,
                          verticalPadding: 12,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          horizontalPadding: 12),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 12),
        // ============================= send in qp messenger people list section ==================
        if (LoginCredential().getProfileSwitch() == false)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                  (controller.messengerUserList.value.length >
                          ShareConfig.HORIZONTAL_CHAT_USER_LENGTH)
                      ? ShareConfig.HORIZONTAL_CHAT_USER_LENGTH + 1
                      //TODO::::::::::::: Below Line is a temporary solution for users who didnot initiate messenger, need to be fixed later::::::::::::::::::::::::::://
                      // =================original was ShareConfig.HORIZONTAL_CHAT_USER_LENGTH

                      : controller.messengerUserList.value.length, (index) {
                RequiredInfo userData = getRequiredInfoFromChat(
                    controller.messengerUserList.value[index],
                    controller.currentUserModel.id ?? '');

                if (index < ShareConfig.HORIZONTAL_CHAT_USER_LENGTH) {
                  return Padding(
                    padding: const EdgeInsetsDirectional.only(end: 12),
                    child: InkWell(
                      onTap: () {
                        String reelsUrl = getShareableUrl();
                        controller.messengerUserList.value[index].isSelected =
                            true;
                        controller.messengerUserList.refresh();
                        controller.sendMessage(
                            controller.messengerUserList.value[index].id ??
                                'N/A',
                            reelsUrl);
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 64,
                            width: 64,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        userData.profilePicture.toString()),
                                    fit: BoxFit.cover),
                                shape: BoxShape.circle,
                                color: Colors.teal),
                          ),
                          const SizedBox(height: 4),
                          SizedBox(
                            width: 64,
                            child: Text(
                              userData.username ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return InkWell(
                    onTap: () {
                      Get.back();
                      showDraggableScrollableBottomSheet(
                        context,
                        child: ShareMultiSheetWidget(reelsId: reelsId ?? ''),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 64,
                          width: 64,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              shape: BoxShape.circle),
                          child: const Icon(Icons.more_horiz, size: 32),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'More'.tr,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  );
                }
              }),
            ),
          ),
        const SizedBox(height: 12),
        // // ============================= share to others platform section ==================
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // ========================= repost button =====================================

              IconButton(
                onPressed: () {
                  if (reelsId != null && report_id_key == 'reel_id') {
                    controller.repostReels(reelsId ?? '', sharekey ?? '');
                  } else if (postId != null) {
                    controller.shareUserPost(postId ?? '');
                  }
                },
                icon: Column(
                  children: [
                    Container(
                      height: 64,
                      width: 64,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: Color(0xff337677), shape: BoxShape.circle),
                      child: SvgPicture.asset(
                        'assets/icon/repost.svg',
                        height: 24,
                        width: 24,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Repost'.tr)
                  ],
                ),
              ),

              const SizedBox(width: 4),

              // ======================== copy button ========================================
              IconButton(
                onPressed: () {
                  CopyToClipboardUtils.copyToClipboard(
                      getShareableUrl(), 'Text');
                  Get.back();
                },
                icon: Column(
                  children: [
                    Container(
                        height: 64,
                        width: 64,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: Color(0xff2F5C77), shape: BoxShape.circle),
                        child: SvgPicture.asset(
                          'assets/icon/link.svg',
                          height: 24,
                          width: 24,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        )),
                    const SizedBox(height: 4),
                    Text('Copy'.tr)
                  ],
                ),
              ),
              const SizedBox(width: 4),
              // ======================== whatsApp button ====================================
              IconButton(
                onPressed: () {
                  UriUtils.shareToWhatsApp(getShareableUrl());
                  Get.back();
                },
                icon: Column(
                  children: [
                    Container(
                        height: 64,
                        width: 64,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: Color(0xff2CA521), shape: BoxShape.circle),
                        child: SvgPicture.asset(
                          'assets/icon/whatsapp.svg',
                          height: 24,
                          width: 24,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        )),
                    const SizedBox(height: 4),
                    Text('Whats App'.tr)
                  ],
                ),
              ),
              const SizedBox(width: 4),
              // ========================= facebook button ===================================
              IconButton(
                onPressed: () {
                  UriUtils.shareToFacebook(getShareableUrl());
                  Get.back();
                },
                icon: Column(
                  children: [
                    Container(
                        height: 64,
                        width: 64,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: Color(0xff39569A), shape: BoxShape.circle),
                        child: SvgPicture.asset(
                          'assets/icon/facebook.svg',
                          height: 24,
                          width: 24,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        )),
                    const SizedBox(height: 4),
                    Text('Facebook'.tr)
                  ],
                ),
              ),
              const SizedBox(width: 4),
              // ======================== instagram button ============================
              IconButton(
                onPressed: () {
                  UriUtils.shareToInstagram(getShareableUrl());
                  Get.back();
                },
                icon: Column(
                  children: [
                    Container(
                        height: 64,
                        width: 64,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: Color(0xff951CB8), shape: BoxShape.circle),
                        child: SvgPicture.asset(
                          'assets/icon/instagram.svg',
                          height: 24,
                          width: 24,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        )),
                    const SizedBox(height: 4),
                    Text('Instagram'.tr)
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),
        Row(
          children: [
            // ================= report button
            IconButton(
              onPressed: () async {
                Get.back();
                await controller.getReports();
                CustomReportBottomSheet.showReportOptions(
                  context: context,
                  pageReportList: controller.pageReportList.value,
                  selectedReportType: controller.selectedReportType,
                  selectedReportId: controller.selectedReportId,
                  reportDescription: controller.reportDescription,
                  onCancel: () {
                    Get.back();
                  },
                  reportAction: (String report_type_id, String report_type,
                      String page_id, String description) {
                    controller.reportAPost(
                        id_key: report_id_key,
                        report_type: report_type,
                        description: description,
                        post_id: postId,
                        report_type_id: report_type_id);
                  },
                );
              },
              icon: Column(
                children: [
                  Container(
                    height: 64,
                    width: 64,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: Color(0xffE5E7EA), shape: BoxShape.circle),
                    child: const Icon(Icons.flag_outlined,
                        color: Colors.black, size: 32),
                  ),
                  const SizedBox(height: 4),
                  Text('Report'.tr)
                ],
              ),
            ),
            const SizedBox(width: 8),
            // ====================== promote button
            (controller.currentUserModel.id == userId)
                // ||
                //         (campaignId != '') ||
                //         (campaignId != null))
                ? IconButton(
                    onPressed: () {
                      Get.back();
                      if (reelsId != null) {
                        Get.toNamed(Routes.BOOST_REELS, arguments: reelsId);
                      } else if (postId != null) {
                        Get.toNamed(Routes.BOOST_POST, arguments: postId);
                      }
                    },
                    icon: Column(
                      children: [
                        Container(
                          height: 64,
                          width: 64,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              color: Color(0xffE5E7EA), shape: BoxShape.circle),
                          child: const Icon(Icons.fireplace_outlined,
                              color: Colors.black, size: 32),
                        ),
                        const SizedBox(height: 4),
                        Text('Promote'.tr)
                      ],
                    ),
                  )
                : const SizedBox(),
          ],
        )
      ],
    );
  }
}
