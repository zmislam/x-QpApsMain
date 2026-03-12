import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../extension/string/string_image_path.dart';
import '../../../../../components/reaction_list_tile.dart';
import '../../../../../config/constants/app_assets.dart';
import '../../../../../models/comment_reply_reaction.dart';
import '../../../../../config/constants/color.dart';
import '../../../../../routes/profile_navigator.dart';
import '../../../../../utils/post_utlis.dart';
import '../controllers/comment_replay_reactions_controller.dart';

class CommentReplayReactionsView
    extends GetView<CommentReplayReactionsController> {
  const CommentReplayReactionsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('People who reacted'.tr),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: DefaultTabController(
                length: 8,
                child: Column(
                  children: [
                    SizedBox(
                      height: 55,
                      width: Get.width,
                      child: TabBar(
                        tabAlignment: TabAlignment.start,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicator: const UnderlineTabIndicator(
                          borderSide: BorderSide(
                            width: 2,
                            color: PRIMARY_COLOR,
                          ),
                        ),
                        isScrollable: true,
                        dividerColor: Colors.grey,
                        tabs: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Text('All'.tr,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                Obx(() => Text(' ${controller.replyReactionList.value.length}'.tr)),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/icon/reaction/like_icon.png',
                                  height: 25,
                                  width: 25,
                                ),
                                Obx(() => Text(' ${controller.replyLikeList.value.length}'.tr)),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/icon/reaction/love_icon.png',
                                  height: 25,
                                  width: 25,
                                ),
                                Obx(() => Text(' ${controller.replyLoveList.value.length}'.tr)),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/icon/reaction/haha_icon.png',
                                  height: 25,
                                  width: 25,
                                ),
                                Obx(() => Text(' ${controller.replyHahaList.value.length}'.tr)),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/icon/reaction/wow_icon.png',
                                  height: 25,
                                  width: 25,
                                ),
                                Obx(() => Text(' ${controller.replyWowList.value.length}'.tr)),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/icon/reaction/sad_icon.png',
                                  height: 25,
                                  width: 25,
                                ),
                                Obx(() => Text(' ${controller.replySadList.value.length}'.tr)),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/icon/reaction/angry_icon.png',
                                  height: 25,
                                  width: 25,
                                ),
                                Obx(() => Text(' ${controller.replyAngryList.value.length}'.tr)),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Image.asset(
                                  AppAssets.UNLIKE_ICON,
                                  height: 25,
                                  width: 25,
                                ),
                                Obx(() => Text(' ${controller.replyUnlikeList.value.length}'.tr)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // ==================================== All Reaction List ============================//
                          Obx(() =>
                              controller.replyReactionList.value.isNotEmpty
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      physics: const ScrollPhysics(),
                                      itemCount: controller
                                          .replyReactionList.value.length,
                                      itemBuilder: (context, index) {
                                        ReplyReactions model = controller
                                            .replyReactionList.value[index];
                                        ReplyUserId? userIdModel = model.userId;

                                        return ReactionListTile(
                                          onTapViewProfile: () {
                                            ProfileNavigator.navigateToProfile(
                                                username:
                                                    userIdModel?.username ?? '',
                                                isFromReels: 'false');
                                          },
                                          name:
                                              '${userIdModel?.firstName} ${userIdModel?.lastName??''}',
                                          profilePicUrl: (
                                              userIdModel?.profilePic ?? '').formatedProfileUrl,
                                          reaction: getReactionIconPath(
                                            model.reactionType ?? '',
                                          ),
                                        );
                                      },
                                    )
                                  :  Center(
                                      child: Text('No Reaction'.tr),
                                    )),

                          // ==================================== Like Reaction List ============================//

                          Obx(() => controller.replyLikeList.value.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemCount:
                                      controller.replyLikeList.value.length,
                                  itemBuilder: (context, index) {
                                    ReplyReactions model =
                                        controller.replyLikeList.value[index];
                                    ReplyUserId userIdModel = model.userId!;

                                    return ReactionListTile(
                                      onTapViewProfile: () {
                                        ProfileNavigator.navigateToProfile(
                                            username:
                                                userIdModel.username ?? '',
                                            isFromReels: 'false');
                                      },
                                      name:
                                          '${userIdModel.firstName} ${userIdModel.lastName??''}',
                                      profilePicUrl: (
                                          userIdModel.profilePic ?? '').formatedProfileUrl,
                                      reaction: getReactionIconPath(
                                        model.reactionType ?? '',
                                      ),
                                    );
                                  },
                                )
                              :  Center(
                                  child: Text('No Reaction'.tr),
                                )),

                          //Text('Like'.tr),

                          // ==================================== Love Reaction List ============================//

                          Obx(() => controller.replyLoveList.value.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemCount:
                                      controller.replyLoveList.value.length,
                                  itemBuilder: (context, index) {
                                    ReplyReactions model =
                                        controller.replyLoveList.value[index];
                                    ReplyUserId userIdModel = model.userId!;

                                    return ReactionListTile(
                                      onTapViewProfile: () {
                                        ProfileNavigator.navigateToProfile(
                                            username:
                                                userIdModel.username ?? '',
                                            isFromReels: 'false');
                                      },
                                      name:
                                          '${userIdModel.firstName} ${userIdModel.lastName??''}',
                                      profilePicUrl: (
                                          userIdModel.profilePic ?? '').formatedProfileUrl,
                                      reaction: getReactionIconPath(
                                        model.reactionType ?? '',
                                      ),
                                    );
                                  },
                                )
                              :  Center(
                                  child: Text('No Reaction'.tr),
                                )),

                          //Text('Love'.tr),
                          // ==================================== Haha Reaction List ============================//

                          Obx(() => controller.replyHahaList.value.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemCount:
                                      controller.replyHahaList.value.length,
                                  itemBuilder: (context, index) {
                                    ReplyReactions model =
                                        controller.replyHahaList.value[index];

                                    debugPrint(
                                        '============Reply Reaction Haha Model $model=======================================================================');

                                    ReplyUserId userIdModel = model.userId!;

                                    return ReactionListTile(
                                      onTapViewProfile: () {
                                        ProfileNavigator.navigateToProfile(
                                            username:
                                                userIdModel.username ?? '',
                                            isFromReels: 'false');
                                      },
                                      name:
                                          '${userIdModel.firstName} ${userIdModel.lastName??''}',
                                      profilePicUrl: (
                                          userIdModel.profilePic ?? '').formatedProfileUrl,
                                      reaction: getReactionIconPath(
                                        model.reactionType ?? '',
                                      ),
                                    );
                                  },
                                )
                              :  Center(
                                  child: Text('No Reaction'.tr),
                                )),

                          //Text('Haha'.tr),

                          // ==================================== Wow Reaction List ============================//

                          Obx(() => controller.replyWowList.value.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemCount:
                                      controller.replyWowList.value.length,
                                  itemBuilder: (context, index) {
                                    ReplyReactions model =
                                        controller.replyWowList.value[index];
                                    ReplyUserId userIdModel = model.userId!;

                                    return ReactionListTile(
                                      onTapViewProfile: () {
                                        ProfileNavigator.navigateToProfile(
                                            username:
                                                userIdModel.username ?? '',
                                            isFromReels: 'false');
                                      },
                                      name:
                                          '${userIdModel.firstName} ${userIdModel.lastName??''}',
                                      profilePicUrl: (
                                          userIdModel.profilePic ?? '').formatedProfileUrl,
                                      reaction: getReactionIconPath(
                                        model.reactionType ?? '',
                                      ),
                                    );
                                  },
                                )
                              :  Center(
                                  child: Text('No Reaction'.tr),
                                )),

                          // Text('data'.tr),
                          // ==================================== Sad Reaction List ============================//

                          Obx(() => controller.replySadList.value.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemCount:
                                      controller.replySadList.value.length,
                                  itemBuilder: (context, index) {
                                    ReplyReactions model =
                                        controller.replySadList.value[index];
                                    ReplyUserId userIdModel = model.userId!;

                                    return ReactionListTile(
                                      onTapViewProfile: () {
                                        ProfileNavigator.navigateToProfile(
                                            username:
                                                userIdModel.username ?? '',
                                            isFromReels: 'false');
                                      },
                                      name:
                                          '${userIdModel.firstName} ${userIdModel.lastName??''}',
                                      profilePicUrl: (
                                          userIdModel.profilePic ?? '').formatedProfileUrl,
                                      reaction: getReactionIconPath(
                                        model.reactionType ?? '',
                                      ),
                                    );
                                  },
                                )
                              :  Center(
                                  child: Text('No Reaction'.tr),
                                )),

                          //Text("Sad".tr),

                          // ==================================== Angry Reaction List ============================//

                          Obx(() => controller.replyAngryList.value.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemCount:
                                      controller.replyAngryList.value.length,
                                  itemBuilder: (context, index) {
                                    ReplyReactions model =
                                        controller.replyAngryList.value[index];
                                    ReplyUserId userIdModel = model.userId!;

                                    return ReactionListTile(
                                      onTapViewProfile: () {
                                        ProfileNavigator.navigateToProfile(
                                            username:
                                                userIdModel.username ?? '',
                                            isFromReels: 'false');
                                      },
                                      name:
                                          '${userIdModel.firstName} ${userIdModel.lastName??''}',
                                      profilePicUrl: (
                                          userIdModel.profilePic ?? '').formatedProfileUrl,
                                      reaction: getReactionIconPath(
                                        model.reactionType ?? '',
                                      ),
                                    );
                                  },
                                )
                              :  Center(
                                  child: Text('No Reaction'.tr),
                                )),

                          //Text("Sad".tr),

                          // ==================================== Unlike Reaction List ============================//

                          //Text('Unlike'.tr)

                          Obx(() => controller.replyUnlikeList.value.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemCount:
                                      controller.replyUnlikeList.value.length,
                                  itemBuilder: (context, index) {
                                    ReplyReactions model =
                                        controller.replyUnlikeList.value[index];
                                    ReplyUserId userIdModel = model.userId!;

                                    return ReactionListTile(
                                      onTapViewProfile: () {
                                        ProfileNavigator.navigateToProfile(
                                            username:
                                                userIdModel.username ?? '',
                                            isFromReels: 'false');
                                      },
                                      name:
                                          '${userIdModel.firstName} ${userIdModel.lastName??''}',
                                      profilePicUrl: (
                                          userIdModel.profilePic ?? '').formatedProfileUrl,
                                      reaction: getReactionIconPath(
                                        model.reactionType ?? '',
                                      ),
                                    );
                                  },
                                )
                              :  Center(
                                  child: Text('No Reaction'.tr),
                                ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
