part of 'post_body.dart';

class PagePost extends StatelessWidget {
  const PagePost({
    super.key,
    required this.postModel,
    required this.onTapViewMoreMedia,
    this.adVideoLink,
    this.campaignWebUrl,
    this.campaignName,
    this.campaignDescription,
    this.actionButtonText,
    this.campaignCallToAction,
  });

  final PostModel postModel;
  final VoidCallback onTapViewMoreMedia;
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

    return postModel.link_image == null || postModel.link_image == ''
        //======================================================== Showing Image with Description Post ========================================================//

        ? ((postModel.media?.length ?? 0) > 0)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  (postModel.description?.isNotEmpty ?? true)
                      ? Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 10),
                          child: ExpandableText(
                            postModel.description ?? '',
                            expandText: 'See more',
                            maxLines: 10,
                            collapseText: 'See less',
                          ),
                        )
                      : const SizedBox(),
                  ((postModel.media?.length ?? 0) > 1)
                      ? (isMediaListContainVideoUrl(postModel.media) || (postModel.layout_type ?? '').isEmpty)
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
                          ? InkWell(onTap: onTapViewMoreMedia, child: PrimaryNetworkImage(imageUrl: imageUrls[0]))
                          : SizedBox(
                              // height: 250,
                              child: NewsFeedPostVideoPlayer(
                                onNavigate: () => Get.to(PostDetailsVideoScreen(videoSrc: imageUrls[0])),
                                postId: postModel.id ?? '',
                                videoSrc: imageUrls[0],
                              ),
                            ),
                ],
              )
            : ((postModel.media?.length ?? 0) == 0)
                ? Container(
                    // =================================================== No Media Post ===================================================
                    height: PostBackground.hasBackground(postModel.post_background_color) ? 320 : null,
                    // not having background color will make height dynamic
                    width: double.maxFinite,
                    decoration: PostBackground.decorationFromStoredValue(postModel.post_background_color) ?? const BoxDecoration(),
                    padding: const EdgeInsets.all(10),
                    child: PostBackground.hasBackground(postModel.post_background_color)
                        ? Center(
                            child: Text(
                              postModel.description ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 24, color: PostBackground.textColorFromStoredValue(postModel.post_background_color)),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: ExpandableText(
                              postModel.description ?? '',
                              expandText: 'See more',
                              maxLines: 5,
                              collapseText: 'See less',
                            ),
                          ),
                  )
                : Column(
                    //======================================================== Showing Link Post ========================================================//
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: RichText(text: TextSpan(children: getTextWithLink(postModel.description ?? ''))),
                      ),
                      GestureDetector(
                          onTap: () async {
                            String url = postModel.link.toString();
                            await launchUrl(Uri.parse(url));
                          },
                          child: PrimaryNetworkImage(imageUrl: postModel.link_image!)),
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
                  )
        : Column(
            //======================================================== Showing Link Post ========================================================//
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(padding: const EdgeInsets.all(10), child: LinkText(text: postModel.description ?? '')),
              GestureDetector(
                  onTap: () async {
                    String url = postModel.link.toString();
                    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                  },
                  child: PrimaryNetworkImage(imageUrl: postModel.link_image!)),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                ),
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
