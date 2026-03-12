import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../NAVIGATION_MENUS/reels/controllers/reels_controller.dart';

class SearchVideoPlayer extends StatefulWidget {
  const SearchVideoPlayer({super.key,required this.url});

  final String url;

  @override
  State<SearchVideoPlayer> createState() => _SearchVideoPlayerState();
}

class _SearchVideoPlayerState extends State<SearchVideoPlayer> {


  ReelsController videoController = Get.find();
  late VideoPlayerController _controller;


  @override
  Widget build(BuildContext context) {
    return VideoPlayer(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        setState(() {});
      })
      ..setLooping(false)
      ..play();
  }
}
