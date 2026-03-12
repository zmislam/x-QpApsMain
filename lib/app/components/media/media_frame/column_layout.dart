import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'more_media_count_hover.dart';
import '../../../extension/num.dart';
import 'media_file_view.dart';

class ColumnLayout extends StatelessWidget {
  const ColumnLayout({
    Key? key,
    required this.mediaUrlList,
    required this.onTap, // Add the onTap callback
  }) : super(key: key);

  final List<String> mediaUrlList;
  final Function(int) onTap; // Function to handle the tapped index

  @override
  Widget build(BuildContext context) {
    switch (mediaUrlList.length) {
      case 2:
        return ColumnTwoMediaLayout(mediaUrlList: mediaUrlList, onTap: onTap);
      case 3:
        return ColumnThreeMediaLayout(mediaUrlList: mediaUrlList, onTap: onTap);
      case 4:
        return ColumnFourMediaLayout(mediaUrlList: mediaUrlList, onTap: onTap);
      default:
        return ColumnMoreMediaLayout(mediaUrlList: mediaUrlList, onTap: onTap);
    }
  }
}

class ColumnTwoMediaLayout extends StatelessWidget {
  const ColumnTwoMediaLayout(
      {super.key, required this.mediaUrlList, required this.onTap});
  final List<String> mediaUrlList;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      width: Get.width,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () => onTap(0), // Trigger onTap with index 0
              child: MediaFileView(
                mediaUrl: mediaUrlList[0],
              ),
            ),
          ),
          10.w,
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () => onTap(1), // Trigger onTap with index 1
              child: MediaFileView(
                mediaUrl: mediaUrlList[1],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ColumnThreeMediaLayout extends StatelessWidget {
  const ColumnThreeMediaLayout(
      {super.key, required this.mediaUrlList, required this.onTap});
  final List<String> mediaUrlList;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      width: Get.width,
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: NetworkImage(mediaUrlList[0]),
      //     fit: BoxFit.cover,
      //     opacity: 0.5,
      //   ),
      // ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () => onTap(0), // Trigger onTap with index 0
                child: MediaFileView(
                  isClipRect: true,
                  mediaUrl: mediaUrlList[0],
                ),
              ),
            ),
          ),
          10.w,
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: InkWell(
                onTap: () => onTap(1), // Trigger onTap with index 1
                child: MediaFileView(
                  isClipRect: true,
                  mediaUrl: mediaUrlList[1],
                ),
              ),
            ),
          ),
          10.w,
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () => onTap(2), // Trigger onTap with index 2
                child: MediaFileView(
                  isClipRect: true,
                  mediaUrl: mediaUrlList[2],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ColumnFourMediaLayout extends StatelessWidget {
  const ColumnFourMediaLayout(
      {super.key, required this.mediaUrlList, required this.onTap});
  final List<String> mediaUrlList;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      width: Get.width,
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: NetworkImage(mediaUrlList[0]),
      //     fit: BoxFit.cover,
      //     opacity: 0.5,
      //   ),
      // ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () => onTap(0), // Trigger onTap with index 0
                child: MediaFileView(
                  isClipRect: true,
                  mediaUrl: mediaUrlList[0],
                ),
              ),
            ),
          ),
          10.w,
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: InkWell(
                onTap: () => onTap(1), // Trigger onTap with index 1
                child: MediaFileView(
                  isClipRect: true,
                  mediaUrl: mediaUrlList[1],
                ),
              ),
            ),
          ),
          10.w,
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () => onTap(2), // Trigger onTap with index 2
                child: MediaFileView(
                  isClipRect: true,
                  mediaUrl: mediaUrlList[2],
                ),
              ),
            ),
          ),
          10.w,
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: InkWell(
                onTap: () => onTap(3), // Trigger onTap with index 3
                child: MediaFileView(
                  isClipRect: true,
                  mediaUrl: mediaUrlList[3],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ColumnMoreMediaLayout extends StatelessWidget {
  const ColumnMoreMediaLayout(
      {super.key, required this.mediaUrlList, required this.onTap});
  final List<String> mediaUrlList;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      width: Get.width,
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: NetworkImage(mediaUrlList[0]),
      //     fit: BoxFit.cover,
      //     opacity: 0.5,
      //   ),
      // ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () => onTap(0), // Trigger onTap with index 0
                child: MediaFileView(
                  isClipRect: true,
                  mediaUrl: mediaUrlList[0],
                ),
              ),
            ),
          ),
          10.w,
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: InkWell(
                onTap: () => onTap(1), // Trigger onTap with index 1
                child: MediaFileView(
                  isClipRect: true,
                  mediaUrl: mediaUrlList[1],
                ),
              ),
            ),
          ),
          10.w,
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () => onTap(2), // Trigger onTap with index 2
                child: MediaFileView(
                  isClipRect: true,
                  mediaUrl: mediaUrlList[2],
                ),
              ),
            ),
          ),
          10.w,
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: InkWell(
                onTap: () => onTap(3), // Trigger onTap with index 3
                child: MoreMeidaCoutHover(
                  moreCount: mediaUrlList.length - 4,
                  child: MediaFileView(
                    isClipRect: true,
                    mediaUrl: mediaUrlList[3],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
