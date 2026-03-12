import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'more_media_count_hover.dart';
import '../../../extension/num.dart';

import 'media_file_view.dart';

class ClassicLayout extends StatelessWidget {
  const ClassicLayout({
    Key? key,
    required this.mediaUrlList,
    required this.onTap,
  }) : super(key: key);

  final List<String> mediaUrlList;
  final Function(int) onTap;
  @override
  Widget build(BuildContext context) {
    switch (mediaUrlList.length) {
      case 2:
        return ClassicTwoMediaLayout(
          mediaUrlList: mediaUrlList,
          onTap: onTap,
        );
      case 3:
        return ClassicThreeMediaLayout(
          mediaUrlList: mediaUrlList,
          onTap: onTap,
        );
      case 4:
        return ClassicFourMediaLayout(
          mediaUrlList: mediaUrlList,
          onTap: onTap,
        );
      default:
        return ClassicMoreMediaLayout(
          mediaUrlList: mediaUrlList,
          onTap: onTap,
        );
    }
  }
}

class ClassicTwoMediaLayout extends StatelessWidget {
  const ClassicTwoMediaLayout({
    Key? key,
    required this.mediaUrlList,
    required this.onTap, // Accept the onTap callback
  }) : super(key: key);

  final List<String> mediaUrlList;
  final Function(int) onTap; // Function to handle the tapped index

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (Get.width / 2) - 10,
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

class ClassicThreeMediaLayout extends StatelessWidget {
  const ClassicThreeMediaLayout({
    super.key,
    required this.mediaUrlList,
    required this.onTap, // Add the onTap callback
  });

  final List<String> mediaUrlList;
  final Function(int) onTap; // Function to handle the tapped index

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      width: Get.width,
      child: Column(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => onTap(0), // Trigger onTap with index 0
              child: MediaFileView(
                mediaUrl: mediaUrlList[0],
              ),
            ),
          ),
          10.h,
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () => onTap(1), // Trigger onTap with index 1
                    child: MediaFileView(
                      mediaUrl: mediaUrlList[1],
                    ),
                  ),
                ),
                10.w,
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () => onTap(2), // Trigger onTap with index 2
                    child: MediaFileView(
                      mediaUrl: mediaUrlList[2],
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

class ClassicFourMediaLayout extends StatelessWidget {
  const ClassicFourMediaLayout({
    super.key,
    required this.mediaUrlList,
    required this.onTap, // Add the onTap callback
  });

  final List<String> mediaUrlList;
  final Function(int) onTap; // Function to handle the tapped index

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      width: Get.width,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () => onTap(0), // Trigger onTap with index 0
              child: MediaFileView(
                mediaUrl: mediaUrlList[0],
              ),
            ),
          ),
          10.w,
          Expanded(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () => onTap(1), // Trigger onTap with index 1
                    child: MediaFileView(
                      mediaUrl: mediaUrlList[1],
                    ),
                  ),
                ),
                10.h,
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () => onTap(2), // Trigger onTap with index 2
                    child: MediaFileView(
                      mediaUrl: mediaUrlList[2],
                    ),
                  ),
                ),
                10.h,
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () => onTap(3), // Trigger onTap with index 3
                    child: MediaFileView(
                      mediaUrl: mediaUrlList[3],
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

class ClassicMoreMediaLayout extends StatelessWidget {
  const ClassicMoreMediaLayout({
    super.key,
    required this.mediaUrlList,
    required this.onTap, // Add the onTap callback
  });

  final List<String> mediaUrlList;
  final Function(int) onTap; // Function to handle the tapped index

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      width: Get.width,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () => onTap(0), // Trigger onTap with index 0
              child: MediaFileView(
                mediaUrl: mediaUrlList[0],
              ),
            ),
          ),
          10.w,
          Expanded(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () => onTap(1), // Trigger onTap with index 1
                    child: MediaFileView(
                      mediaUrl: mediaUrlList[1],
                    ),
                  ),
                ),
                10.h,
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () => onTap(2), // Trigger onTap with index 2
                    child: MediaFileView(
                      mediaUrl: mediaUrlList[2],
                    ),
                  ),
                ),
                10.h,
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () => onTap(3), // Trigger onTap with index 3
                    child: MoreMeidaCoutHover(
                      moreCount: mediaUrlList.length - 4,
                      child: MediaFileView(
                        mediaUrl: mediaUrlList[3],
                      ),
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
