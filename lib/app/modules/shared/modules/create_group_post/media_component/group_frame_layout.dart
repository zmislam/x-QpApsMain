
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../extension/num.dart';
import 'group_media_file_view.dart';
import 'group_more_media_count_hover.dart';


class GroupFrameLayout extends StatelessWidget {
  const GroupFrameLayout({
    Key? key,
    required this.mediaUrlList, required this.onTapRemoveMediaFile, required this.index,
  }) : super(key: key);

  final List<String> mediaUrlList;
  final VoidCallback onTapRemoveMediaFile;
  final int index;

  @override
  Widget build(BuildContext context) {
    switch (mediaUrlList.length) {
      case 2:
        return FrameTwoMediaLayout(mediaUrlList: mediaUrlList, onTapRemoveMediaFile: onTapRemoveMediaFile,index:index);
      case 3:
        return FrameThreeMediaLayout(mediaUrlList: mediaUrlList, onTapRemoveMediaFile: onTapRemoveMediaFile,index:index);
      case 4:
        return FrameFourMediaLayout(mediaUrlList: mediaUrlList, onTapRemoveMediaFile: onTapRemoveMediaFile,index:index);
      case 5:
        return FrameFiveMediaLayout(mediaUrlList: mediaUrlList, onTapRemoveMediaFile: onTapRemoveMediaFile,index:index);
      default:
        return FrameMoreMediaLayout(mediaUrlList: mediaUrlList,  onTapRemoveMediaFile: onTapRemoveMediaFile,index:index);
    }
  }
}

class FrameTwoMediaLayout extends StatelessWidget {
  const FrameTwoMediaLayout({super.key, required this.mediaUrlList, required this.onTapRemoveMediaFile, required this.index});
  final List<String> mediaUrlList;
  final VoidCallback onTapRemoveMediaFile;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      padding: const EdgeInsets.all(10),
      width: Get.width,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: GroupMediaFileView(
              mediaUrl: mediaUrlList[0], onTapRemoveMediaFile: onTapRemoveMediaFile,index:0
            ),
          ),
          10.w,
          Expanded(
            flex: 1,
            child: GroupMediaFileView(
              mediaUrl: mediaUrlList[1], onTapRemoveMediaFile: onTapRemoveMediaFile,index:1
            ),
          ),
        ],
      ),
    );
  }
}

class FrameThreeMediaLayout extends StatelessWidget {
  const FrameThreeMediaLayout({super.key, required this.mediaUrlList, required this.onTapRemoveMediaFile, required this.index});
  final List<String> mediaUrlList;
  final VoidCallback onTapRemoveMediaFile;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      padding: const EdgeInsets.all(10),
      width: Get.width,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: GroupMediaFileView(
              mediaUrl: mediaUrlList[0], onTapRemoveMediaFile: onTapRemoveMediaFile,index:0
            ),
          ),
          10.w,
          Expanded(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: GroupMediaFileView(
                    mediaUrl: mediaUrlList[1], onTapRemoveMediaFile: onTapRemoveMediaFile,index:1
                  ),
                ),
                10.h,
                Expanded(
                  flex: 1,
                  child: GroupMediaFileView(
                    mediaUrl: mediaUrlList[2], onTapRemoveMediaFile: onTapRemoveMediaFile,index:2
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FrameFourMediaLayout extends StatelessWidget {
  const FrameFourMediaLayout({super.key, required this.mediaUrlList, required this.onTapRemoveMediaFile, required this.index});
  final List<String> mediaUrlList;
  final VoidCallback onTapRemoveMediaFile;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: Get.width,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 10,
                bottom: 20,
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: GroupMediaFileView(
                      mediaUrl: mediaUrlList[0], onTapRemoveMediaFile: onTapRemoveMediaFile,index:0
                    ),
                  ),
                  10.h,
                  Expanded(
                    flex: 1,
                    child: GroupMediaFileView(
                      mediaUrl: mediaUrlList[1], onTapRemoveMediaFile: onTapRemoveMediaFile,index:1
                    ),
                  ),
                ],
              ),
            ),
          ),
          10.w,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: GroupMediaFileView(
                      mediaUrl: mediaUrlList[2], onTapRemoveMediaFile: onTapRemoveMediaFile,index:2
                    ),
                  ),
                  10.h,
                  Expanded(
                    flex: 1,
                    child: GroupMediaFileView(
                      mediaUrl: mediaUrlList[3], onTapRemoveMediaFile: onTapRemoveMediaFile,index:3
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FrameFiveMediaLayout extends StatelessWidget {
  const FrameFiveMediaLayout({super.key, required this.mediaUrlList, required this.onTapRemoveMediaFile, required this.index});
  final List<String> mediaUrlList;
  final VoidCallback onTapRemoveMediaFile;
 final int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: Get.width,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 10,
                bottom: 20,
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: GroupMediaFileView(
                      mediaUrl: mediaUrlList[0], onTapRemoveMediaFile: onTapRemoveMediaFile,index:0
                    ),
                  ),
                  10.h,
                  Expanded(
                    flex: 1,
                    child: GroupMediaFileView(
                      mediaUrl: mediaUrlList[1], onTapRemoveMediaFile: onTapRemoveMediaFile,index:1
                    ),
                  ),
                ],
              ),
            ),
          ),
          10.w,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: GroupMediaFileView(
                      mediaUrl: mediaUrlList[2], onTapRemoveMediaFile: onTapRemoveMediaFile,index:2
                    ),
                  ),
                  10.h,
                  Expanded(
                    flex: 1,
                    child: GroupMediaFileView(
                      mediaUrl: mediaUrlList[3], onTapRemoveMediaFile: onTapRemoveMediaFile,index:3
                    ),
                  ),
                  10.h,
                  Expanded(
                    flex: 1,
                    child: GroupMediaFileView(
                      mediaUrl: mediaUrlList[4], onTapRemoveMediaFile: onTapRemoveMediaFile,index:4
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FrameMoreMediaLayout extends StatelessWidget {
  const FrameMoreMediaLayout({
    super.key,
    required this.mediaUrlList, required this.onTapRemoveMediaFile, required this.index,
  });
  final List<String> mediaUrlList;
  final VoidCallback onTapRemoveMediaFile;
  final int index;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: Get.width,
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: FileImage(File(mediaUrlList[0])),
      //     fit: BoxFit.cover,
      //     opacity: 0.5,
      //   ),
      // ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 10,
                bottom: 20,
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: GroupMediaFileView(
                      mediaUrl: mediaUrlList[0], onTapRemoveMediaFile: onTapRemoveMediaFile,index:0
                    ),
                  ),
                  10.h,
                  Expanded(
                    flex: 1,
                    child: GroupMediaFileView(
                      mediaUrl: mediaUrlList[1], onTapRemoveMediaFile: onTapRemoveMediaFile,index:1
                    ),
                  ),
                ],
              ),
            ),
          ),
          10.w,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: GroupMediaFileView(
                      mediaUrl: mediaUrlList[2], onTapRemoveMediaFile: onTapRemoveMediaFile,index:2
                    ),
                  ),
                  10.h,
                  Expanded(
                    flex: 1,
                    child: GroupMediaFileView(
                      mediaUrl: mediaUrlList[3], onTapRemoveMediaFile: onTapRemoveMediaFile,index:3
                    ),
                  ),
                  10.h,
                  Expanded(
                    flex: 1,
                    child: GroupMoreMeidaCoutHover(
                      moreCount: mediaUrlList.length - 5,
                      child: GroupMediaFileView(
                        mediaUrl: mediaUrlList[4], onTapRemoveMediaFile: onTapRemoveMediaFile,index:4
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
