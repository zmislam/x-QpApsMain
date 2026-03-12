import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../components/image.dart';

import '../../controller/create_post_controller.dart';
import 'banner_layout.dart';
import 'classic_layout.dart';
import 'column_layout.dart';
import 'frame_layout.dart';

class PrimaryFileMediaComponent extends StatelessWidget {
  const PrimaryFileMediaComponent({
    Key? key,
    required this.mediaUrlList,
    required this.mediaLayout,
    required this.onTapRemoveMediaFile,
     this.index,
  }) : super(key: key);

  final List<String> mediaUrlList;
  final VoidCallback onTapRemoveMediaFile;
  final String mediaLayout;
  final int? index;

  @override
  Widget build(BuildContext context) {
    if (mediaUrlList.length > 1) {
      switch (mediaLayout) {
        case 'classic':
          return ClassicLayout(
              mediaUrlList: mediaUrlList,
              onTapRemoveMediaFile: onTapRemoveMediaFile,
              index: index??0);
        case 'columns':
          return ColumnLayout(
              mediaUrlList: mediaUrlList,
               onTapRemoveMediaFile: onTapRemoveMediaFile,
              index: index??0);
        case 'banner':
          return BannerLayout(
              mediaUrlList: mediaUrlList,
              onTapRemoveMediaFile: onTapRemoveMediaFile,
              index: index??0);
        case 'frame':
          return FrameLayout(
              mediaUrlList: mediaUrlList,
              onTapRemoveMediaFile: onTapRemoveMediaFile,
              index: index??0);
        default:
          return ClassicLayout(
            mediaUrlList: mediaUrlList,
                          onTapRemoveMediaFile: onTapRemoveMediaFile,

            index: index??0,
          );
      }
    } else {
      CreatePostController controller =Get.find();
      return Stack(
        children: [
          PrimaryFileImage(
            fitImage: BoxFit.cover,
            height: 256,
            width: Get.width,
            filePath: mediaUrlList[0],
          ),
          Positioned(
            top: 5,
            right: 10,
            child: InkWell(
              onTap: () {
                if ((index??0) >= 0 && (index??0) < controller.xfiles.value.length) {
                  controller.xfiles.update((val) {
                    val?.removeAt((index??0));
                  });
                }
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
