
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../components/media/media_frame/more_media_count_hover.dart';
import '../../../../../extension/num.dart';

import 'group_media_file_view.dart';


class GroupBannerLayout extends StatelessWidget {
  const GroupBannerLayout({
    Key? key,
    required this.mediaUrlList, required this.onTapRemoveMediaFile, required this.index,
  }) : super(key: key);

  final List<String> mediaUrlList;
  final VoidCallback  onTapRemoveMediaFile;
  final int index;

  @override
  Widget build(BuildContext context) {
    switch (mediaUrlList.length) {
      case 2:
        return BannerTwoMediaLayout(mediaUrlList: mediaUrlList,onTapRemoveMediaFile:onTapRemoveMediaFile,index:index);
      case 3:
        return BannerThreeMediaLayout(mediaUrlList: mediaUrlList,onTapRemoveMediaFile:onTapRemoveMediaFile,index:index);
      case 4:
        return BannerFourMediaLayout(mediaUrlList: mediaUrlList,onTapRemoveMediaFile:onTapRemoveMediaFile,index:index);
      default:
        return BannerMoreMediaLayout(mediaUrlList: mediaUrlList,onTapRemoveMediaFile:onTapRemoveMediaFile,index:index);
    }
  }
}

class BannerTwoMediaLayout extends StatelessWidget {
  const BannerTwoMediaLayout({super.key, required this.mediaUrlList, required this.onTapRemoveMediaFile, required this.index});
  final List<String> mediaUrlList;
  final VoidCallback  onTapRemoveMediaFile;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: Get.width,
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
    );
  }
}

class BannerThreeMediaLayout extends StatelessWidget {
  const BannerThreeMediaLayout({super.key, required this.mediaUrlList, required this.onTapRemoveMediaFile, required this.index});
  final List<String> mediaUrlList;
  final VoidCallback  onTapRemoveMediaFile;
  final int index;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: Get.width,
      child: Column(
        children: [
          Expanded(
            child: GroupMediaFileView(
              mediaUrl: mediaUrlList[0], onTapRemoveMediaFile: onTapRemoveMediaFile,index:0
            ),
          ),
          10.h,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: GroupMediaFileView(
                      mediaUrl: mediaUrlList[1], onTapRemoveMediaFile: onTapRemoveMediaFile,index:1
                    ),
                  ),
                  10.w,
                  Expanded(
                    flex: 1,
                    child: GroupMediaFileView(
                      mediaUrl: mediaUrlList[2], onTapRemoveMediaFile: onTapRemoveMediaFile,index:2
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

class BannerFourMediaLayout extends StatelessWidget {
  const BannerFourMediaLayout({super.key, required this.mediaUrlList, required this.onTapRemoveMediaFile, required this.index});
  final List<String> mediaUrlList;
  final VoidCallback  onTapRemoveMediaFile;
  final int index;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: Get.width,
      child: Column(
        children: [
          Expanded(
            child: GroupMediaFileView(
              mediaUrl: mediaUrlList[0], onTapRemoveMediaFile: onTapRemoveMediaFile,index:0
            ),
          ),
          10.h,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
                      mediaUrl: mediaUrlList[1], onTapRemoveMediaFile: onTapRemoveMediaFile,index:1,
                    ),
                  ),
                  10.w,
                  Expanded(
                    flex: 1,
                    child: GroupMediaFileView(
                      mediaUrl: mediaUrlList[2], onTapRemoveMediaFile: onTapRemoveMediaFile,index:2
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

class BannerMoreMediaLayout extends StatelessWidget {
  const BannerMoreMediaLayout({super.key, required this.mediaUrlList, required this.onTapRemoveMediaFile, required this.index});
  final List<String> mediaUrlList;
  final VoidCallback  onTapRemoveMediaFile;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: Get.width,
   
      child: Column(
        children: [
          Expanded(
            child: GroupMediaFileView(
              mediaUrl: mediaUrlList[0], onTapRemoveMediaFile: onTapRemoveMediaFile,index:0
            ),
          ),
          10.h,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: GroupMediaFileView(
                      mediaUrl: mediaUrlList[1], onTapRemoveMediaFile: onTapRemoveMediaFile,index:1
                    ),
                  ),
                  10.w,
                  Expanded(
                    flex: 1,
                    child: GroupMediaFileView(
                      mediaUrl: mediaUrlList[2], onTapRemoveMediaFile: onTapRemoveMediaFile,index:2
                    ),
                  ),
                  10.w,
                  Expanded(
                    flex: 1,
                    child: MoreMeidaCoutHover(
                      moreCount: mediaUrlList.length - 4,
                      child: GroupMediaFileView(
                        mediaUrl: mediaUrlList[3], onTapRemoveMediaFile: onTapRemoveMediaFile,index:3
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
