import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'more_media_count_hover.dart';
import '../../../extension/num.dart';

import 'media_file_view.dart';

class BannerLayout extends StatelessWidget {
  const BannerLayout({
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
        return BannerTwoMediaLayout(mediaUrlList: mediaUrlList, onTap: onTap);
      case 3:
        return BannerThreeMediaLayout(mediaUrlList: mediaUrlList, onTap: onTap);
      case 4:
        return BannerFourMediaLayout(mediaUrlList: mediaUrlList, onTap: onTap);
      default:
        return BannerMoreMediaLayout(mediaUrlList: mediaUrlList, onTap: onTap);
    }
  }
}

class BannerTwoMediaLayout extends StatelessWidget {
  const BannerTwoMediaLayout(
      {super.key, required this.mediaUrlList, required this.onTap});
  final List<String> mediaUrlList;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: Get.width,
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
    );
  }
}

class BannerThreeMediaLayout extends StatelessWidget {
  const BannerThreeMediaLayout(
      {super.key, required this.mediaUrlList, required this.onTap});
  final List<String> mediaUrlList;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
          ),
        ],
      ),
    );
  }
}

class BannerFourMediaLayout extends StatelessWidget {
  const BannerFourMediaLayout(
      {super.key, required this.mediaUrlList, required this.onTap});
  final List<String> mediaUrlList;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  10.w,
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

class BannerMoreMediaLayout extends StatelessWidget {
  const BannerMoreMediaLayout(
      {super.key, required this.mediaUrlList, required this.onTap});
  final List<String> mediaUrlList;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  10.w,
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
          ),
        ],
      ),
    );
  }
}
