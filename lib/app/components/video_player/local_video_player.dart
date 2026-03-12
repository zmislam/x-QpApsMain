// // import 'package:flutter/cupertino.dart';
//
// import 'dart:io';
//
// import 'package:chewie/chewie.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:video_player/video_player.dart';
// import 'package:visibility_detector/visibility_detector.dart';
//
// class LocalVideoPlay extends StatefulWidget {
//   final String videoFile;
//     final VoidCallback onCancel; // Add a callback for cancel action
//
//   const LocalVideoPlay({super.key, required this.videoFile, required this.onCancel});
//
//   @override
//   VideoPlayState createState() => VideoPlayState();
// }
//
// class VideoPlayState extends State<LocalVideoPlay> {
//   late VideoPlayerController _controller;
//   ChewieController? _chewieController;
//   Rx<bool> isPlaying = true.obs;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.file(File(widget.videoFile))
//     // networkUrl(Uri.parse(widget.videoLink))
//       ..initialize().then((_) {
//         setState(() {
//           _chewieController = ChewieController(
//             videoPlayerController: _controller,
//             autoPlay: false,
//             looping: false,
//             additionalOptions: (context) {
//               return [
//                 OptionItem(
//                   onTap: () {
//                     widget.onCancel(); // Call the cancel callback
//                     // _chewieController?.();
//                   },
//                   iconData: Icons.cancel,
//                   title: 'Cancel'.tr,
//                 ),
//               ];
//             },
//           );
//         });
//       })
//       ..play();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return VisibilityDetector(
//       key: Key(widget.videoFile),
//       onVisibilityChanged: (visibilityInfo) {
//         if (visibilityInfo.visibleFraction > 0.5) {
//           _controller.play();
//         } else {
//           _controller.pause();
//         }
//       },
//       child: _chewieController != null &&
//               _chewieController!.videoPlayerController.value.isInitialized
//           ? Chewie(
//               controller: _chewieController!,
//             )
//           : const Center(
//               child: CircularProgressIndicator(),
//             ),
//     );
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//     _chewieController?.dispose();
//   }
// }
