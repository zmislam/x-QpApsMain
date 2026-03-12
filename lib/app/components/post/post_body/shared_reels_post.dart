part of 'post_body.dart';

class SharedReelsPost extends StatelessWidget {
  const SharedReelsPost({
    super.key,
    required this.postModel,
    this.adVideoLink,
    this.campaignWebUrl,
    this.campaignName,
    this.actionButtonText,
    this.campaignDescription,
    this.campaignCallToAction,
  });

  final PostModel postModel;
  final String? adVideoLink;
  final String? campaignWebUrl;
  final String? campaignName;
  final String? campaignDescription;
  final String? actionButtonText;
  final VoidCallback? campaignCallToAction;

  @override
  @override
  Widget build(BuildContext context) {
    final String? reelId = postModel.share_reels_id?.id;
    final String videoUrl = (postModel.share_reels_id?.video ?? '').formatedReelUrl;

    return SizedBox(
      child: NewsFeedPostVideoPlayer(
        onNavigate: () {
          final reelId = postModel.share_reels_id?.id ?? '';
          if (reelId.isNotEmpty) {
            Get.toNamed(Routes.REELS, arguments: {'reel_id': reelId});
          } else {
            Get.to(PostDetailsVideoScreen(
                videoSrc: (postModel.share_reels_id?.video ?? '').formatedReelUrl));
          }
        },
        postId: '',
        videoSrc: videoUrl,
      ),
    );
  }
}

