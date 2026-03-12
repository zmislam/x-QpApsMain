import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../components/video_player/post/newsfeed_post_video_player.dart';
import '../../../../../extension/string/string_image_path.dart';
import '../../../../../components/image.dart';
import '../../../../../models/media.dart';
import '../../../../../models/post.dart';
import '../../../../../utils/image_utils.dart';
import '../controller/multiple_image_controller.dart';

class MultipleImageView extends GetView<MultipleImageContoller> {
  final PostModel postModel;
  final int? initialIndex;

  const MultipleImageView(
      {super.key, required this.postModel, this.initialIndex});

  @override
  Widget build(BuildContext context) {
    // Combine videos and images into a single list
    List<MediaModel> mediaList = postModel.post_type == 'Shared'
        ? postModel.shareMedia ?? []
        : postModel.media ?? [];

    // Create a PageController with the initial index
    final PageController pageController =
        PageController(initialPage: initialIndex ?? 0);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, // Change your color here
        ),
        title: postModel.page_id?.pageName?.isNotEmpty == true
            ? Text(
                "${postModel.page_id?.pageName}'s Post",
                style: const TextStyle(color: Colors.black, fontSize: 15),
              )
            : Text(
                "${postModel.user_id?.first_name}'s Post",
                style: const TextStyle(color: Colors.black, fontSize: 15),
              ),
        // backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageController,
              itemCount: mediaList.length,
              // scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                final media = mediaList[index];
                final mediaUrl = (media.media ?? '').formatedPostUrl;

                // Determine if the media is a video or image
                if (isVideoUrl(mediaUrl)) {
                  return NewsFeedPostVideoPlayer(
                    videoSrc: mediaUrl,
                    postId: '',
                  );
                } else {
                  return PrimaryNetworkImage(
                    imageUrl: mediaUrl,
                    fitImage: BoxFit.fitWidth,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
