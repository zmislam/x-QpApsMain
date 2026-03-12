import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'details_post_video_player.dart';

class PostDetailsVideoScreen extends StatelessWidget {
  final String videoSrc;
  const PostDetailsVideoScreen({required this.videoSrc, super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              )),
        ),
        body: Center(
          child: DetailsPostVideoPlayer(videoSrc: videoSrc),
        ),
      ),
    );
  }
}
