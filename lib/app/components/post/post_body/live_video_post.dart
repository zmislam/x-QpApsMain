part of 'post_body.dart';

class LiveVideoPost extends StatelessWidget {
  final PostModel postModel;
  const LiveVideoPost({required this.postModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ====================== title ========================================
        postModel.description != null
            ? Padding(
                padding: const EdgeInsetsDirectional.only(
                    start: 12, end: 12, bottom: 12, top: 8),
                child: Text(
                  postModel.description ?? '',
                ),
              )
            : const SizedBox(),
        // ======================= play live video section =====================
        NewsFeedPostVideoPlayer(
          onNavigate: () => Get.toNamed(Routes.AUDIENCE_LIVE_STREAM_PREVIEW,
              arguments: postModel),
          postId: '',
          isLive: postModel.is_live == true && postModel.post_type == 'live',
          videoSrc: (postModel.url ?? '').formatedLiveStreamViewUrl,
        )
        // '${ApiConstant.SERVER_IP_PORT}/api/stream/get-live-video?type=posts&fileName=${postModel.media?.first.media ?? ''}')
      ],
    );
  }
}
