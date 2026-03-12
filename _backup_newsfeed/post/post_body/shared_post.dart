part of 'post_body.dart';

class SharedPost extends StatelessWidget {
  const SharedPost({super.key, required this.postModel, required this.onTapViewMoreMedia, required this.onTapShareViewOtherProfile});

  final PostModel postModel;
  final VoidCallback onTapViewMoreMedia;
  final VoidCallback onTapShareViewOtherProfile;

  @override
  Widget build(BuildContext context) {
    List<String> imageUrls = [];

    for (MediaModel media in postModel.shareMedia ?? []) {
      imageUrls.add((media.media ?? '').formatedPostUrl);
    }
    List<String> docFilesList = [];

    for (MediaModel media in postModel.shareMedia ?? []) {
      docFilesList.add((media.media ?? ''));
    }
//======================== event type shared post================================//
    return postModel.share_post_id?.event_type != null && postModel.share_post_id?.event_type != ''
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [getSharedEventIcon(postModel)],
              ),
              postModel.share_post_id?.event_type == 'travel'
                  ? Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 8.0, right: 8.0),
                      child: ExpandableText(
                        postModel.share_post_id?.lifeEventId?.title ?? '',
                        expandText: 'See more',
                        maxLines: 5,
                        collapseText: 'See less',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ))
                  : Container(),
              postModel.share_post_id?.event_type == 'customevent'
                  ? Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        textAlign: TextAlign.center,
                        getSharedCustomEventText(postModel),
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    )
                  : postModel.share_post_id?.event_type == 'milestonesandachievements'
                      ? Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            textAlign: TextAlign.center,
                            getSharedMilestonEventText(postModel),
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        )
                      : postModel.share_post_id?.event_type == 'travel'
                          ? Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                textAlign: TextAlign.center,
                                getSharedTravelEventText(postModel),
                                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                            )
                          : postModel.share_post_id?.event_type == 'relationship'
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: InkWell(
                                    onTap: onTapShareViewOtherProfile,
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      getSharedRelationEventText(postModel),
                                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              : postModel.share_post_id?.event_type == 'education'
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        getSharedEducationEventText(postModel),
                                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Text(textAlign: TextAlign.center, getSharedWorkEventText(postModel), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                                    ),
              const SizedBox(
                height: 3,
              ),
              postModel.share_post_id?.event_type == 'customevent'
                  ? Text(
                      getDynamicFormatedTime(postModel.share_post_id?.lifeEventId?.date.toString() ?? ''),
                      style: TextStyle(
                        fontSize: Get.height * 0.015,
                      ),
                    )
                  : postModel.share_post_id?.event_type == 'milestonesandachievements'
                      ? Text(
                          getDynamicFormatedTime(postModel.share_post_id?.lifeEventId?.date.toString() ?? ''),
                          style: TextStyle(
                            fontSize: Get.height * 0.015,
                          ),
                        )
                      : postModel.event_type == 'travel'
                          ? Text(
                              getDynamicFormatedTime(postModel.share_post_id?.lifeEventId?.date.toString() ?? ''),
                              style: TextStyle(
                                fontSize: Get.height * 0.015,
                              ),
                            )
                          : postModel.share_post_id?.event_type == 'relationship'
                              ? Text(
                                  getDynamicFormatedTime(postModel.share_post_id?.lifeEventId?.date.toString() ?? ''),
                                  style: TextStyle(
                                    fontSize: Get.height * 0.015,
                                  ),
                                )
                              : postModel.share_post_id?.event_type == 'education'
                                  ? Text(
                                      postModel.share_post_id!.event_sub_type!.contains('New School')
                                          ? getDynamicFormatedTime(postModel.share_post_id!.institute_id?.startDate.toString() ?? '')
                                          : postModel.share_post_id!.event_sub_type!.contains('Graduate')
                                              ? getDynamicFormatedTime(postModel.share_post_id!.institute_id?.endDate ?? '')
                                              : getDynamicFormatedTime(postModel.share_post_id!.institute_id?.endDate ?? ''),
                                      style: TextStyle(
                                        fontSize: Get.height * 0.015,
                                      ),
                                    )
                                  : Text(
                                      postModel.share_post_id!.event_sub_type!.contains('New Job')
                                          ? getDynamicFormatedTime(postModel.share_post_id!.workplace_id?.fromDate ?? '')
                                          : postModel.share_post_id!.event_sub_type!.contains('Promotion')
                                              ? getDynamicFormatedTime(postModel.share_post_id!.workplace_id?.fromDate ?? '')
                                              : postModel.share_post_id!.event_sub_type!.contains('Left Job')
                                                  ? getDynamicFormatedTime(postModel.share_post_id!.workplace_id?.toDate ?? '')
                                                  : getDynamicFormatedTime(postModel.share_post_id!.workplace_id?.toDate ?? ''),
                                      style: TextStyle(
                                        fontSize: Get.height * 0.015,
                                      )),
              postModel.share_post_id?.event_type == 'relationship' || postModel.share_post_id?.event_type == 'travel' || postModel.share_post_id?.event_type == 'milestonesandachievements' || postModel.share_post_id?.event_type == 'customevent'
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
                            child: Align(alignment: Alignment.center, child: getSharedEventIcon(postModel, height: 32, width: 32)),
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
                            child: Align(alignment: Alignment.center, child: getSharedEventIcon(postModel, height: 32, width: 32)),
                          )
                        ],
                      ),
                    ),
              postModel.share_post_id?.event_type == 'relationship' || postModel.share_post_id?.event_type == 'travel' || postModel.share_post_id?.event_type == 'milestonesandachievements' || postModel.share_post_id?.event_type == 'customevent'
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: ExpandableText(
                        postModel.share_post_id!.lifeEventId?.description ?? '',
                        expandText: 'See more',
                        maxLines: 5,
                        collapseText: 'See less',
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: ExpandableText(
                        postModel.share_post_id?.description ?? '',
                        expandText: 'See more',
                        maxLines: 5,
                        collapseText: 'See less',
                      ),
                    ),
              const SizedBox(
                height: 5,
              ),
            ],
          )
        //====================================  Group File Type Shared Post =======================================//
        : postModel.share_post_id?.post_type == 'group_file'
            ? GestureDetector(
                onTap: () {
                  debugPrint('Download Your File');
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        ExpandableText(
                          postModel.share_post_id?.description ?? '',
                          expandText: 'See more',
                          maxLines: 5,
                          collapseText: 'See less',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    for (var i = 0; i < docFilesList.length; i++)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        height: 50,
                        decoration: BoxDecoration(color: const Color.fromARGB(255, 221, 241, 240), border: Border.all(style: BorderStyle.none), borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            Image.asset(
                              getFileIconAsset(postModel.shareMedia?[i].media),
                              height: 30,
                              width: 30,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                docFilesList[i],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                softWrap: false,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 10),
                  ],
                ),
              )
            : postModel.share_post_id?.post_type == 'timeline_post'
                ? SharedTimelinePost(
                    postModel: postModel,
                    sharedPostModel: postModel.share_post_id!,
                    onTapViewMoreMedia: () {},
                    onTapViewOtherProfile: () {},
                  )
                :
                // ==================== Shared Campaign Start==========================//
                postModel.share_post_id?.post_type == 'campaign'
                    ? postModel.share_post_id?.campaignModel?.id != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(top: 5.0, left: 8.0, right: 8.0, bottom: 8),
                                  child: ExpandableText(
                                    postModel.share_post_id?.campaignModel?.description ?? '',
                                    expandText: 'See more',
                                    maxLines: 3,
                                    collapseText: 'See less',
                                    style: const TextStyle(fontWeight: FontWeight.normal),
                                  )),
                              (postModel.share_post_id?.campaignModel?.campaignCoverPic?.length) == 1
                                  ? InkWell(
                                      onTap: () {
                                        UriUtils.launchUrlInBrowser(postModel.campaign_id?.website_url ?? '');
                                      },
                                      child: PrimaryNetworkImage(
                                        imageUrl: ('${postModel.share_post_id?.campaignModel?.campaignCoverPic?[0]}').formatedAdsUrl,
                                      ),
                                    )
                                  : CarouselSlider(
                                      options: CarouselOptions(
                                        aspectRatio: 6 / 3,
                                        autoPlay: true,
                                        viewportFraction: 0.8,
                                        scrollPhysics: const BouncingScrollPhysics(),
                                      ),
                                      items: (postModel.campaign_id?.campaign_cover_pic ?? [])
                                          .map(
                                            (item) => InkWell(
                                              onTap: () {
                                                UriUtils.launchUrlInBrowser(postModel.campaign_id?.website_url ?? '');
                                              },
                                              child: Container(
                                                  height: 256,
                                                  width: double.maxFinite,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.white),
                                                    color: Colors.white,
                                                  ),
                                                  child: Image(fit: BoxFit.fitWidth, image: NetworkImage((item).formatedPostUrl))),
                                            ),
                                          )
                                          .toList(),
                                    ),
                              postModel.share_post_id?.campaignModel?.id != null
                                  ? InkWell(
                                      onTap: () {
                                        UriUtils.launchUrlInBrowser(postModel.campaign_id?.website_url ?? '');
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(color: Colors.grey.shade400),
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: [
                                                  Text('${postModel.share_post_id?.campaignModel?.campaignName?.capitalizeFirst}'.tr,
                                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 10.0),
                                                    child: Text(
                                                      postModel.share_post_id?.campaignModel?.websiteUrl ?? '',
                                                      style: const TextStyle(fontWeight: FontWeight.normal),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: PRIMARY_COLOR, // Background color
                                                foregroundColor: Colors.white, // Text color
                                                padding: const EdgeInsets.symmetric(
                                                  vertical: 10, // Vertical padding
                                                  horizontal: 20, // Horizontal padding
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8), // Rounded corners
                                                ),
                                              ),
                                              onPressed: () {
                                                UriUtils.launchUrlInBrowser(postModel.campaign_id?.website_url ?? '');
                                              },
                                              child: Text('${postModel.share_post_id?.link_title}'.tr,
                                                style: const TextStyle(
                                                  fontSize: 16, // Adjust font size if needed
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        UriUtils.launchUrlInBrowser(postModel.campaign_id?.website_url ?? '');
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(color: Colors.grey.shade400),
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: [
                                                  Text('${postModel.campaign_id?.website_url}'.tr,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  Text('${postModel.campaign_id?.headline}'.tr,
                                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: PRIMARY_COLOR,
                                                foregroundColor: Colors.white,
                                                side: const BorderSide(color: Colors.green, width: 2),
                                                padding: const EdgeInsets.symmetric(
                                                  vertical: 10,
                                                  horizontal: 20,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                elevation: 0,
                                              ),
                                              onPressed: () {
                                                UriUtils.launchUrlInBrowser(postModel.campaign_id?.website_url ?? '');
                                              },
                                              child: Text('${postModel.campaign_id?.call_to_action}'.tr,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              postModel.share_post_id?.adProduct?.media?.length == 1
                                  ? PrimaryNetworkImage(
                                      imageUrl: ('${postModel.share_post_id?.adProduct?.media?[0]}').formatedAdsUrl,
                                    )
                                  : postModel.share_post_id?.adProduct?.media != null
                                      ? CarouselSlider(
                                          options: CarouselOptions(
                                            aspectRatio: 6 / 3,
                                            autoPlay: true,
                                            viewportFraction: 0.8,
                                            scrollPhysics: const BouncingScrollPhysics(),
                                          ),
                                          items: (postModel.share_post_id?.adProduct?.media ?? [])
                                              .map(
                                                (item) => InkWell(
                                                  onTap: () {
                                                    // launchMyURL(postModel.adProduct?. ?? '');
                                                  },
                                                  child: Container(
                                                      height: 256,
                                                      width: double.maxFinite,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.white),
                                                        color: Colors.white,
                                                      ),
                                                      child: Image(
                                                        fit: BoxFit.fitWidth,
                                                        image: NetworkImage((item).formatedProductUrlLive),
                                                        errorBuilder: (context, error, stackTrace) {
                                                          return Image.asset(AppAssets.DEFAULT_IMAGE);
                                                        },
                                                      )),
                                                ),
                                              )
                                              .toList(),
                                        )
                                      : CarouselSlider(
                                          options: CarouselOptions(
                                            aspectRatio: 6 / 3,
                                            autoPlay: true,
                                            viewportFraction: 0.8,
                                            scrollPhysics: const BouncingScrollPhysics(),
                                          ),
                                          items: (postModel.campaign_id?.campaign_cover_pic ?? [])
                                              .map(
                                                (item) => InkWell(
                                                  onTap: () {
                                                    UriUtils.launchUrlInBrowser(postModel.campaign_id?.website_url ?? '');
                                                  },
                                                  child: Container(
                                                      height: 256,
                                                      width: double.maxFinite,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.white),
                                                        color: Colors.white,
                                                      ),
                                                      child: Image(fit: BoxFit.fitWidth, image: NetworkImage((item).formatedPostUrl))),
                                                ),
                                              )
                                              .toList(),
                                        ),
                              postModel.share_post_id?.adProduct?.id != null
                                  ? InkWell(
                                      onTap: () {
                                        Get.toNamed(Routes.PRODUCT_DETAILS, arguments: postModel.share_post_id?.adProduct?.id);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(color: Colors.grey.shade400),
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: [
                                                  Text('${postModel.share_post_id?.adProduct?.productName?.capitalizeFirst}'.tr,
                                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text('\$${postModel.share_post_id?.adProduct?.baseMainPrice?.toStringAsFixed(2)}'.tr,
                                                        style: const TextStyle(
                                                          color: Colors.red,
                                                          fontWeight: FontWeight.bold,
                                                          decoration: TextDecoration.lineThrough,
                                                          decorationThickness: 3,
                                                          decorationColor: Color.fromARGB(255, 196, 20, 7),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text('\$${postModel.share_post_id?.adProduct?.baseSellingPrice?.toStringAsFixed(2)}'.tr,
                                                        style: const TextStyle(
                                                          color: PRIMARY_COLOR,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: PRIMARY_COLOR, // Background color
                                                foregroundColor: Colors.white, // Text color
                                                padding: const EdgeInsets.symmetric(
                                                  vertical: 10, // Vertical padding
                                                  horizontal: 20, // Horizontal padding
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8), // Rounded corners
                                                ),
                                              ),
                                              onPressed: () {
                                                Get.toNamed(Routes.PRODUCT_DETAILS, arguments: postModel.share_post_id?.adProduct?.id);
                                              },
                                              child: Text('${postModel.share_post_id?.link_title}'.tr,
                                                style: const TextStyle(
                                                  fontSize: 16, // Adjust font size if needed
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        UriUtils.launchUrlInBrowser(postModel.campaign_id?.website_url ?? '');
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(color: Colors.grey.shade400),
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: [
                                                  Text('${postModel.campaign_id?.website_url}'.tr,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  Text('${postModel.campaign_id?.headline}'.tr,
                                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: PRIMARY_COLOR,
                                                foregroundColor: Colors.white,
                                                side: const BorderSide(color: Colors.green, width: 2),
                                                padding: const EdgeInsets.symmetric(
                                                  vertical: 10,
                                                  horizontal: 20,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                elevation: 0,
                                              ),
                                              onPressed: () {
                                                UriUtils.launchUrlInBrowser(postModel.campaign_id?.website_url ?? '');
                                              },
                                              child: Text('${postModel.campaign_id?.call_to_action}'.tr,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                            ],
                          )
                    //================Shared Campaign Ends========================//
                    //====================================  Link Image Type Shared Post =======================================//

                    : postModel.share_post_id?.link_image == null || postModel.share_post_id?.link_image == ''
                        ? ((postModel.shareMedia?.length ?? 0) > 0)
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  (postModel.description?.isNotEmpty ?? true)
                                      ? Padding(
                                          padding: const EdgeInsets.only(left: 5, bottom: 10),
                                          child: ExpandableText(
                                            postModel.share_post_id?.description ?? '',
                                            expandText: 'See more',
                                            maxLines: 3,
                                            collapseText: 'See less',
                                            style: const TextStyle(fontWeight: FontWeight.normal),
                                          ))
                                      : const SizedBox(),
                                  ((postModel.shareMedia?.length ?? 0) > 1)
                                      ? SizedBox(
                                          height: 500,
                                          child: MediaGridView(mediaUrls: imageUrls, onTapViewMoreMedia: onTapViewMoreMedia),
                                        )
                                      : PrimaryNetworkImage(imageUrl: imageUrls[0]),
                                ],
                              )
                            : ((postModel.shareMedia?.length ?? 0) == 0)
                                ? Container(
                                    // =================================================== No Meida Post ===================================================
                                    height: (postModel.share_post_id?.post_background_color != null && postModel.share_post_id!.post_background_color!.isNotEmpty && postModel.share_post_id!.post_background_color! != '') ? 256 : null,
                                    // not having background color will make height dynamic
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(color: (postModel.share_post_id?.post_background_color != null && postModel.share_post_id!.post_background_color!.isNotEmpty) ? Color(int.parse('0xff${postModel.share_post_id!.post_background_color}')) : null),
                                    padding: const EdgeInsets.all(10),
                                    child: (postModel.share_post_id?.post_background_color != null && postModel.share_post_id?.post_background_color != '')
                                        ? Center(
                                            child: Text(
                                              postModel.share_post_id?.description ?? '',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(color: Colors.white, fontSize: 16),
                                            ),
                                          )
                                        : ExpandableText(
                                            postModel.share_post_id?.description ?? '',
                                            expandText: 'See more',
                                            maxLines: 5,
                                            collapseText: 'See less',
                                          ),
                                  )
                                //====================================  Text Link Shared Post =======================================//

                                : Column(
                                    // Link post design
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: RichText(text: TextSpan(children: getTextWithLink(postModel.share_post_id?.description ?? ''))),
                                      ),
                                      GestureDetector(
                                          onTap: () async {
                                            String url = postModel.share_post_id?.link ?? '';
                                            await launchUrl(Uri.parse(url));
                                          },
                                          child: PrimaryNetworkImage(imageUrl: postModel.share_post_id?.link_image ?? '')),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(color: Colors.grey.shade300),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Text(
                                              postModel.share_post_id?.link_title ?? '',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(postModel.share_post_id?.link_description ?? ''),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                        : Column(
                            // Link post design
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: RichText(text: TextSpan(children: getTextWithLink(postModel.share_post_id?.description ?? ''))),
                              ),
                              GestureDetector(
                                  onTap: () async {
                                    String url = postModel.share_post_id?.link ?? '';
                                    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                                  },
                                  child: PrimaryNetworkImage(imageUrl: postModel.share_post_id?.link_image ?? '')),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      postModel.share_post_id?.link_title ?? '',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(postModel.share_post_id?.link_description ?? ''),
                                  ],
                                ),
                              )
                            ],
                          );
  }
}
