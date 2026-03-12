part of 'post_body.dart';

class CampaignPost extends StatelessWidget {
  const CampaignPost({
    super.key,
    required this.postModel,
  });

  final PostModel postModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Check if campaign_cover_pic exists and has exactly one item
        postModel.campaign_id?.campaign_cover_pic?.isNotEmpty ?? false
            ? postModel.campaign_id?.campaign_cover_pic?.length == 1
                ? PrimaryNetworkImage(
                    imageUrl:
                        ('${postModel.campaign_id?.campaign_cover_pic?[0]}')
                            .formatedAdsUrl,
                  )
                : ((('${postModel.campaign_id?.campaign_cover_pic?[0]}'))
                        .isVideo)
                    ? SizedBox(
                        child: NewsFeedPostVideoPlayer(
                          onNavigate: () => Get.to(PostDetailsVideoScreen(
                              videoSrc:
                                  ('${postModel.campaign_id?.campaign_cover_pic?[0]}')
                                      .formatedAdsUrl)),
                          postId: '',
                          videoSrc:
                              ('${postModel.campaign_id?.campaign_cover_pic?[0]}')
                                  .formatedAdsUrl,
                        ),
                      )
                    : postModel.adProduct?.media != null
                        ? CarouselSlider(
                            options: CarouselOptions(
                              aspectRatio: 6 / 3,
                              autoPlay: true,
                              viewportFraction: 0.8,
                              scrollPhysics: const BouncingScrollPhysics(),
                            ),
                            items: (postModel.adProduct?.media ?? [])
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
                                        image: NetworkImage(
                                            (item).formatedProductUrlLive),
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                              AppAssets.DEFAULT_IMAGE);
                                        },
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          )
                        : CarouselSlider(
                            options: CarouselOptions(
                              aspectRatio: 6 / 3,
                              autoPlay: true,
                              viewportFraction: 1,
                              scrollPhysics: const BouncingScrollPhysics(),
                            ),
                            items: (postModel.campaign_id?.campaign_cover_pic ??
                                    [])
                                .map(
                                  (item) => InkWell(
                                    onTap: () {
                                      UriUtils.launchUrlInBrowser(
                                          postModel.campaign_id?.website_url ??
                                              '');
                                    },
                                    child: Container(
                                        height: 256,
                                        width: double.maxFinite,
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.white),
                                          color: Colors.white,
                                        ),
                                        child: Image(
                                          fit: BoxFit.fitWidth,
                                          image: NetworkImage(
                                              (item).formatedAdsUrl),
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                              AppAssets.DEFAULT_IMAGE,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        )),
                                  ),
                                )
                                .toList(),
                          )
            : SizedBox.shrink(),
        postModel.adProduct?.id != null
            ? InkWell(
                onTap: () {
                  Get.toNamed(Routes.PRODUCT_DETAILS,
                      arguments: postModel.adProduct?.id);
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
                            Text(
                              '${postModel.adProduct?.productName?.capitalizeFirst}'
                                  .tr,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              children: [
                                Text(
                                  '\$${postModel.adProduct?.baseMainPrice?.toStringAsFixed(2)}'
                                      .tr,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.lineThrough,
                                    decorationThickness: 3,
                                    decorationColor:
                                        Color.fromARGB(255, 196, 20, 7),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '\$${postModel.adProduct?.baseSellingPrice?.toStringAsFixed(2)}'
                                      .tr,
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
                          backgroundColor: PRIMARY_COLOR,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Get.toNamed(Routes.PRODUCT_DETAILS,
                              arguments: postModel.adProduct?.id);
                        },
                        child: Text(
                          '${postModel.campaign_id?.call_to_action}'.tr,
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
                  UriUtils.launchUrlInBrowser(
                      postModel.campaign_id?.website_url ?? '');
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
                            Text(
                              '${postModel.campaign_id?.campaign_name}'.tr,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${postModel.campaign_id?.headline}'.tr,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
                          UriUtils.launchUrlInBrowser(
                              postModel.campaign_id?.website_url ?? '');
                        },
                        child: Text(
                          '${postModel.campaign_id?.call_to_action}'.tr,
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
    );
  }
}
