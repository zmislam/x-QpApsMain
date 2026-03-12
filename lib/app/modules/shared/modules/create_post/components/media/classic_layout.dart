import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../extension/num.dart';
import 'more_media_count_hover.dart';
import 'media_file_view.dart';

class ClassicLayout extends StatelessWidget {
  const ClassicLayout({
    Key? key,
    required this.mediaUrlList,
    required this.onTapRemoveMediaFile,
    required this.index,
  }) : super(key: key);
  final int index;
  final VoidCallback onTapRemoveMediaFile;
  final List<String> mediaUrlList;
  @override
  Widget build(BuildContext context) {
    switch (mediaUrlList.length) {
      case 2:
        return ClassicTwoMediaLayout(
          mediaUrlList: mediaUrlList,
          onTapRemoveMediaFile: onTapRemoveMediaFile,
          index: index,
        );
      case 3:
        return ClassicThreeMediaLayout(
          mediaUrlList: mediaUrlList,
          onTapRemoveMediaFile: onTapRemoveMediaFile,
          index: index,
        );
      case 4:
        return ClassicFourMediaLayout(
          mediaUrlList: mediaUrlList,
          onTapRemoveMediaFile: onTapRemoveMediaFile,
          index: index,
        );
      default:
        return ClassicMoreMediaLayout(
          mediaUrlList: mediaUrlList,
          onTapRemoveMediaFile: onTapRemoveMediaFile,
          index: index,
        );
    }
  }
}

class ClassicTwoMediaLayout extends StatelessWidget {
  const ClassicTwoMediaLayout(
      {super.key,
      required this.mediaUrlList,
      required this.onTapRemoveMediaFile,
      required this.index});
  final List<String> mediaUrlList;
  final int index;

  final VoidCallback onTapRemoveMediaFile;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (Get.width / 2) - 10,
      width: Get.width,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: MediaFileView(
              mediaUrl: mediaUrlList[0],
              onTapRemoveMediaFile: onTapRemoveMediaFile,
              index: 0,
            ),
          ),
          10.w,
          Expanded(
            flex: 1,
            child: MediaFileView(
              mediaUrl: mediaUrlList[1],
              onTapRemoveMediaFile: onTapRemoveMediaFile,
              index: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class ClassicThreeMediaLayout extends StatelessWidget {
  const ClassicThreeMediaLayout(
      {super.key,
      required this.mediaUrlList,
      required this.onTapRemoveMediaFile,
      required this.index});
  final List<String> mediaUrlList;
  final VoidCallback onTapRemoveMediaFile;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      width: Get.width,
      child: Column(
        children: [
          Expanded(
            child: MediaFileView(
              mediaUrl: mediaUrlList[0],
                onTapRemoveMediaFile:onTapRemoveMediaFile,
              index: 0,
            ),
          ),
          10.h,
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: MediaFileView(
                    mediaUrl: mediaUrlList[1],
                                  onTapRemoveMediaFile:onTapRemoveMediaFile,

                    index: 1,
                  ),
                ),
                10.w,
                Expanded(
                  flex: 1,
                  child: MediaFileView(
                      mediaUrl: mediaUrlList[2],
                                  onTapRemoveMediaFile:onTapRemoveMediaFile,

                      index: 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ClassicFourMediaLayout extends StatelessWidget {
  const ClassicFourMediaLayout(
      {super.key,
      required this.mediaUrlList,
      required this.onTapRemoveMediaFile,
      required this.index});
  final List<String> mediaUrlList;
  final VoidCallback onTapRemoveMediaFile;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      width: Get.width,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: MediaFileView(
              mediaUrl: mediaUrlList[0],
              onTapRemoveMediaFile: onTapRemoveMediaFile,
              index: 0,
            ),
          ),
          10.w,
          Expanded(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: MediaFileView(
                    mediaUrl: mediaUrlList[1],
                    onTapRemoveMediaFile: onTapRemoveMediaFile,
                    index: 1,
                  ),
                ),
                10.h,
                Expanded(
                  flex: 1,
                  child: MediaFileView(
                    mediaUrl: mediaUrlList[2],
                    onTapRemoveMediaFile: onTapRemoveMediaFile,
                    index: 2,
                  ),
                ),
                10.h,
                Expanded(
                  flex: 1,
                  child: MediaFileView(
                    mediaUrl: mediaUrlList[3],
                    onTapRemoveMediaFile: onTapRemoveMediaFile,
                    index: 3,
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

class ClassicMoreMediaLayout extends StatelessWidget {
  const ClassicMoreMediaLayout(
      {super.key,
      required this.mediaUrlList,
      required this.onTapRemoveMediaFile,
      required this.index});
  final List<String> mediaUrlList;
  final VoidCallback onTapRemoveMediaFile;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      width: Get.width,
    
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: MediaFileView(
              mediaUrl: mediaUrlList[0],
              onTapRemoveMediaFile: onTapRemoveMediaFile,
              index: 0,
            ),
          ),
          10.w,
          Expanded(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: MediaFileView(
                    mediaUrl: mediaUrlList[1],
                    onTapRemoveMediaFile: onTapRemoveMediaFile,
                    index: 1,
                  ),
                ),
                10.h,
                Expanded(
                  flex: 1,
                  child: MediaFileView(
                    mediaUrl: mediaUrlList[2],
                    onTapRemoveMediaFile: onTapRemoveMediaFile,
                    index: 2,
                  ),
                ),
                10.h,
                Expanded(
                  flex: 1,
                  child: MoreMeidaCoutHover(
                    moreCount: mediaUrlList.length - 4,
                    child: MediaFileView(
                      mediaUrl: mediaUrlList[3],
                      onTapRemoveMediaFile: onTapRemoveMediaFile,
                      index: 3,
                    ),
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
