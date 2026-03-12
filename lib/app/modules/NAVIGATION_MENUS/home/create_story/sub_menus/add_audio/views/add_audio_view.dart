import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../../../../../components/button.dart';
import '../../../../../../../components/image.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../extension/num.dart';
import '../models/audio_model.dart';
import '../../../../../../../config/constants/color.dart';

import '../../../../../../../components/search_bar.dart';
import '../components/audio_widget.dart';
import '../controllers/add_audio_controller.dart';

class AddAudioView extends GetView<AddAudioController> {
  const AddAudioView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                      child: PrimarySearchBar(
                    controller: controller.audioSearchTextController,
                    hintText: 'Search Song..'.tr,
                    onChanged: (query) {
                      controller.debouncer.call(() {
                        controller.onSearchTextChange(query);
                      });
                    },
                  )),
                  10.w,
                  PrimaryButton(
                    verticalPadding: 15,
                    horizontalPadding: 20,
                    onPressed: () {
                      Get.back();
                    },
                    text: 'Done'.tr,
                  ),
                ],
              ),
            ),
            10.h,
            Expanded(
              child: DefaultTabController(
                  length: 3,
                  child: Builder(
                    builder: (context) {
                      final TabController tabController =
                          DefaultTabController.of(context);
                      tabController.addListener(() {
                        if (!tabController.indexIsChanging) {
                          // Update the tabIndex when the user slides
                          controller.currentlySelectedTab = tabController.index;
                        }
                      });

                      return Column(
                        children: <Widget>[
                          TabBar(
                            labelColor: PRIMARY_COLOR,
                            unselectedLabelColor: Colors.black,
                            indicatorColor: PRIMARY_COLOR,
                            padding: EdgeInsets.zero,
                            labelPadding: EdgeInsets.zero,
                            tabs: [
                              Column(
                                children: [
                                  const PrimaryAssetImage(
                                    height: 32,
                                    width: 32,
                                    imagePath: AppAssets.RECOMENDED_ICON,
                                  ),
                                  10.h,
                                  Text('Recomended'.tr),
                                ],
                              ),
                              Column(
                                children: [
                                  const PrimaryAssetImage(
                                      height: 32,
                                      width: 32,
                                      imagePath: AppAssets.RECENT_ICON),
                                  10.h,
                                  Text('Recent'.tr),
                                ],
                              ),
                              Column(
                                children: [
                                  const PrimaryAssetImage(
                                      height: 32,
                                      width: 32,
                                      imagePath:
                                          AppAssets.FAVORITE_FILLED_ICON),
                                  10.h,
                                  Text('Favorite'.tr),
                                ],
                              ),
                            ],
                          ),
                          10.h,
                          Expanded(
                            child: TabBarView(
                              children: [
                                // ========================================================= Recomended =========================================================
                                Obx(() => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListView.separated(
                                        separatorBuilder: (context, index) =>
                                            10.h,
                                        controller: controller
                                            .audioListScrollController,
                                        itemCount:
                                            controller.audioList.value.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          AudioModel audioModel =
                                              controller.audioList.value[index];
                                          return AudioWidget(
                                            audioModel: audioModel,
                                            onPressedFavorate: () async {
                                              await controller.addToFavorate(
                                                audioModel.id ?? '',
                                              );
                                              controller
                                                  .getAudioListRecommended();
                                            },
                                          );
                                        },
                                      ),
                                    )),
                                // ========================================================= Recent =========================================================
                                Obx(() => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListView.separated(
                                        separatorBuilder: (context, index) =>
                                            10.h,
                                        controller: controller
                                            .recentAudioListScrollController,
                                        itemCount: controller
                                            .recentAudioList.value.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          AudioModel audioModel = controller
                                              .recentAudioList.value[index];
                                          return AudioWidget(
                                            audioModel: audioModel,
                                            onPressedFavorate: () async {
                                              await controller.addToFavorate(
                                                audioModel.id ?? '',
                                              );
                                              controller.getAudioListRecent();
                                            },
                                          );
                                        },
                                      ),
                                    )),
                                //* ========================================================= Favorite =========================================================
                                Obx(() => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListView.separated(
                                        separatorBuilder: (context, index) =>
                                            10.h,
                                        controller: controller
                                            .favoriteAudioListScrollController,
                                        itemCount: controller
                                            .favoriteAudioList.value.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          AudioModel audioModel = controller
                                              .favoriteAudioList.value[index];
                                          return AudioWidget(
                                            audioModel: audioModel,
                                            onPressedFavorate: () async {
                                              await controller.addToFavorate(
                                                audioModel.id ?? '',
                                              );
                                              controller
                                                  .getAudioListRecommended();
                                            },
                                          );
                                        },
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }

}
