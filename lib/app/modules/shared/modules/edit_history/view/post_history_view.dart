import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../extension/string/string_image_path.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../components/image.dart';
import '../../../../../components/media/media_grid/media_grid.dart';
import '../../../../../components/post/post_body/post_body.dart';
import '../../../../../components/post_tag_list.dart';
import '../../../../../components/video_player/video_player.dart';
import '../../../../../extension/date_time_extension.dart';
import '../../../../../models/media.dart';
import '../../../../../models/post.dart';
import '../../../../../routes/app_pages.dart';
import '../../../../../utils/image_utils.dart';
import '../../../../../utils/post_utlis.dart';
import '../controller/post_history_controller.dart';

class PostHistoryView extends GetView<PostHistoryController> {
  const PostHistoryView(
      {super.key,
      this.onTapBodyViewMoreMedia,
      this.onTapViewMoreMedia,
      this.onTapViewOtherProfile});

  final VoidCallback? onTapBodyViewMoreMedia;
  final VoidCallback? onTapViewMoreMedia;
  final VoidCallback? onTapViewOtherProfile;

  @override
  Widget build(BuildContext context) {
    controller.postId.value = Get.arguments;
    controller.getPostHistory();

    return Scaffold(
        // backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text('Post Edit History'.tr,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          // backgroundColor: Colors.white,
        ),
        body: Obx(() => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: controller.postList.value.length,
                itemBuilder: (BuildContext context, int index) {
                  PostModel postModel = controller.postList.value[index];
                  List<String> imageUrls = [];

                  for (MediaModel media in postModel.media ?? []) {
                    imageUrls.add((media.media ?? '').formatedPostUrl);
                  }

                  return Column(children: [
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: InkWell(
                        onTap: () {
                          Get.toNamed(Routes.PROFILE);
                        },
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 10),
                                RoundCornerNetworkImage(
                                  height: 40,
                                  width: 40,
                                  imageUrl: (
                                    controller.userModel.profile_pic ?? ''
                                  ).formatedProfileUrl,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      RichText(
                                          text: TextSpan(children: [
                                        TextSpan(
                                          text: '${controller.userModel.first_name} ${controller.userModel.last_name}'.tr,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(children: [
                                          postModel.feeling_id != null
                                              ? TextSpan(children: [
                                                  TextSpan(
                                                      children: [
                                                        TextSpan(
                                                            text: ' is feeling'.tr,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 16)),
                                                        WidgetSpan(
                                                            child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 3.0),
                                                          child: ReactionIcon(
                                                              postModel
                                                                  .feeling_id!
                                                                  .logo
                                                                  .toString()),
                                                        )),
                                                        TextSpan(
                                                            text: ' ${postModel.feeling_id!.feelingName}'.tr,
                                                            style:
                                                                TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 16,
                                                            )),
                                                      ],
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                ])
                                              : TextSpan(
                                                  text: '',
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade700,
                                                      fontSize: 16)),
                                          TextSpan(
                                              text: getLocationText(postModel),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16)),
                                          TextSpan(
                                              text: getTagText(postModel),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  Get.to(() => PostTagList(
                                                        postModel: postModel,
                                                      ));
                                                },
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16))
                                        ]),
                                      ])),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                              '${getDynamicFormatedTime(postModel.createdAt ?? '')} '),
                                          Icon(
                                            getIconAsPrivacy(
                                                postModel.post_privacy ?? ''),
                                            size: 17,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    (postModel.event_type?.isNotEmpty ?? false)
                        ?
                        //======================================================== Showing Event Post ========================================================//
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [getEventIcon(postModel)],
                              ),
                              postModel.event_type == 'travel'
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5.0, left: 8.0, right: 8.0),
                                      child: ExpandableText(
                                        postModel.lifeEventId?.title ?? '',
                                        expandText: 'See more',
                                        maxLines: 5,
                                        collapseText: 'see less',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ))
                                  : Container(),
                              postModel.event_type == 'customevent'
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        getCustomEventText(postModel),
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : postModel.event_type ==
                                          'milestonesandachievements'
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            getMilestonEventText(postModel),
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      : postModel.event_type == 'travel'
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0),
                                              child: Text(
                                                textAlign: TextAlign.center,
                                                getTravelEventText(postModel),
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          : postModel.event_type ==
                                                  'relationship'
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5.0),
                                                  child: InkWell(
                                                    onTap:
                                                        onTapViewOtherProfile,
                                                    child: Text(
                                                      textAlign:
                                                          TextAlign.center,
                                                      getRelationEventText(
                                                          postModel),
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                )
                                              : postModel.event_type ==
                                                      'education'
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5.0),
                                                      child: Text(
                                                        textAlign:
                                                            TextAlign.center,
                                                        getEducationEventText(
                                                            postModel),
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    )
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5.0),
                                                      child: Text(
                                                          textAlign:
                                                              TextAlign.center,
                                                          getWorkEventText(
                                                              postModel),
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                              const SizedBox(
                                height: 3,
                              ),
                              postModel.event_type == 'customevent'
                                  ? Text(
                                      getDynamicFormatedTime(postModel
                                              .lifeEventId?.date
                                              .toString() ??
                                          ''),
                                      style: TextStyle(
                                        fontSize: Get.height * 0.015,
                                      ),
                                    )
                                  : postModel.event_type ==
                                          'milestonesandachievements'
                                      ? Text(
                                          getDynamicFormatedTime(postModel
                                                  .lifeEventId?.date
                                                  .toString() ??
                                              ''),
                                          style: TextStyle(
                                            fontSize: Get.height * 0.015,
                                          ),
                                        )
                                      : postModel.event_type == 'travel'
                                          ? Text(
                                              getDynamicFormatedTime(postModel
                                                      .lifeEventId?.date
                                                      .toString() ??
                                                  ''),
                                              style: TextStyle(
                                                fontSize: Get.height * 0.015,
                                              ),
                                            )
                                          : postModel.event_type ==
                                                  'relationship'
                                              ? Text(
                                                  getDynamicFormatedTime(
                                                      postModel
                                                              .lifeEventId?.date
                                                              .toString() ??
                                                          ''),
                                                  style: TextStyle(
                                                    fontSize:
                                                        Get.height * 0.015,
                                                  ),
                                                )
                                              : postModel.event_type ==
                                                      'education'
                                                  ? Text(
                                                      postModel.event_sub_type!
                                                              .contains(
                                                                  'New School')
                                                          ? getDynamicFormatedTime(
                                                              postModel
                                                                      .institute_id
                                                                      ?.startDate ??
                                                                  '')
                                                          : postModel
                                                                  .event_sub_type!
                                                                  .contains(
                                                                      'Graduate')
                                                              ? getDynamicFormatedTime(
                                                                  postModel
                                                                          .institute_id
                                                                          ?.endDate ??
                                                                      '')
                                                              : getDynamicFormatedTime(
                                                                  postModel
                                                                          .institute_id
                                                                          ?.endDate ??
                                                                      ''),
                                                      style: TextStyle(
                                                        fontSize:
                                                            Get.height * 0.015,
                                                      ),
                                                    )
                                                  : Text(
                                                      postModel.event_sub_type!
                                                              .contains(
                                                                  'New Job')
                                                          ? getDynamicFormatedTime(
                                                              postModel
                                                                      .workplace_id
                                                                      ?.fromDate ??
                                                                  '')
                                                          : postModel
                                                                  .event_sub_type!
                                                                  .contains(
                                                                      'Promotion')
                                                              ? getDynamicFormatedTime(postModel
                                                                      .workplace_id
                                                                      ?.fromDate ??
                                                                  '')
                                                              : postModel
                                                                      .event_sub_type!
                                                                      .contains(
                                                                          'Left Job')
                                                                  ? getDynamicFormatedTime(
                                                                      postModel.workplace_id?.toDate ??
                                                                          '')
                                                                  : getDynamicFormatedTime(
                                                                      postModel.workplace_id?.toDate ??
                                                                          ''),
                                                      style: TextStyle(
                                                        fontSize:
                                                            Get.height * 0.015,
                                                      )),
                              postModel.event_type == 'relationship' ||
                                      postModel.event_type == 'travel' ||
                                      postModel.event_type ==
                                          'milestonesandachievements' ||
                                      postModel.event_type == 'customevent'
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Stack(
                                        children: [
                                          const Divider(
                                            height: 50,
                                            color: Colors.grey,
                                          ),
                                          Positioned(
                                            left: 0,
                                            right: 0,
                                            top: 0,
                                            bottom: 0,
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: getEventIcon(postModel,
                                                    height: 32, width: 32)),
                                          )
                                        ],
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Stack(
                                        children: [
                                          const Divider(
                                            height: 50,
                                            color: Colors.grey,
                                          ),
                                          Positioned(
                                            left: 0,
                                            right: 0,
                                            top: 0,
                                            bottom: 0,
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: getEventIcon(postModel,
                                                    height: 32, width: 32)),
                                          )
                                        ],
                                      ),
                                    ),
                              postModel.event_type == 'relationship' ||
                                      postModel.event_type == 'travel' ||
                                      postModel.event_type ==
                                          'milestonesandachievements' ||
                                      postModel.event_type == 'customevent'
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: ExpandableText('${postModel.lifeEventId?.description}'.tr,
                                        expandText: 'See more',
                                        maxLines: 5,
                                        collapseText: 'see less',
                                        style: TextStyle(
                                            color: Colors.black),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: ExpandableText('${postModel.description}'.tr,
                                        expandText: 'See more',
                                        maxLines: 5,
                                        collapseText: 'see less',
                                        style: TextStyle(
                                            color: Colors.black),
                                      ),
                                    )
                            ],
                          )
                        : postModel.link_image == null ||
                                postModel.link_image == ''
                            //======================================================== Showing Image with Description Post ========================================================//

                            ? ((postModel.media?.length ?? 0) > 0)
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      (postModel.description?.isNotEmpty ??
                                              true)
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5, bottom: 10),
                                              child: Text(
                                                  postModel.description ?? ''),
                                            )
                                          : const SizedBox(),
                                      ((postModel.media?.length ?? 0) > 1)
                                          ? SizedBox(
                                              height: 500,
                                              child: MediaGridView(
                                                  mediaUrls: imageUrls,
                                                  onTapViewMoreMedia:
                                                      onTapViewMoreMedia ??
                                                          () {}),
                                            )
                                          : InkWell(
                                              onTap: onTapViewMoreMedia,
                                              child: isImageUrl(imageUrls[0])
                                                  ? PrimaryNetworkImage(
                                                      imageUrl: imageUrls[0])
                                                  : SizedBox(
                                                      height: 250,
                                                      child: VideoPlay(
                                                          videoLink:
                                                              imageUrls[0]),
                                                    )),
                                    ],
                                  )
                                : ((postModel.media?.length ?? 0) == 0)
                                    ? Container(
                                        // =================================================== No Meida Post ===================================================
                                        height: (postModel
                                                        .post_background_color !=
                                                    null &&
                                                postModel.post_background_color!
                                                    .isNotEmpty &&
                                                postModel
                                                        .post_background_color! !=
                                                    '')
                                            ? 256
                                            : null, // not having background color will make height dynamic
                                        width: double.maxFinite,
                                        decoration: BoxDecoration(
                                            color: (postModel
                                                            .post_background_color !=
                                                        null &&
                                                    postModel
                                                        .post_background_color!
                                                        .isNotEmpty)
                                                ? Color(int.parse(
                                                    '0xff${postModel.post_background_color}'))
                                                : null),
                                        padding: const EdgeInsets.all(10),
                                        child: (postModel
                                                        .post_background_color !=
                                                    null &&
                                                postModel
                                                        .post_background_color !=
                                                    '')
                                            ? Center(
                                                child: Text('${postModel.description}'.tr,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16),
                                                ),
                                              )
                                            : ExpandableText('${postModel.description}'.tr,
                                                expandText: 'See more',
                                                maxLines: 5,
                                                collapseText: 'see less',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                      )
                                    : Column(
                                        //======================================================== Showing Link Post ========================================================//
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: RichText(
                                                text: TextSpan(
                                                    children: getTextWithLink(
                                                        postModel.description ??
                                                            ''))),
                                          ),
                                          GestureDetector(
                                              onTap: () async {
                                                String url =
                                                    postModel.link.toString();
                                                await launchUrl(Uri.parse(url));
                                              },
                                              child: PrimaryNetworkImage(
                                                  imageUrl:
                                                      postModel.link_image!)),
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade300),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Text(
                                                  postModel.link_title ?? '',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(postModel
                                                        .link_description ??
                                                    ''),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                            : Column(
                                //======================================================== Showing Link Post ========================================================//
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: LinkText(
                                          text: postModel.description ?? '')),
                                  GestureDetector(
                                      onTap: () async {
                                        String url = postModel.link.toString();
                                        await launchUrl(Uri.parse(url),
                                            mode:
                                                LaunchMode.externalApplication);
                                      },
                                      child: PrimaryNetworkImage(
                                          imageUrl: postModel.link_image!)),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          postModel.link_title ?? '',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(postModel.link_description ?? ''),
                                      ],
                                    ),
                                  )
                                ],
                              )
                  ]);
                },
              ),
            )));
  }

  String getDynamicFormatedTime(String time) {
    // print("time of date ........."+time);

    DateTime postDateTime;
    if (time.toString() == 'null' || time.isEmpty || time.toString() == '') {
      postDateTime = DateTime.now().toLocal();
    } else {
      postDateTime = DateTime.parse(time).toLocal();
    }
    return productDateTimeFormat.format(postDateTime);
  }

  getIconAsPrivacy(String postPrivacy) {
    switch (postPrivacy) {
      case 'public':
        return Icons.public;
      case 'only_me':
        return Icons.lock;
      case 'friends':
        return Icons.people;
      default:
        return Icons.public;
    }
  }

  String getTextAsPostType(String postType) {
    switch (postType) {
      case 'campaign':
        return 'Sponsored ';
      default:
        return '';
    }
  }

  String getHeaderTextAsPostType(PostModel postModel) {
    switch (postModel.post_type) {
      case 'timeline_post':
        return '';
      case 'page_post':
        return '';
      case 'profile_picture':
        return 'updated his profile picture';
      case 'cover_picture':
        return 'updated his cover photo';
      case 'event':
        return '';
      case 'shared_reels':
        return '';
      case 'birthday':
        return '';
      case 'campaign':
        return '';
      default:
        return '';
    }
  }

  String getFeelingText(PostModel model) {
    return (model.feeling_id?.feelingName != null)
        ? ' is feeling ${model.feeling_id?.feelingName}'
        : '';
  }

  String getLocationText(PostModel postModel) {
    return (postModel.locationName.toString().contains('null'))
        ? ''
        : ' at ${postModel.locationName}';
  }

  String geSharedLocationText(PostModel postModel) {
    return (postModel.share_post_id!.locationName.toString().contains('null'))
        ? ''
        : ' at ${postModel.share_post_id?.locationName}';
  }

  String getTagText(PostModel postModel) {
    if (postModel.taggedUserList != null) {
      if (postModel.taggedUserList!.length == 1) {
        return ' with ${postModel.taggedUserList![0].user?.firstName ?? ''}';
      } else if (postModel.taggedUserList!.length > 1) {
        return ' with ${postModel.taggedUserList![0].user?.firstName ?? ''} and ${postModel.taggedUserList!.length - 1} others';
      } else {
        return '';
      }
    } else {
      return '';
    }
  }

  String getSharedHeaderTextAsPostType(PostModel postModel) {
    switch (postModel.share_post_id!.post_type) {
      case 'timeline_post':
        return '';
      case 'page_post':
        return '';
      case 'profile_picture':
        return 'updated his profile picture';
      case 'cover_picture':
        return 'updated his cover photo';
      case 'event':
        return '';
      case 'shared_reels':
        return '';
      case 'birthday':
        return '';
      case 'campaign':
        return '';
      default:
        return '';
    }
  }

  Widget ReactionIcon(String reactionPath) {
    return Image(
        height: 17, image: NetworkImage((reactionPath).formatedFeelingUrl));
  }
}
