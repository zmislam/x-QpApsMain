import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../extension/num.dart';
import 'page_media_file_view.dart';
import 'page_more_media_count_hover.dart';


class PageColumnLayout extends StatelessWidget {
  const PageColumnLayout({
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
        return ColumnTwoMediaLayout(mediaUrlList: mediaUrlList, onTapRemoveMediaFile: onTapRemoveMediaFile,index:index);
      case 3:
        return ColumnThreeMediaLayout(mediaUrlList: mediaUrlList, onTapRemoveMediaFile:onTapRemoveMediaFile,index:index);
      case 4:
        return ColumnFourMediaLayout(mediaUrlList: mediaUrlList, onTapRemoveMediaFile: onTapRemoveMediaFile,index:index);
      default:
        return ColumnMoreMediaLayout(mediaUrlList: mediaUrlList, onTapRemoveMediaFile: onTapRemoveMediaFile,index:index);
    }
  }
}

class ColumnTwoMediaLayout extends StatelessWidget {
  const ColumnTwoMediaLayout({super.key, required this.mediaUrlList, required this.onTapRemoveMediaFile, required this.index});
  final List<String> mediaUrlList;
  final VoidCallback onTapRemoveMediaFile;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      width: Get.width,
 
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: PageMediaFileView(
              mediaUrl: mediaUrlList[0], onTapRemoveMediaFile: onTapRemoveMediaFile, index:0
            ),
          ),
          10.w,
          Expanded(
            flex: 1,
            child: PageMediaFileView(
              mediaUrl: mediaUrlList[1], onTapRemoveMediaFile:onTapRemoveMediaFile,index:1
            ),
          ),
        ],
      ),
    );
  }
}

class ColumnThreeMediaLayout extends StatelessWidget {
  const ColumnThreeMediaLayout({super.key, required this.mediaUrlList, required this.onTapRemoveMediaFile, required this.index});
  final List<String> mediaUrlList;
  final VoidCallback onTapRemoveMediaFile;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      width: Get.width,
    
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PageMediaFileView(
                isClipRect: true,
                mediaUrl: mediaUrlList[0], onTapRemoveMediaFile: onTapRemoveMediaFile,index:0
              ),
            ),
          ),
          10.w,
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: PageMediaFileView(
                isClipRect: true,
                mediaUrl: mediaUrlList[1], onTapRemoveMediaFile: onTapRemoveMediaFile,index:1
              ),
            ),
          ),
          10.w,
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PageMediaFileView(
                isClipRect: true,
                mediaUrl: mediaUrlList[2], onTapRemoveMediaFile: onTapRemoveMediaFile,index:2
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ColumnFourMediaLayout extends StatelessWidget {
  const ColumnFourMediaLayout({super.key, required this.mediaUrlList, required this.onTapRemoveMediaFile, required this.index});
  final List<String> mediaUrlList;
  final VoidCallback onTapRemoveMediaFile;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      width: Get.width,
     
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PageMediaFileView(
                isClipRect: true,
                mediaUrl: mediaUrlList[0], onTapRemoveMediaFile:onTapRemoveMediaFile,index:0
              ),
            ),
          ),
          10.w,
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: PageMediaFileView(
                isClipRect: true,
                mediaUrl: mediaUrlList[1], onTapRemoveMediaFile: onTapRemoveMediaFile,index:1
              ),
            ),
          ),
          10.w,
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PageMediaFileView(
                isClipRect: true,
                mediaUrl: mediaUrlList[2], onTapRemoveMediaFile: onTapRemoveMediaFile,index:2
              ),
            ),
          ),
          10.w,
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: PageMediaFileView(
                isClipRect: true,
                mediaUrl: mediaUrlList[3], onTapRemoveMediaFile: onTapRemoveMediaFile,index:3
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ColumnMoreMediaLayout extends StatelessWidget {
  const ColumnMoreMediaLayout({super.key, required this.mediaUrlList, required this.onTapRemoveMediaFile, required this.index});
  final List<String> mediaUrlList;
  final VoidCallback onTapRemoveMediaFile;
  final int index;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      width: Get.width,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PageMediaFileView(
                isClipRect: true,
                mediaUrl: mediaUrlList[0], onTapRemoveMediaFile:onTapRemoveMediaFile,index:0
              ),
            ),
          ),
          10.w,
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: PageMediaFileView(
                isClipRect: true,
                mediaUrl: mediaUrlList[1], onTapRemoveMediaFile:onTapRemoveMediaFile,index:1
              ),
            ),
          ),
          10.w,
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PageMediaFileView(
                isClipRect: true,
                mediaUrl: mediaUrlList[2], onTapRemoveMediaFile: onTapRemoveMediaFile,index:2
              ),
            ),
          ),
          10.w,
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: PageMoreMeidaCoutHover(
                moreCount: mediaUrlList.length - 4,
                child: PageMediaFileView(
                  isClipRect: true,
                  mediaUrl: mediaUrlList[4], onTapRemoveMediaFile: onTapRemoveMediaFile,index:4
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
