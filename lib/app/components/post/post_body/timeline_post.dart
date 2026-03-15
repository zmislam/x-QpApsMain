part of 'post_body.dart';

class TimelinePost extends StatelessWidget {
  const TimelinePost(
      {super.key,
      required this.postModel,
      required this.onTapViewMoreMedia,
      required this.onSixSeconds,
      this.campaignWebUrl,
      this.campaignName,
      this.campaignDescription,
      this.campaignCallToAction,
      this.adVideoLink,
      this.actionButtonText,
      required this.onTapViewOtherProfile});

  final PostModel postModel;
  final VoidCallback onTapViewMoreMedia;
  final VoidCallback onTapViewOtherProfile;
  final VoidCallback onSixSeconds;
  final String? adVideoLink;
  final String? campaignWebUrl;
  final String? campaignName;
  final String? campaignDescription;
  final String? actionButtonText;
  final VoidCallback? campaignCallToAction;

  @override
  Widget build(BuildContext context) {
    List<String> imageUrls = [];

    for (MediaModel media in postModel.media ?? []) {
      imageUrls.add((media.media ?? '').formatedPostUrl);
    }

    return (postModel.event_type?.isNotEmpty ?? false)
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
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ))
                  : Container(),
              postModel.event_type == 'customevent'
                  ? Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        textAlign: TextAlign.center,
                        getCustomEventText(postModel),
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    )
                  : postModel.event_type == 'milestonesandachievements'
                      ? Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            textAlign: TextAlign.center,
                            getMilestonEventText(postModel),
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        )
                      : postModel.event_type == 'travel'
                          ? Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                textAlign: TextAlign.center,
                                getTravelEventText(postModel),
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                            )
                          : postModel.event_type == 'relationship'
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: InkWell(
                                    onTap: onTapViewOtherProfile,
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      getRelationEventText(postModel),
                                      style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              : postModel.event_type == 'education'
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        getEducationEventText(postModel),
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Text(
                                          textAlign: TextAlign.center,
                                          getWorkEventText(postModel),
                                          style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold)),
                                    ),
              const SizedBox(
                height: 3,
              ),
              postModel.event_type == 'customevent'
                  ? Text(
                      getDynamicFormatedTime(
                          postModel.lifeEventId?.date.toString() ?? ''),
                      style: TextStyle(
                        fontSize: Get.height * 0.015,
                      ),
                    )
                  : postModel.event_type == 'milestonesandachievements'
                      ? Text(
                          getDynamicFormatedTime(
                              postModel.lifeEventId?.date.toString() ?? ''),
                          style: TextStyle(
                            fontSize: Get.height * 0.015,
                          ),
                        )
                      : postModel.event_type == 'travel'
                          ? Text(
                              getDynamicFormatedTime(
                                  postModel.lifeEventId?.date.toString() ?? ''),
                              style: TextStyle(
                                fontSize: Get.height * 0.015,
                              ),
                            )
                          : postModel.event_type == 'relationship'
                              ? Text(
                                  getDynamicFormatedTime(
                                      postModel.lifeEventId?.date.toString() ??
                                          ''),
                                  style: TextStyle(
                                    fontSize: Get.height * 0.015,
                                  ),
                                )
                              : postModel.event_type == 'education'
                                  ? Text(
                                      postModel.event_sub_type!
                                              .contains('New School')
                                          ? getDynamicFormatedTime(postModel
                                                  .institute_id?.startDate ??
                                              '')
                                          : postModel.event_sub_type!
                                                  .contains('Graduate')
                                              ? getDynamicFormatedTime(postModel
                                                      .institute_id?.endDate ??
                                                  '')
                                              : getDynamicFormatedTime(postModel
                                                      .institute_id?.endDate ??
                                                  ''),
                                      style: TextStyle(
                                        fontSize: Get.height * 0.015,
                                      ),
                                    )
                                  : Text(
                                      postModel.event_sub_type!
                                              .contains('New Job')
                                          ? getDynamicFormatedTime(postModel
                                                  .workplace_id?.fromDate ??
                                              '')
                                          : postModel.event_sub_type!
                                                  .contains('Promotion')
                                              ? getDynamicFormatedTime(postModel
                                                      .workplace_id?.fromDate ??
                                                  '')
                                              : postModel.event_sub_type!
                                                      .contains('Left Job')
                                                  ? getDynamicFormatedTime(
                                                      postModel.workplace_id
                                                              ?.toDate ??
                                                          '')
                                                  : getDynamicFormatedTime(
                                                      postModel.workplace_id
                                                              ?.toDate ??
                                                          ''),
                                      style: TextStyle(
                                        fontSize: Get.height * 0.015,
                                      )),
              postModel.event_type == 'relationship' ||
                      postModel.event_type == 'travel' ||
                      postModel.event_type == 'milestonesandachievements' ||
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
                      postModel.event_type == 'milestonesandachievements' ||
                      postModel.event_type == 'customevent'
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: ExpandableText(
                        postModel.lifeEventId?.description ?? '',
                        expandText: 'See more',
                        maxLines: 5,
                        collapseText: 'see less',
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: ExpandableText(
                        postModel.description ?? '',
                        expandText: 'See more',
                        maxLines: 5,
                        collapseText: 'see less',
                      ),
                    )
            ],
          )
        : postModel.link_image == null || postModel.link_image == ''
            //======================================================== Showing Video with Description Post ========================================================//

            ? ((postModel.media?.length ?? 0) > 0)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      (postModel.description?.isNotEmpty ?? true)
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(left: 5, bottom: 10),
                              child: ExpandableText(
                                postModel.description ?? '',
                                expandText: 'See more',
                                maxLines: 5,
                                collapseText: 'See less',
                              ),
                            )
                          : const SizedBox(),
                      ((postModel.media?.length ?? 0) > 1)
                          ? (isMediaListContainVideoUrl(postModel.media) ||
                                  (postModel.layout_type ?? '').isEmpty)
                              ? MediaGridView(
                                  mediaUrls: imageUrls,
                                  onTapViewMoreMedia: onTapViewMoreMedia,
                                  onTapMediaIndex: (int tappedIndex) {
                                    // Navigate to MultipleImageView and pass the tappedIndex
                                    Get.to(MultipleImageView(
                                      postModel: postModel,
                                      initialIndex: tappedIndex,
                                    ));
                                  },
                                )
                              : PrimaryRemoteMediaComponent(
                                  mediaUrlList: imageUrls,
                                  mediaLayout: postModel.layout_type ?? '',
                                  onTapIndex: (int tappedIndex) {
                                    // Navigate to MultipleImageView and pass the tappedIndex
                                    Get.to(MultipleImageView(
                                      postModel: postModel,
                                      initialIndex: tappedIndex,
                                    ));
                                  },
                                )
                          // )
                          : isImageUrl(imageUrls[0])
                              ? InkWell(
                                  onTap: onTapViewMoreMedia,
                                  child: CustomCachedNetworkImage(
                                      imageUrl: imageUrls[0]))
                              : NewsFeedPostVideoPlayer(
                                  onNavigate: () {
                                    if (postModel.is_live == true) {
                                      Get.toNamed(
                                          Routes.AUDIENCE_LIVE_STREAM_PREVIEW,
                                          arguments: postModel);
                                    } else {
                                      Get.to(PostDetailsVideoScreen(
                                          videoSrc: imageUrls[0]));
                                    }
                                  },
                                  videoSrc: imageUrls[0],
                                  postId: postModel.id ?? ''),
                    ],
                  )
                : ((postModel.media?.length ?? 0) == 0)
                    ? Container(
                        // =================================================== No Media Post ===================================================
                        height: PostBackground.hasBackground(postModel.post_background_color)
                            ? 360
                            : null, // not having background color will make height dynamic
                        width: double.maxFinite,
                        decoration: PostBackground.decorationFromStoredValue(postModel.post_background_color) ?? const BoxDecoration(),
                        padding: const EdgeInsets.all(10),
                        child: PostBackground.hasBackground(postModel.post_background_color)
                            ? Center(
                                child: Text(
                                  postModel.description ?? '',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: PostBackground.textColorFromStoredValue(postModel.post_background_color)),
                                ),
                              )
                            : ExpandableText(
                                postModel.description ?? '',
                                expandText: 'See more',
                                maxLines: 5,
                                collapseText: 'See less',
                              ))
                    : Column(
                        //======================================================== Showing Link Post ========================================================//
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: RichText(
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                    children: getTextWithLink(
                                        postModel.description ?? ''))),
                          ),
                          GestureDetector(
                              onTap: () async {
                                String url = postModel.link.toString();
                                await launchUrl(Uri.parse(url));
                              },
                              child: CustomCachedNetworkImage(
                                  imageUrl: isImageUrl(imageUrls[0])
                                      ? imageUrls[0]
                                      : postModel.link_image!)),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration:
                                BoxDecoration(color: Colors.grey.shade300),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  postModel.link_title ?? '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ExpandableText(
                                  postModel.link_description ?? '',
                                  expandText: 'See more',
                                  maxLines: 5,
                                  collapseText: 'see less',
                                )
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
                      child: LinkText(text: postModel.description ?? '')),
                  GestureDetector(
                      onTap: () async {
                        String url = postModel.link.toString();
                        await launchUrl(Uri.parse(url),
                            mode: LaunchMode.externalApplication);
                      },
                      child: CustomCachedNetworkImage(
                        imageUrl:
                            (imageUrls.isNotEmpty && isImageUrl(imageUrls[0]))
                                ? imageUrls[0]
                                : postModel.link_image ?? '',
                      )),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.grey.shade300),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          postModel.link_title ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(postModel.link_description ?? ''),
                      ],
                    ),
                  )
                ],
              );
  }
}
