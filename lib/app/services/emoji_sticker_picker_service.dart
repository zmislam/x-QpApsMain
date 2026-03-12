import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/image.dart';
import '../components/tab_bar.dart';
import '../config/constants/api_constant.dart';
import '../extension/num.dart';
import '../models/api_response.dart';
import '../components/search_bar.dart';
import '../data/emoji_cache.dart';
import '../models/sticker_emoji_model.dart';
import 'api_communication.dart';

class EmojiStickerPickerService {
  static final EmojiStickerPickerService _instance =
      EmojiStickerPickerService._privateConstructor();

  factory EmojiStickerPickerService() {
    return _instance;
  }
  EmojiStickerPickerService._privateConstructor() {
    _apiCommunication = ApiCommunication();
  }

  late final ApiCommunication _apiCommunication;
  Rx<List<StickerEmojiModel>> emojiModelList = Rx([]);
  Rx<List<StickerEmojiModel>> stickeModelList = Rx([]);
  Rx<List<StickerEmojiModel>> recentModelList = Rx([]);

  Future<void> getStickerAndEmoji(String type) async {
    final ApiResponse response = await _apiCommunication.doGetRequest(
        apiEndPoint: 'stickers',
        queryParameters: {
          'type': type,
          'pageNo': 1,
          'pageSize': 20,
        },
        responseDataKey: 'results');
    if (response.isSuccessful) {
      if (type == 'emoji') {
        emojiModelList.value = (response.data as List)
            .map((e) => StickerEmojiModel.fromMap(e))
            .toList();
      } else if (type == 'sticker') {
        stickeModelList.value = (response.data as List)
            .map((e) => StickerEmojiModel.fromMap(e))
            .toList();
      }
    } else {
      // Handle error response
    }
  }

  void loadRecentUses() {
    recentModelList.value = EmojiCache().getEmojiStickerList();
  }

  void addToRecentUses(StickerEmojiModel model) {
    EmojiCache().saveRecentEmojiSticker(
      currentList: recentModelList.value,
      stickerEmojiModel: model,
    );
    loadRecentUses();
  }

  final double crossAxisSpacing = 16;
  final int crossAxisCount = 6;

  Future<StickerEmojiModel?> showEmojiStrickerBottomSheet() async {
    getStickerAndEmoji('emoji');
    getStickerAndEmoji('sticker');
    loadRecentUses();
    debugPrint('${stickeModelList.value.length}');
    StickerEmojiModel? selectedStickerModel;
    // CreateTextStoryController createTextStoryController = Get.find();

    await Get.bottomSheet(
      Container(
        height: Get.height / 2,
        width: Get.width,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrimarySearchBar(
              controller: TextEditingController(),
              hintText: 'Search Sticker'.tr,
            ),
            20.h,
            Expanded(
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    PrimaryTabBar(
                      tabItemModelList: [
                        TabItemModel(
                          title: 'Recent'.tr,
                          iconData: Icons.star_half_rounded,
                        ),
                        TabItemModel(
                          title: 'Sticker'.tr,
                          iconData: Icons.accessibility,
                        ),
                        TabItemModel(
                          title: 'Emoji'.tr,
                          iconData: Icons.emoji_emotions,
                        ),
                      ],
                    ),
                    Expanded(
                      child: Obx(
                        () => TabBarView(
                          children: [
                            // ========================================================= Recent =========================================================

                            Column(
                              children: [
                                20.h,
                                Expanded(
                                  child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: crossAxisSpacing,
                                      crossAxisCount: crossAxisCount,
                                    ),
                                    itemCount: recentModelList.value.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final model =
                                          recentModelList.value[index];
                                      return InkWell(
                                        onTap: () {
                                          addToRecentUses(model);
                                          selectedStickerModel = model;

                                          Get.back();
                                        },
                                        child: PrimaryNetworkImage(
                                          height: 24,
                                          width: 24,
                                          imageUrl:
                                              '${ApiConstant.SERVER_IP_PORT}/assets/${model.type}/${model.file_name ?? ''}',
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                            // ========================================================= Sticker =========================================================

                            Column(
                              children: [
                                20.h,
                                Expanded(
                                  child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: crossAxisSpacing,
                                      crossAxisCount: crossAxisCount,
                                    ),
                                    itemCount: stickeModelList.value.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final model =
                                          stickeModelList.value[index];
                                      return InkWell(
                                        onTap: () {
                                          addToRecentUses(model);
                                          selectedStickerModel = model;
                                          Get.back();
                                        },
                                        child: PrimaryNetworkImage(
                                          height: 24,
                                          width: 24,
                                          imageUrl:
                                              '${ApiConstant.SERVER_IP_PORT}/assets/${model.type}/${model.file_name ?? ''}',
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                            // ========================================================= Emoji  =========================================================

                            Column(
                              children: [
                                20.h,
                                Expanded(
                                  child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: crossAxisSpacing,
                                      crossAxisCount: crossAxisCount,
                                    ),
                                    itemCount: emojiModelList.value.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final model = emojiModelList.value[index];
                                      return InkWell(
                                        onTap: () {
                                          addToRecentUses(model);
                                          selectedStickerModel = model;
                                          Get.back();
                                        },
                                        child: PrimaryNetworkImage(
                                          height: 24,
                                          width: 24,
                                          imageUrl:
                                              '${ApiConstant.SERVER_IP_PORT}/assets/${model.type}/${model.file_name ?? ''}',
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ).then((value) {
      // Called when the bottom sheet is dismissed
    });

    return selectedStickerModel;
  }
}
