import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../extension/string/string_image_path.dart';
import '../../../../../routes/profile_navigator.dart';
import '../../../../NAVIGATION_MENUS/reels/model/reels_model.dart';
import '../../../../NAVIGATION_MENUS/reels/model/reels_reacted_user_model.dart';
import '../../../../../config/constants/app_assets.dart';
import '../../../../../components/reaction_list_tile.dart';
import '../../../../../config/constants/color.dart';
import '../../../../../utils/post_utlis.dart';
import '../controllers/reels_reactions_controller.dart';

class ReelsReactionsView extends GetView<ReelsReactionsController> {
  const ReelsReactionsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text('People who reacted'.tr,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        // backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
          child: Obx(
        () => Column(
          children: [
            DefaultTabController(
              length: 8,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                              Text(' ${controller.reactionList.value.length}'.tr),
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
                              Text(' ${controller.likeList.value.length}'.tr),
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
                              Text(' ${controller.loveList.value.length}'.tr),
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
                              Text(' ${controller.hahaList.value.length}'.tr),
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
                              Text(' ${controller.wowList.value.length}'.tr),
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
                              Text(' ${controller.sadList.value.length}'.tr),
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
                              Text(' ${controller.angryList.value.length}'.tr),
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
                              Text(' ${controller.unlikeList.value.length}'.tr),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  //====================================================================== Tab Bar View ======================================================================//

                  SizedBox(
                    height: Get.height,
                    child: TabBarView(
                      children: [
                        // ==================================== All Reaction List ============================//

                        Obx(() => controller.isReactionLoding.value == true
                            ? const Center(child: CircularProgressIndicator())
                            : controller.reactionList.value.isNotEmpty
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    physics: const ScrollPhysics(),
                                    itemCount:
                                        controller.reactionList.value.length,
                                    itemBuilder: (context, index) {
                                      ReelsReactionModel model =
                                          controller.reactionList.value[index];
                                      ReelsReactedUserIdModel userIdModel =
                                          model.user_id_2 ??
                                              ReelsReactedUserIdModel();

                                      return ReactionListTile(
                                        onTapViewProfile: () {
                                          ProfileNavigator.navigateToProfile(
                                              username:
                                                  userIdModel.username ?? '',
                                              isFromReels: 'false');
                                        },
                                        name:
                                            '${userIdModel.first_name} ${userIdModel.last_name}',
                                        profilePicUrl:
                                            (userIdModel.profile_pic ?? '')
                                                .formatedProfileUrl,
                                        reaction: getReactionIconPath(
                                          model.reaction_type ?? '',
                                        ),
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
                                  ReelsReactionModel model =
                                      controller.likeList.value[index];
                                  ReelsReactedUserIdModel userIdModel =
                                      model.user_id!;

                                  return ReactionListTile(
                                    onTapViewProfile: () {
                                      ProfileNavigator.navigateToProfile(
                                          username: userIdModel.username ?? '',
                                          isFromReels: 'false');
                                    },
                                    name:
                                        '${userIdModel.first_name} ${userIdModel.last_name}',
                                    profilePicUrl:
                                        (userIdModel.profile_pic ?? '')
                                            .formatedProfileUrl,
                                    reaction: getReactionIconPath(
                                      model.reaction_type ?? '',
                                    ),
                                  );
                                },
                              )
                            :  Center(
                                child: Text('No Reaction'.tr),
                              )),
                        // ==================================== Love Reaction List ============================//

                        Obx(() => controller.loveList.value.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: controller.loveList.value.length,
                                itemBuilder: (context, index) {
                                  ReelsReactionModel model =
                                      controller.loveList.value[index];
                                  ReelsReactedUserIdModel userIdModel =
                                      model.user_id!;

                                  return ReactionListTile(
                                    onTapViewProfile: () {
                                      ProfileNavigator.navigateToProfile(
                                          username: userIdModel.username ?? '',
                                          isFromReels: 'false');
                                    },
                                    name:
                                        '${userIdModel.first_name} ${userIdModel.last_name}',
                                    profilePicUrl:
                                        (userIdModel.profile_pic ?? '')
                                            .formatedProfileUrl,
                                    reaction: getReactionIconPath(
                                      model.reaction_type ?? '',
                                    ),
                                  );
                                },
                              )
                            :  Center(
                                child: Text('No Reaction'.tr),
                              )),
                        // ==================================== Haha Reaction List ============================//

                        Obx(() => controller.hahaList.value.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: controller.hahaList.value.length,
                                itemBuilder: (context, index) {
                                  ReelsReactionModel model =
                                      controller.hahaList.value[index];
                                  ReelsReactedUserIdModel userIdModel =
                                      model.user_id!;

                                  return ReactionListTile(
                                    onTapViewProfile: () {
                                      ProfileNavigator.navigateToProfile(
                                          username: userIdModel.username ?? '',
                                          isFromReels: 'false');
                                    },
                                    name:
                                        '${userIdModel.first_name} ${userIdModel.last_name}',
                                    profilePicUrl:
                                        (userIdModel.profile_pic ?? '')
                                            .formatedProfileUrl,
                                    reaction: getReactionIconPath(
                                      model.reaction_type ?? '',
                                    ),
                                  );
                                },
                              )
                            :  Center(
                                child: Text('No Reaction'.tr),
                              )),

                        // ==================================== Wow Reaction List ============================//

                        Obx(() => controller.wowList.value.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: controller.wowList.value.length,
                                itemBuilder: (context, index) {
                                  ReelsReactionModel model =
                                      controller.wowList.value[index];
                                  ReelsReactedUserIdModel userIdModel =
                                      model.user_id!;

                                  return ReactionListTile(
                                    onTapViewProfile: () {
                                      ProfileNavigator.navigateToProfile(
                                          username: userIdModel.username ?? '',
                                          isFromReels: 'false');
                                    },
                                    name:
                                        '${userIdModel.first_name} ${userIdModel.last_name}',
                                    profilePicUrl:
                                        (userIdModel.profile_pic ?? '')
                                            .formatedProfileUrl,
                                    reaction: getReactionIconPath(
                                      model.reaction_type ?? '',
                                    ),
                                  );
                                },
                              )
                            :  Center(
                                child: Text('No Reaction'.tr),
                              )),
                        // ==================================== Sad Reaction List ============================//

                        Obx(() => controller.sadList.value.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: controller.sadList.value.length,
                                itemBuilder: (context, index) {
                                  ReelsReactionModel model =
                                      controller.sadList.value[index];
                                  ReelsReactedUserIdModel userIdModel =
                                      model.user_id!;

                                  return ReactionListTile(
                                    onTapViewProfile: () {
                                      ProfileNavigator.navigateToProfile(
                                          username: userIdModel.username ?? '',
                                          isFromReels: 'false');
                                    },
                                    name:
                                        '${userIdModel.first_name} ${userIdModel.last_name}',
                                    profilePicUrl:
                                        (userIdModel.profile_pic ?? '')
                                            .formatedProfileUrl,
                                    reaction: getReactionIconPath(
                                      model.reaction_type ?? '',
                                    ),
                                  );
                                },
                              )
                            :  Center(
                                child: Text('No Reaction'.tr),
                              )),
                        // ==================================== Angry Reaction List ============================//

                        Obx(() => controller.angryList.value.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: controller.angryList.value.length,
                                itemBuilder: (context, index) {
                                  ReelsReactionModel model =
                                      controller.angryList.value[index];
                                  ReelsReactedUserIdModel userIdModel =
                                      model.user_id!;

                                  return ReactionListTile(
                                    onTapViewProfile: () {
                                      ProfileNavigator.navigateToProfile(
                                          username: userIdModel.username ?? '',
                                          isFromReels: 'false');
                                    },
                                    name:
                                        '${userIdModel.first_name} ${userIdModel.last_name}',
                                    profilePicUrl:
                                        (userIdModel.profile_pic ?? '')
                                            .formatedProfileUrl,
                                    reaction: getReactionIconPath(
                                      model.reaction_type ?? '',
                                    ),
                                  );
                                },
                              )
                            :  Center(
                                child: Text('No Reaction'.tr),
                              )),
                        // ==================================== Unlike Reaction List ============================//

                        Obx(() => controller.unlikeList.value.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: controller.unlikeList.value.length,
                                itemBuilder: (context, index) {
                                  ReelsReactionModel model =
                                      controller.unlikeList.value[index];
                                  ReelsReactedUserIdModel userIdModel =
                                      model.user_id!;

                                  return ReactionListTile(
                                    onTapViewProfile: () {
                                      ProfileNavigator.navigateToProfile(
                                          username: userIdModel.username ?? '',
                                          isFromReels: 'false');
                                    },
                                    name:
                                        '${userIdModel.first_name} ${userIdModel.last_name}',
                                    profilePicUrl:
                                        (userIdModel.profile_pic ?? '')
                                            .formatedProfileUrl,
                                    reaction: getReactionIconPath(
                                      model.reaction_type ?? '',
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Text('No Reaction'.tr),
                              )),
                      ],
                    ),
                  )
                ],
              ),
            ),

            //SizedBox(height: 20,),
          ],
        ),
      )),
    );
  }
}
