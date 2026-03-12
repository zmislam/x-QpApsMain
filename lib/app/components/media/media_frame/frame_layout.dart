import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../extension/num.dart';

import 'media_file_view.dart';

class FrameLayout extends StatelessWidget {
  const FrameLayout({
    Key? key,
    required this.mediaUrlList,
    required this.onTap, // Add the onTap callback here
  }) : super(key: key);

  final List<String> mediaUrlList;
  final Function(int) onTap; // Function to handle the tapped index

  @override
  Widget build(BuildContext context) {
    switch (mediaUrlList.length) {
      case 2:
        return FrameTwoMediaLayout(mediaUrlList: mediaUrlList, onTap: onTap);
      case 3:
        return FrameThreeMediaLayout(mediaUrlList: mediaUrlList, onTap: onTap);
      case 4:
        return FrameFourMediaLayout(mediaUrlList: mediaUrlList, onTap: onTap);
      case 5:
        return FrameFiveMediaLayout(mediaUrlList: mediaUrlList, onTap: onTap);
      default:
        return FrameMoreMediaLayout(mediaUrlList: mediaUrlList, onTap: onTap);
    }
  }
}

class FrameTwoMediaLayout extends StatelessWidget {
  const FrameTwoMediaLayout({
    super.key,
    required this.mediaUrlList,
    required this.onTap,
  });
  final List<String> mediaUrlList;
  final Function(int) onTap;

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

class FrameThreeMediaLayout extends StatelessWidget {
  const FrameThreeMediaLayout({
    super.key,
    required this.mediaUrlList,
    required this.onTap,
  });
  final List<String> mediaUrlList;
  final Function(int) onTap;

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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FrameFourMediaLayout extends StatelessWidget {
  const FrameFourMediaLayout({
    super.key,
    required this.mediaUrlList,
    required this.onTap,
  });
  final List<String> mediaUrlList;
  final Function(int) onTap;

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
                    child: InkWell(
                      onTap: () => onTap(0), // Trigger onTap with index 0
                      child: MediaFileView(
                        mediaUrl: mediaUrlList[0],
                      ),
                    ),
                  ),
                  10.h,
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
          ),
        ],
      ),
    );
  }
}

class FrameFiveMediaLayout extends StatelessWidget {
  const FrameFiveMediaLayout({
    super.key,
    required this.mediaUrlList,
    required this.onTap,
  });
  final List<String> mediaUrlList;
  final Function(int) onTap;

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
                    child: InkWell(
                      onTap: () => onTap(0), // Trigger onTap with index 0
                      child: MediaFileView(
                        mediaUrl: mediaUrlList[0],
                      ),
                    ),
                  ),
                  10.h,
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
                    child: InkWell(
                      onTap: () => onTap(3), // Trigger onTap with index 3
                      child: MediaFileView(
                        mediaUrl: mediaUrlList[3],
                      ),
                    ),
                  ),
                  10.h,
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () => onTap(4), // Trigger onTap with index 4
                      child: MediaFileView(
                        mediaUrl: mediaUrlList[4],
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

class FrameMoreMediaLayout extends StatelessWidget {
  const FrameMoreMediaLayout({
    super.key,
    required this.mediaUrlList,
    required this.onTap,
  });
  final List<String> mediaUrlList;
  final Function(int) onTap;

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
                    child: InkWell(
                      onTap: () => onTap(0), // Trigger onTap with index 0
                      child: MediaFileView(
                        mediaUrl: mediaUrlList[0],
                      ),
                    ),
                  ),
                  10.h,
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
                  10.h,
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () => onTap(4), // Trigger onTap with index 4
                      child: MediaFileView(
                        mediaUrl: mediaUrlList[4],
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
