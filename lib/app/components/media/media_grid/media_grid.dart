import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../video_player/post/newsfeed_post_video_player.dart';
import '../../../utils/image_utils.dart';
import '../../image.dart';
part 'double_media_view.dart';
part 'fourple_media_view.dart';
part 'more_media_view.dart';
part 'single_media_view.dart';
part 'tripple_media_view.dart';

class MediaGridView extends StatelessWidget {
  const MediaGridView({
    super.key,
    required this.mediaUrls,
    required this.onTapViewMoreMedia,
    this.onTapMediaIndex,
  });

  final VoidCallback onTapViewMoreMedia;
  final List<String> mediaUrls;
  final Function(int index)? onTapMediaIndex;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapViewMoreMedia,
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).cardTheme.color),
        child: getViewAsMedia(
          mediaUrls,
          onTapMediaIndex ?? (int index) {}, // Default callback if not provided
        ),
      ),
    );
  }
}

Widget getViewAsMedia(
    List<String> mediaUrls, Function(int index) onTapMediaIndex) {
  switch (mediaUrls.length) {
    case 1:
      return SingleMediaView(mediaUrls: mediaUrls, onTap: onTapMediaIndex);
    case 2:
      return DoubleMediaView(mediaUrls: mediaUrls, onTap: onTapMediaIndex);
    case 3:
      return TrippleMediaView(mediaUrls: mediaUrls, onTap: onTapMediaIndex);
    case 4:
      return FourpleMediaView(mediaUrls: mediaUrls, onTap: onTapMediaIndex);
    default:
      return MoreMediaView(mediaUrls: mediaUrls, onTap: onTapMediaIndex);
  }
}

class ContentView extends StatelessWidget {
  const ContentView({
    super.key,
    required this.url,
    this.imageHeight = 250,
  });
  final String url;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return isImageUrl(url)
        ? PrimaryNetworkImage(
            height: imageHeight,
            width: double.maxFinite,
            imageUrl: url,
            fitImage: BoxFit.cover,
          )
        : SizedBox(
            height: 250,

            ///Todo: Need post model here...with ad url
            child: NewsFeedPostVideoPlayer(
              postId: '',
              videoSrc: url,
            ),
          );
  }
}
