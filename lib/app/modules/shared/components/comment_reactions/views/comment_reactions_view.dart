import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../extension/string/string_image_path.dart';
import '../../../../../components/reaction_list_tile.dart';
import '../../../../../config/constants/app_assets.dart';
import '../../../../../models/comment_reaction_model.dart';
import '../../../../../config/constants/color.dart';
import '../../../../../routes/profile_navigator.dart';
import '../../../../../utils/post_utlis.dart';
import '../controllers/comment_reactions_controller.dart';

class CommentReactionsView extends GetView<CommentReactionsController> {
  const CommentReactionsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.white,
        appBar: AppBar(
          // backgroundColor: Colors.white,
          title: Text('People who reacted'.tr,
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () => Get.back(),
          ),
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
                                Obx(() => Text(' ${controller.reactionList.value.length}'.tr)),
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
                                Obx(() => Text(' ${controller.likeList.value.length}'.tr)),
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
                                Obx(() => Text(' ${controller.loveList.value.length}'.tr)),
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
                                Obx(() => Text(' ${controller.hahaList.value.length}'.tr)),
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
                                Obx(() => Text(' ${controller.wowList.value.length}'.tr)),
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
                                Obx(() => Text(' ${controller.sadList.value.length}'.tr)),
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
                                Obx(() => Text(' ${controller.angryList.value.length}'.tr)),
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
                                Obx(() => Text(' ${controller.unlikeList.value.length}'.tr)),
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

                          Obx(() => controller.reactionList.value.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemCount:
                                      controller.reactionList.value.length,
                                  itemBuilder: (context, index) {
                                    CommentReactions model =
                                        controller.reactionList.value[index];
                                    UserId userIdModel = model.userId;

                                    return ReactionListTile(
                                      onTapViewProfile: () {
                                        ProfileNavigator.navigateToProfile(
                                            username: userIdModel.username,
                                            isFromReels: 'false');
                                      },
                                      name:
                                          '${userIdModel.firstName} ${userIdModel.lastName}',
                                      profilePicUrl: (
                                          userIdModel.profilePic).formatedProfileUrl,
                                      reaction: getReactionIconPath(
                                          model.reactionType),
                                    );
                                  },
                                )
                              :  Center(
                                  child: Text('No Reaction'.tr),
                                )),

                          // ==================================== Like Reaction List ============================//

                          Obx(() => controller.likeList.value.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemCount: controller.likeList.value.length,
                                  itemBuilder: (context, index) {
                                    CommentReactions model =
                                        controller.likeList.value[index];
                                    UserId userIdModel = model.userId;

                                    return ReactionListTile(
                                      onTapViewProfile: () {
                                        ProfileNavigator.navigateToProfile(
                                            username: userIdModel.username,
                                            isFromReels: 'false');
                                      },
                                      name:
                                          '${userIdModel.firstName} ${userIdModel.lastName}',
                                      profilePicUrl: (
                                          userIdModel.profilePic).formatedProfileUrl,
                                      reaction: getReactionIconPath(
                                        model.reactionType,
                                      ),
                                    );
                                  },
                                )
                              :  Center(
                                  child: Text('No Reaction'.tr),
                                )),

                          //Text('Like'.tr),

                          // ==================================== Love Reaction List ============================//

                          Obx(() => controller.loveList.value.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemCount: controller.loveList.value.length,
                                  itemBuilder: (context, index) {
                                    CommentReactions model =
                                        controller.loveList.value[index];
                                    UserId userIdModel = model.userId;

                                    return ReactionListTile(
                                      onTapViewProfile: () {
                                        ProfileNavigator.navigateToProfile(
                                            username: userIdModel.username,
                                            isFromReels: 'false');
                                      },
                                      name:
                                          '${userIdModel.firstName} ${userIdModel.lastName}',
                                      profilePicUrl: (
                                          userIdModel.profilePic).formatedProfileUrl,
                                      reaction: getReactionIconPath(
                                        model.reactionType,
                                      ),
                                    );
                                  },
                                )
                              :  Center(
                                  child: Text('No Reaction'.tr),
                                )),

                          //Text('Love'.tr),
                          // ==================================== Haha Reaction List ============================//

                          Obx(() => controller.hahaList.value.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemCount: controller.hahaList.value.length,
                                  itemBuilder: (context, index) {
                                    CommentReactions model =
                                        controller.hahaList.value[index];
                                    UserId userIdModel = model.userId;

                                    return ReactionListTile(
                                      onTapViewProfile: () {
                                        ProfileNavigator.navigateToProfile(
                                            username: userIdModel.username,
                                            isFromReels: 'false');
                                      },
                                      name:
                                          '${userIdModel.firstName} ${userIdModel.lastName}',
                                      profilePicUrl: (
                                          userIdModel.profilePic).formatedProfileUrl,
                                      reaction: getReactionIconPath(
                                        model.reactionType,
                                      ),
                                    );
                                  },
                                )
                              :  Center(
                                  child: Text('No Reaction'.tr),
                                )),

                          //Text('Haha'.tr),

                          // ==================================== Wow Reaction List ============================//

                          Obx(() => controller.wowList.value.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemCount: controller.wowList.value.length,
                                  itemBuilder: (context, index) {
                                    CommentReactions model =
                                        controller.wowList.value[index];
                                    UserId userIdModel = model.userId;

                                    return ReactionListTile(
                                      onTapViewProfile: () {
                                        ProfileNavigator.navigateToProfile(
                                            username: userIdModel.username,
                                            isFromReels: 'false');
                                      },
                                      name:
                                          '${userIdModel.firstName} ${userIdModel.lastName}',
                                      profilePicUrl: (
                                          userIdModel.profilePic).formatedProfileUrl,
                                      reaction: getReactionIconPath(
                                        model.reactionType,
                                      ),
                                    );
                                  },
                                )
                              :  Center(
                                  child: Text('No Reaction'.tr),
                                )),

                          // Text('data'.tr),
                          // ==================================== Sad Reaction List ============================//

                          Obx(() => controller.sadList.value.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemCount: controller.sadList.value.length,
                                  itemBuilder: (context, index) {
                                    CommentReactions model =
                                        controller.sadList.value[index];
                                    UserId userIdModel = model.userId;
                                    return ReactionListTile(
                                      onTapViewProfile: () {
                                        ProfileNavigator.navigateToProfile(
                                            username: userIdModel.username,
                                            isFromReels: 'false');
                                      },
                                      name:
                                          '${userIdModel.firstName} ${userIdModel.lastName}',
                                      profilePicUrl: (
                                          userIdModel.profilePic).formatedProfileUrl,
                                      reaction: getReactionIconPath(
                                        model.reactionType,
                                      ),
                                    );
                                  },
                                )
                              :  Center(
                                  child: Text('No Reaction'.tr),
                                )),

                          //Text("Sad".tr),

                          // ==================================== Angry Reaction List ============================//

                          Obx(() => controller.angryList.value.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemCount: controller.angryList.value.length,
                                  itemBuilder: (context, index) {
                                    CommentReactions model =
                                        controller.angryList.value[index];
                                    UserId userIdModel = model.userId;

                                    return ReactionListTile(
                                      onTapViewProfile: () {
                                        ProfileNavigator.navigateToProfile(
                                            username: userIdModel.username,
                                            isFromReels: 'false');
                                      },
                                      name:
                                          '${userIdModel.firstName} ${userIdModel.lastName}',
                                      profilePicUrl: (
                                          userIdModel.profilePic).formatedProfileUrl,
                                      reaction: getReactionIconPath(
                                        model.reactionType,
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

                          Obx(() => controller.unlikeList.value.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemCount: controller.unlikeList.value.length,
                                  itemBuilder: (context, index) {
                                    CommentReactions model =
                                        controller.unlikeList.value[index];
                                    UserId userIdModel = model.userId;

                                    return ReactionListTile(
                                      onTapViewProfile: () {
                                        ProfileNavigator.navigateToProfile(
                                            username: userIdModel.username,
                                            isFromReels: 'false');
                                      },
                                      name:
                                          '${userIdModel.firstName} ${userIdModel.lastName}',
                                      profilePicUrl: (
                                          userIdModel.profilePic).formatedProfileUrl,
                                      reaction: getReactionIconPath(
                                        model.reactionType,
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
