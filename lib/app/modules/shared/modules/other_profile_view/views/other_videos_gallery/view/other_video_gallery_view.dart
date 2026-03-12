import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../components/video_player/post/newsfeed_post_video_player.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../controller/other_video_gallery_controller.dart';
import 'package:video_player/video_player.dart';
import '../../../../../../../components/simmar_loader.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../config/constants/color.dart';
import '../../../../../../NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/videos_gallery/model/video_model.dart';

class OtherVideoGalleryView extends GetView<OtherVideoGalleryController> {
  const OtherVideoGalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    RxString character = 'spam'.obs;
    TextEditingController reportDescription = TextEditingController();

    controller.getOtherVideos();
    // VideosGalleryController videosGalleryController =
    //     Get.put(VideosGalleryController());
    // VideoModel model = Get.put(VideoModel());
    return Scaffold(
        // backgroundColor: Colors.white,
        appBar: AppBar(
          // backgroundColor: Colors.white,
          title: Text(
            'Videos'.tr,
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          leading: const BackButton(
            color: Colors.black,
          ),
          elevation: 0,
        ),
        body: Column(children: [
          const Divider(),
          Expanded(
            child: Obx(
              () =>
                  controller.videoList.value.isEmpty &&
                          (controller.isLoadingUserVideo.value == true)
                      ? ShimmarLoadingView()
                      : controller.videoList.value.isEmpty
                          ? Center(
                              child: Text(
                                'No videos available'.tr,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : Expanded(
                              child: GridView.builder(
                              padding: const EdgeInsets.all(8.0),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
                              ),
                              itemCount: controller.videoList.value.length,
                              itemBuilder: (context, index) {
                                VideoModel videoModel =
                                    controller.videoList.value[index];
                                VideoPlayerController videoPlayerController =
                                    VideoPlayerController.networkUrl(
                                        Uri.parse(videoModel.media ?? ''));
                                videoPlayerController.initialize();
                                return Stack(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Get.to(NewsFeedPostVideoPlayer(
                                          // isPostPreview: true,
                                          postId: '',
                                          videoSrc: (videoModel.media ?? '')
                                              .formatedVideoUrl,
                                        ));
                                      },
                                      child: Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: videoModel
                                                                .videoThumbnail !=
                                                            null
                                                        ? NetworkImage((videoModel
                                                                    .videoThumbnail ??
                                                                '')
                                                            .formatedThumbnailUrl)
                                                        : const AssetImage(
                                                                AppAssets
                                                                    .DEFAULT_IMAGE)
                                                            as ImageProvider,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 10,
                                      child: IconButton(
                                        icon: const Image(
                                            height: 22,
                                            width: 22,
                                            image: AssetImage(AppAssets.MORE)),
                                        onPressed: () {
                                          Get.bottomSheet(
                                            Container(
                                              height: 80,
                                              width: double.infinity,
                                              color: Colors.white,
                                              child: Column(
                                                children: [
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Get.bottomSheet(
                                                        SizedBox(
                                                          height:
                                                              Get.height / 1.8,
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                margin: const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        10),
                                                                child: Text(
                                                                  'Report'.tr,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                              Divider(
                                                                height: 1,
                                                                color: Colors
                                                                    .grey
                                                                    .shade300,
                                                              ),
                                                              Expanded(
                                                                child: ListView(
                                                                  shrinkWrap:
                                                                      true,
                                                                  physics:
                                                                      const ScrollPhysics(),
                                                                  children: [
                                                                    Obx(() =>
                                                                        ListTile(
                                                                          title:
                                                                              Text('Spam'.tr),
                                                                          subtitle:
                                                                              Text('It’s spam or violent'.tr),
                                                                          leading:
                                                                              Radio<String>(
                                                                            value:
                                                                                'spam',
                                                                            groupValue:
                                                                                character.value,
                                                                            onChanged:
                                                                                (String? value) {
                                                                              character.value = value!;
                                                                              // setState(() {
                                                                              //   _character = value;
                                                                              // });
                                                                            },
                                                                          ),
                                                                        )),
                                                                    Obx(() =>
                                                                        ListTile(
                                                                          title:
                                                                              Text('False information'.tr),
                                                                          subtitle:
                                                                              Text('If someone is in immediate danger'.tr),
                                                                          leading:
                                                                              Radio<String>(
                                                                            value:
                                                                                'false_info',
                                                                            groupValue:
                                                                                character.value,
                                                                            onChanged:
                                                                                (String? value) {
                                                                              character.value = value!;
                                                                              // setState(() {
                                                                              //   _character = value;
                                                                              // });
                                                                            },
                                                                          ),
                                                                        )),
                                                                    Obx(() =>
                                                                        ListTile(
                                                                          title:
                                                                              Text('Nudity'.tr),
                                                                          subtitle:
                                                                              Text('It’s Sexual activity or nudity showing genitals'.tr),
                                                                          leading:
                                                                              Radio<String>(
                                                                            value:
                                                                                'nudity',
                                                                            groupValue:
                                                                                character.value,
                                                                            onChanged:
                                                                                (String? value) {
                                                                              character.value = value!;
                                                                              // setState(() {
                                                                              //   _character = value;
                                                                              // });
                                                                            },
                                                                          ),
                                                                        )),
                                                                    Obx(() =>
                                                                        ListTile(
                                                                          title:
                                                                              Text('Something Else'.tr),
                                                                          subtitle:
                                                                              Text('Fraud, scam, violence, hate speech etc. '.tr),
                                                                          leading:
                                                                              Radio<String>(
                                                                            value:
                                                                                'something_else',
                                                                            groupValue:
                                                                                character.value,
                                                                            onChanged:
                                                                                (String? value) {
                                                                              character.value = value!;
                                                                              // setState(() {
                                                                              //   _character = value;
                                                                              // });
                                                                            },
                                                                          ),
                                                                        )),
                                                                  ],
                                                                ),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      Get.back();
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      height:
                                                                          50,
                                                                      width:
                                                                          Get.width /
                                                                              2,
                                                                      decoration: BoxDecoration(
                                                                          border: Border.all(
                                                                              color: Colors.grey.shade300,
                                                                              width: 1)),
                                                                      child:
                                                                          Text(
                                                                        'Cancel'
                                                                            .tr,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      // Get.back();

                                                                      Get.bottomSheet(
                                                                        SizedBox(
                                                                          height:
                                                                              Get.height / 1.8,
                                                                          width:
                                                                              Get.width,
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Container(
                                                                                margin: const EdgeInsets.symmetric(vertical: 10),
                                                                                child: Text(
                                                                                  'Report'.tr,
                                                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Divider(
                                                                                height: 1,
                                                                                color: Colors.grey.shade300,
                                                                              ),
                                                                              Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                                                                                    child: Text(
                                                                                      'Description'.tr,
                                                                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                    height: Get.height / 2.9,
                                                                                    padding: const EdgeInsets.all(8),
                                                                                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                                                    decoration: BoxDecoration(
                                                                                        border: Border.all(color: Colors.grey.shade300, width: 1), //Colors.grey.withValues(alpha:0.1),width: 1),
                                                                                        borderRadius: BorderRadius.circular(10)),
                                                                                    child: TextField(
                                                                                      controller: reportDescription,
                                                                                      maxLines: 8,
                                                                                      decoration: InputDecoration(
                                                                                        border: InputBorder.none,
                                                                                        hintText: 'Enter a description about your Report...'.tr,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  InkWell(
                                                                                    onTap: () {
                                                                                      Get.back();
                                                                                    },
                                                                                    child: Container(
                                                                                      alignment: Alignment.center,
                                                                                      height: 50,
                                                                                      width: Get.width / 2,
                                                                                      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300, width: 1)),
                                                                                      child: Text(
                                                                                        'Back'.tr,
                                                                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  InkWell(
                                                                                    onTap: () {
                                                                                      controller.reportAPost(post_id: '${videoModel.id}', report_type: character.value, description: reportDescription.text);
                                                                                    },
                                                                                    child: Container(
                                                                                      alignment: Alignment.center,
                                                                                      height: 50,
                                                                                      width: Get.width / 2,
                                                                                      decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1), color: PRIMARY_COLOR
                                                                                          //.withValues(alpha:0.7),
                                                                                          ),
                                                                                      child: Text(
                                                                                        'Report'.tr,
                                                                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        backgroundColor:
                                                                            Colors.white,
                                                                        isScrollControlled:
                                                                            true,
                                                                      );
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      height:
                                                                          50,
                                                                      decoration: BoxDecoration(
                                                                          border: Border.all(
                                                                              color: Colors.grey.shade300,
                                                                              width: 0),
                                                                          color: PRIMARY_COLOR),
                                                                      width:
                                                                          Get.width /
                                                                              2,
                                                                      child:
                                                                          Text(
                                                                        'Continue'
                                                                            .tr,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color: Colors.white),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        backgroundColor:
                                                            Colors.white,
                                                        isScrollControlled:
                                                            true,
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            8),
                                                                child: Icon(
                                                                  Icons.report,
                                                                  size: 20,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            8),
                                                                child: Text(
                                                                  'Report'.tr,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          18),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            )),
            ),
          )

          // Obx(
          //   () => Expanded(
          //       child: controller.videoList.value.isEmpty
          //           ? const Center(
          //               child: Text(
          //                 'No videos available',
          //                 style: TextStyle(
          //                   fontSize: 20,
          //                   fontWeight: FontWeight.w600,
          //                 ),
          //               ),
          //             )
          //           : GridView.builder(
          //               padding: const EdgeInsets.all(8.0),
          //               gridDelegate:
          //                   const SliverGridDelegateWithFixedCrossAxisCount(
          //                 crossAxisCount: 3,
          //                 childAspectRatio: 0.75,
          //                 crossAxisSpacing: 8.0,
          //                 mainAxisSpacing: 8.0,
          //               ),
          //               itemCount: controller.videoList.value.length,
          //               itemBuilder: (context, index) {
          //                 VideoModel videoModel =
          //                     controller.videoList.value[index];
          //                 VideoPlayerController videoPlayerController =
          //                     VideoPlayerController.networkUrl(
          //                         Uri.parse(videoModel.media ?? ''));
          //                 videoPlayerController.initialize();
          //                 return InkWell(
          //                   onTap: () {
          //                     Get.to(SingleVideoPlayer(
          //                       videoLink: getFormatedVideoUrl(
          //                           videoModel.media ?? ''),
          //                     ));
          //                   },
          //                   child: Card(
          //                     elevation: 2,
          //                     shape: RoundedRectangleBorder(
          //                       borderRadius: BorderRadius.circular(8.0),
          //                     ),
          //                     child: Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         Expanded(
          //                           child: Container(
          //                             decoration: BoxDecoration(
          //                               borderRadius:
          //                                   BorderRadius.circular(8.0),
          //                               image: DecorationImage(
          //                                 fit: BoxFit.cover,
          //                                 image: videoModel.videoThumbnail !=
          //                                         null
          //                                     ? NetworkImage(
          //                                         getFormatedThumbnailUrl(
          //                                             videoModel
          //                                                     .videoThumbnail ??
          //                                                 ''))
          //                                     : const AssetImage(
          //                                             AppAssets.DEFAULT_IMAGE)
          //                                         as ImageProvider,
          //                               ),
          //                             ),
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 );
          //               },
          //             )),
          // ),
        ]));
  }
}

Widget ShimmarLoadingView() {
  return SizedBox(
    height: Get.height,
    child: GridView.builder(
        physics: const ScrollPhysics(),
        itemCount: 12,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 0.7),
        itemBuilder: (BuildContext context, index) {
          return ShimmerLoader(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: Get.width / 3,
                  height: 157,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withValues(alpha: 0.9)),
                )),
          );
        }),
  );
}
