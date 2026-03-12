import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../image.dart';

import 'banner_layout.dart';
import 'classic_layout.dart';
import 'column_layout.dart';
import 'frame_layout.dart';


class PrimaryRemoteMediaComponent extends StatelessWidget {
  const PrimaryRemoteMediaComponent({
    Key? key,
    required this.mediaUrlList,
    required this.mediaLayout,
    required this.onTapIndex, 
  }) : super(key: key);

  final List<String> mediaUrlList;
  final String mediaLayout;
  final Function(int) onTapIndex;

  @override
  Widget build(BuildContext context) {
    if (mediaUrlList.length > 1) {
      switch (mediaLayout) {
        case 'classic':
          return ClassicLayout(mediaUrlList: mediaUrlList, onTap: onTapIndex);
        case 'columns':
          return ColumnLayout(mediaUrlList: mediaUrlList, onTap: onTapIndex);
        case 'banner':
          return BannerLayout(mediaUrlList: mediaUrlList, onTap: onTapIndex);
        case 'frame':
          return FrameLayout(mediaUrlList: mediaUrlList, onTap: onTapIndex);
        default:
          return ClassicLayout(mediaUrlList: mediaUrlList, onTap: onTapIndex);
      }
    } else {
      return GestureDetector(
        onTap: () => onTapIndex(0), 
        child: PrimaryNetworkImage(
          fitImage: BoxFit.cover,
          height: 256,
          width: Get.width,
          imageUrl: mediaUrlList[0],
        ),
      );
    }
  }
}
