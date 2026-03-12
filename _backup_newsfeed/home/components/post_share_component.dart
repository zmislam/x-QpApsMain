import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../components/button.dart';
import '../../../../components/image.dart';
import '../../../../components/image/svg_asset_picture.dart';
import '../../../../config/constants/api_constant.dart';
import '../../../../models/chat/chat_model.dart';
import '../../../../models/chat/participant_model.dart';
import '../controllers/home_controller.dart';

class PostShareComponent extends StatelessWidget {
  final VoidCallback? onRepost;
  final VoidCallback? onCopy;
  final VoidCallback? onShareWhatsApp;
  final VoidCallback? onShareFacebook;
  final VoidCallback? onShareInstagram;
  final VoidCallback? onReport;
  final VoidCallback? onPromote;
  final Rx<bool> isSend;

  const PostShareComponent(
      {this.onRepost,
      this.onCopy,
      this.onShareWhatsApp,
      this.onShareFacebook,
      this.onShareInstagram,
      this.onReport,
      this.onPromote,
      required this.isSend,
      super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<HomeController>();
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
                    color: Colors.black.withValues(alpha: 0.6),
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black12, width: 0.5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        NetworkCircleAvatar(
                            imageUrl:
                                '${ApiConstant.SERVER_IP_PORT}/uploads/${controller.loginCredential.getUserData().profile_pic ?? ''}'),
                        const SizedBox(width: 12),
                        Text('${controller.loginCredential.getUserData().first_name} ${controller.loginCredential.getUserData().last_name}'.tr,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    // ==================== description field ==========================
                    TextFormField(
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      controller: controller.descriptionController,
                      minLines: 1,
                      maxLines: null,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          hintText: 'Say something about this'.tr,
                          hintStyle: TextStyle(
                              color: Colors.black.withValues(alpha: 0.6),
                              fontSize: 14,
                              fontWeight: FontWeight.w400)),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: PrimaryButton(
                          onPressed: () {
                            controller.sharePost(
                                controller.descriptionController.text.trim());
                            Get.back();
                          },
                          text: 'Share Now'.tr,
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
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
                (controller.messengerUserList.value.length >
                        controller.userVisibleCount.value)
                    ? controller.userVisibleCount.value + 1
                    : controller.userVisibleCount.value, (index) {
              RequiredInfo userData = getRequiredInfoFromChat(
                  controller.messengerUserList.value[index], controller);

              if (index < controller.userVisibleCount.value) {
                return Padding(
                  padding: const EdgeInsetsDirectional.only(end: 12),
                  child: InkWell(
                    onTap: () {
                      controller.messengerUserList.value[index].isSelected =
                          true;
                      controller.messengerUserList.refresh();
                      controller.sendMessage(
                          controller.messengerUserList.value[index], '');
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
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
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
                    // customShareComponent(context,
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: [
                    //         // ========================== top bar ==========================
                    //         Align(
                    //           alignment: Alignment.topCenter,
                    //           child: Column(
                    //             crossAxisAlignment: CrossAxisAlignment.center,
                    //             children: [
                    //               SizedBox(
                    //                 height: 5,
                    //                 width: 30,
                    //                 child: DecoratedBox(
                    //                   decoration: BoxDecoration(
                    //                     color: Colors.black.withValues(alpha:0.6),
                    //                     borderRadius: BorderRadius.circular(12),
                    //                   ),
                    //                 ),
                    //               ),
                    //               const SizedBox(height: 12),
                    //               Text(
                    //                 'Send To',
                    //                 textAlign: TextAlign.center,
                    //                 style: TextStyle(
                    //                     color: Colors.black,
                    //                     fontSize: 16,
                    //                     fontWeight: FontWeight.w600),
                    //               )
                    //             ],
                    //           ),
                    //         ),
                    //         const SizedBox(height: 12),
                    //         // ============================= search field =======================
                    //         SearchBar(
                    //           shape: WidgetStatePropertyAll(
                    //             OutlinedBorder.lerp(
                    //               RoundedRectangleBorder(
                    //                 borderRadius: BorderRadius.circular(10),
                    //               ),
                    //               null,
                    //               0,
                    //             ),
                    //           ),
                    //           leading: const Icon(
                    //             Icons.search,
                    //           ),
                    //           hintText: 'Search'.tr,
                    //           elevation: WidgetStateProperty.all(0.0),
                    //           onChanged: (value) {
                    //             // controller.searchUsername.value = value;
                    //             // controller.searchChats(
                    //             //     controller.searchUsername.value);
                    //           },
                    //           textInputAction: TextInputAction.done,
                    //         ),
                    //         const SizedBox(height: 12),
                    //         // ============================= user list ==========================
                    //         Obx(
                    //           () => ListView.separated(
                    //             shrinkWrap: true,
                    //             itemCount:
                    //                 controller.messengerUserList.value.length,
                    //             physics: const NeverScrollableScrollPhysics(),
                    //             padding: EdgeInsets.zero,
                    //             separatorBuilder: (context, index) =>
                    //                 const SizedBox(height: 8),
                    //             itemBuilder: (context, index) {
                    //               RequiredInfo info = RequiredInfo();

                    //               info = getRequiredInfoFromChat(
                    //                   controller.messengerUserList.value[index],
                    //                   controller);

                    //               return Row(
                    //                 mainAxisAlignment:
                    //                     MainAxisAlignment.spaceBetween,
                    //                 children: [
                    //                   Expanded(
                    //                     child: Row(
                    //                       children: [
                    //                         NetworkCircleAvatar(
                    //                             imageUrl: info.profilePicture
                    //                                 .toString()),
                    //                         const SizedBox(width: 12),
                    //                         Expanded(
                    //                           child: Text(
                    //                             info.username ?? '',
                    //                             style: TextStyle(
                    //                                 color: Colors.black,
                    //                                 fontSize: 14,
                    //                                 fontWeight:
                    //                                     FontWeight.w600),
                    //                           ),
                    //                         )
                    //                       ],
                    //                     ),
                    //                   ),
                    //                   const SizedBox(width: 12),
                    //                   Checkbox(
                    //                       value: controller.messengerUserList
                    //                           .value[index].isSelected,
                    //                       onChanged: (value) {
                    //                         controller
                    //                             .messengerUserList
                    //                             .value[index]
                    //                             .isSelected = value ?? false;
                    //                         controller.messengerUserList
                    //                             .refresh();
                    //                       }),
                    //                 ],
                    //               );
                    //             },
                    //           ),
                    //         ),

                    //         const SizedBox(height: 16),
                    //         InkWell(
                    //           borderRadius: BorderRadius.circular(12),
                    //           onTap: () {
                    //             controller.sendMutipleMessage('');
                    //           },
                    //           child: Container(
                    //             width: Get.width,
                    //             alignment: Alignment.center,
                    //             padding: const EdgeInsetsDirectional.symmetric(
                    //                 vertical: 12, horizontal: 12),
                    //             decoration: BoxDecoration(
                    //                 color: Colors.teal,
                    //                 borderRadius: BorderRadius.circular(12)),
                    //             child: Obx(
                    //               () => isSend.value
                    //                   ? const Center(
                    //                       child: SizedBox(
                    //                         height: 14,
                    //                         width: 14,
                    //                         child: CircularProgressIndicator(
                    //                             color: Colors.white,
                    //                             strokeWidth: 2),
                    //                       ),
                    //                     )
                    //                   : Text(
                    //                       'Send',
                    //                       textAlign: TextAlign.center,
                    //                       style: TextStyle(
                    //                           color: Colors.white,
                    //                           fontSize: 14,
                    //                           fontWeight: FontWeight.w600),
                    //                     ),
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ));
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 64,
                        width: 64,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: Color(0xffE5E7EA), shape: BoxShape.circle),
                        child: const Icon(Icons.more_horiz,
                            color: Colors.black, size: 32),
                      ),
                      const SizedBox(height: 4),
                      Text('More'.tr,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                );
              }
            }),
          ),
        ),
        const SizedBox(height: 12),
        // ============================= share to others platform section ==================
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // ========================= repost button =====================================
              IconButton(
                onPressed: onRepost,
                icon: Column(
                  children: [
                    Container(
                      height: 64,
                      width: 64,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: Color(0xff337677), shape: BoxShape.circle),
                      child: const SvgAssetPicture(
                        path: 'assets/icon/repost.svg',
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
                onPressed: onCopy,
                icon: Column(
                  children: [
                    Container(
                        height: 64,
                        width: 64,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: Color(0xff2F5C77), shape: BoxShape.circle),
                        child: const SvgAssetPicture(
                          path: 'assets/icon/link.svg',
                        )),
                    const SizedBox(height: 4),
                    Text('Copy'.tr)
                  ],
                ),
              ),
              const SizedBox(width: 4),
              // ======================== whatsApp button ====================================
              IconButton(
                onPressed: onShareWhatsApp,
                icon: Column(
                  children: [
                    Container(
                        height: 64,
                        width: 64,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: Color(0xff2CA521), shape: BoxShape.circle),
                        child: const SvgAssetPicture(
                          path: 'assets/icon/whatsapp.svg',
                        )),
                    const SizedBox(height: 4),
                    Text('Whats App'.tr)
                  ],
                ),
              ),
              const SizedBox(width: 4),
              // ========================= facebook button ===================================
              IconButton(
                onPressed: onShareFacebook,
                icon: Column(
                  children: [
                    Container(
                        height: 64,
                        width: 64,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: Color(0xff39569A), shape: BoxShape.circle),
                        child: const SvgAssetPicture(
                          path: 'assets/icon/facebook.svg',
                        )),
                    const SizedBox(height: 4),
                    Text('Facebook'.tr)
                  ],
                ),
              ),
              const SizedBox(width: 4),
              // ======================== instagram button ============================
              IconButton(
                onPressed: onShareInstagram,
                icon: Column(
                  children: [
                    Container(
                        height: 64,
                        width: 64,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: Color(0xff951CB8), shape: BoxShape.circle),
                        child: const SvgAssetPicture(
                          path: 'assets/icon/instagram.svg',
                          height: 24,
                          width: 24,
                          color: Colors.white,
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
              onPressed: onReport,
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
            IconButton(
              onPressed: onPromote,
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
            ),
          ],
        )
      ],
    );
  }

  RequiredInfo getRequiredInfoFromChat(
      ChatModel chatModel, HomeController controller) {
    String userName = '';
    String profilePicture = '';
    if ((chatModel.isGroupChat == true) && (chatModel.page_id == null)) {
      userName = chatModel.name ?? '';
      profilePicture =
          '${ApiConstant.SERVER_IP_PORT}/uploads/group/${chatModel.cover_image ?? ''}';
    } else if ((chatModel.isGroupChat == true) && (chatModel.page_id != null)) {
      userName = chatModel.name ?? '';
      profilePicture =
          '${ApiConstant.SERVER_IP_PORT}/uploads/page/${chatModel.pageInfo?.profile_pic ?? ''}';
    } else {
      for (ParticipantModel participantModel in chatModel.participants ?? []) {
        if (participantModel.id !=
            controller.loginCredential.getUserData().id) {
          userName =
              '${participantModel.first_name ?? ''} ${participantModel.last_name ?? ''}';
          profilePicture =
              '${ApiConstant.SERVER_IP_PORT}/uploads/${participantModel.profile_pic ?? ''}';
        }
      }
    }

    return RequiredInfo(
      isGroupChat: chatModel.isGroupChat ?? false,
      username: userName,
      profilePicture: profilePicture,
    );
  }
}

class RequiredInfo {
  bool? isGroupChat;
  String? username;
  String? profilePicture;
  RequiredInfo({
    this.isGroupChat,
    this.username,
    this.profilePicture,
  });
}
