part of 'post_body.dart';

class SharedTimelinePost extends StatelessWidget {
  const SharedTimelinePost(
      {super.key,
      required this.postModel,
      required this.sharedPostModel,
      this.campaignWebUrl,
      this.campaignName,
      this.campaignDescription,
      this.campaignCallToAction,
      this.adVideoLink,
      this.actionButtonText,
      required this.onTapViewMoreMedia,
      required this.onTapViewOtherProfile});

  final PostModel postModel;
  final SharePostIdModel sharedPostModel;
  final VoidCallback onTapViewMoreMedia;
  final VoidCallback onTapViewOtherProfile;
  final String? adVideoLink;
  final String? campaignWebUrl;
  final String? campaignName;
  final String? campaignDescription;
  final String? actionButtonText;
  final VoidCallback? campaignCallToAction;

  @override
  Widget build(BuildContext context) {
    List<String> imageUrls = [];

    for (MediaModel media in postModel.shareMedia ?? []) {
      imageUrls.add((media.media ?? '').formatedPostUrl);
    }

    return (sharedPostModel.event_type?.isNotEmpty ?? false)
        ?
        //======================================================== Showing Event Post ========================================================//
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [getEventIcon(postModel)],
              ),
              sharedPostModel.event_type == 'travel'
                  ? Padding(
                      padding: const EdgeInsets.only(
                          top: 5.0, left: 8.0, right: 8.0),
                      child: ExpandableText(
                        sharedPostModel.lifeEventId?.title ?? '',
                        expandText: 'See more',
                        maxLines: 5,
                        collapseText: 'See less',
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ))
                  : Container(),
              sharedPostModel.event_type == 'customevent'
                  ? Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        textAlign: TextAlign.center,
                        getCustomEventText(postModel),
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    )
                  : sharedPostModel.event_type == 'milestonesandachievements'
                      ? Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            textAlign: TextAlign.center,
                            getMilestonEventText(postModel),
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        )
                      : sharedPostModel.event_type == 'travel'
                          ? Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                textAlign: TextAlign.center,
                                getTravelEventText(postModel),
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                            )
                          : sharedPostModel.event_type == 'relationship'
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: InkWell(
                                    onTap: () {
                                      ProfileNavigator.navigateToProfile(
                                          username: sharedPostModel.lifeEventId
                                                  ?.toUserId?.username ??
                                              '',
                                          isFromReels: 'false');
                                    },
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      getRelationEventText(postModel),
                                      style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              : sharedPostModel.event_type == 'education'
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
              sharedPostModel.event_type == 'customevent'
                  ? Text(
                      getDynamicFormatedTime(
                          sharedPostModel.lifeEventId?.date.toString() ?? ''),
                      style: TextStyle(
                        fontSize: Get.height * 0.015,
                      ),
                    )
                  : sharedPostModel.event_type == 'milestonesandachievements'
                      ? Text(
                          getDynamicFormatedTime(
                              sharedPostModel.lifeEventId?.date.toString() ??
                                  ''),
                          style: TextStyle(
                            fontSize: Get.height * 0.015,
                          ),
                        )
                      : sharedPostModel.event_type == 'travel'
                          ? Text(
                              getDynamicFormatedTime(sharedPostModel
                                      .lifeEventId?.date
                                      .toString() ??
                                  ''),
                              style: TextStyle(
                                fontSize: Get.height * 0.015,
                              ),
                            )
                          : sharedPostModel.event_type == 'relationship'
                              ? Text(
                                  getDynamicFormatedTime(sharedPostModel
                                          .lifeEventId?.date
                                          .toString() ??
                                      ''),
                                  style: TextStyle(
                                    fontSize: Get.height * 0.015,
                                  ),
                                )
                              : sharedPostModel.event_type == 'education'
                                  ? Text(
                                      sharedPostModel.event_sub_type!
                                              .contains('New School')
                                          ? getDynamicFormatedTime(postModel
                                                  .institute_id?.startDate ??
                                              '')
                                          : sharedPostModel.event_sub_type!
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
                                      sharedPostModel.event_sub_type!
                                              .contains('New Job')
                                          ? getDynamicFormatedTime(postModel
                                                  .workplace_id?.fromDate ??
                                              '')
                                          : sharedPostModel.event_sub_type!
                                                  .contains('Promotion')
                                              ? getDynamicFormatedTime(postModel
                                                      .workplace_id?.fromDate ??
                                                  '')
                                              : sharedPostModel.event_sub_type!
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
              sharedPostModel.event_type == 'relationship' ||
                      sharedPostModel.event_type == 'travel' ||
                      sharedPostModel.event_type ==
                          'milestonesandachievements' ||
                      sharedPostModel.event_type == 'customevent'
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
              sharedPostModel.event_type == 'relationship' ||
                      sharedPostModel.event_type == 'travel' ||
                      sharedPostModel.event_type ==
                          'milestonesandachievements' ||
                      sharedPostModel.event_type == 'customevent'
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: ExpandableText(
                        sharedPostModel.lifeEventId?.description ?? '',
                        expandText: 'See more',
                        maxLines: 5,
                        collapseText: 'see less',
                        style: const TextStyle(color: Colors.black),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: ExpandableText(
                        sharedPostModel.description ?? '',
                        expandText: 'See more',
                        maxLines: 5,
                        collapseText: 'See less',
                        style: const TextStyle(color: Colors.black),
                      ),
                    )
            ],
          )
        : sharedPostModel.link_image == null || sharedPostModel.link_image == ''
            //======================================================== Showing Image with Description Post ========================================================//

            ? ((postModel.shareMedia?.length ?? 0) > 0)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      (sharedPostModel.description?.isNotEmpty ?? true)
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(left: 5, bottom: 10),
                              child: ExpandableText(
                                sharedPostModel.description ?? '',
                                expandText: 'See more',
                                maxLines: 5,
                                collapseText: 'See less',
                                style: const TextStyle(color: Colors.black),
                              ),
                            )
                          : const SizedBox(),
                      ((postModel.shareMedia?.length ?? 0) > 1)
                          ? SizedBox(
                              height: 500,
                              child: MediaGridView(
                                  mediaUrls: imageUrls,
                                  onTapViewMoreMedia: () {
                                    Get.to(() =>
                                        SingleImage(imgURL: imageUrls[0]));
                                  }),
                            )
                          : InkWell(
                              onTap: () {
                                Get.to(() => SingleImage(imgURL: imageUrls[0]));
                              },
                              child: isImageUrl(imageUrls[0])
                                  ? PrimaryNetworkImage(imageUrl: imageUrls[0])
                                  : SizedBox(
                                      // height: 250,
                                      child: NewsFeedPostVideoPlayer(
                                        postId: postModel.id ?? '',
                                        //actionButtonText: actionButtonText,
                                        videoSrc: imageUrls[0],
                                        //adVideoLink: adVideoLink,
                                        //campaignCallToAction:campaignCallToAction,
                                        //campaignDescription:campaignDescription,
                                        //campaignName: campaignName,
                                        //campaignWebUrl: campaignWebUrl,
                                        // onSixSeconds: onSixSeconds
                                      ),
                                    )),
                    ],
                  )
                : ((postModel.shareMedia?.length ?? 0) == 0)
                    ? Container(
                        // =================================================== No Media Post ===================================================
                        height: PostBackground.hasBackground(sharedPostModel.post_background_color)
                            ? 256
                            : null, // not having background color will make height dynamic
                        width: double.maxFinite,
                        decoration: PostBackground.decorationFromStoredValue(sharedPostModel.post_background_color) ?? const BoxDecoration(),
                        padding: const EdgeInsets.all(10),
                        child: PostBackground.hasBackground(sharedPostModel.post_background_color)
                            ? Center(
                                child: Text(
                                  sharedPostModel.description ?? '',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: PostBackground.textColorFromStoredValue(sharedPostModel.post_background_color), fontSize: 16),
                                ),
                              )
                            : ExpandableText(
                                sharedPostModel.description ?? '',
                                expandText: 'See more',
                                maxLines: 5,
                                collapseText: 'See less',
                                style: const TextStyle(color: Colors.black),
                              ),
                      )
                    : Column(
                        //======================================================== Showing Link Post ========================================================//
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: RichText(
                                text: TextSpan(
                                    children: getTextWithLink(
                                        sharedPostModel.description ?? ''))),
                          ),
                          GestureDetector(
                              onTap: () async {
                                String url = sharedPostModel.link.toString();
                                await launchUrl(Uri.parse(url));
                              },
                              child: PrimaryNetworkImage(
                                  imageUrl: sharedPostModel.link_image!)),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration:
                                BoxDecoration(color: Colors.grey.shade300),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  sharedPostModel.link_title ?? '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ExpandableText(
                                  sharedPostModel.link_description ?? '',
                                  expandText: 'See more',
                                  maxLines: 5,
                                  collapseText: 'See less',
                                  style: const TextStyle(color: Colors.black),
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
                      child: LinkText(text: sharedPostModel.description ?? '')),
                  GestureDetector(
                      onTap: () async {
                        String url = sharedPostModel.link.toString();
                        await launchUrl(Uri.parse(url),
                            mode: LaunchMode.externalApplication);
                      },
                      child: PrimaryNetworkImage(
                          imageUrl: sharedPostModel.link_image!)),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.grey.shade300),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          sharedPostModel.link_title ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(sharedPostModel.link_description ?? ''),
                      ],
                    ),
                  )
                ],
              );
  }
}
