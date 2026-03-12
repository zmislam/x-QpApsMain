import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'group_banner_layout.dart';
import 'group_classic_layout.dart';
import 'group_column_layout.dart';
import 'group_frame_layout.dart';
import '../../../../../components/image.dart';
import '../controller/create_group_post_controller.dart';



class PagePrimaryFileMediaComponent extends StatelessWidget {
  const PagePrimaryFileMediaComponent({
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
          return GroupClassicLayout(
              mediaUrlList: mediaUrlList,
              onTapRemoveMediaFile: onTapRemoveMediaFile,
              index: index??0);
        case 'columns':
          return GroupColumnLayout(
              mediaUrlList: mediaUrlList,
               onTapRemoveMediaFile: onTapRemoveMediaFile,
              index: index??0);
        case 'banner':
          return GroupBannerLayout(
              mediaUrlList: mediaUrlList,
              onTapRemoveMediaFile: onTapRemoveMediaFile,
              index: index??0);
        case 'frame':
          return GroupFrameLayout(
              mediaUrlList: mediaUrlList,
              onTapRemoveMediaFile: onTapRemoveMediaFile,
              index: index??0);
        default:
          return GroupClassicLayout(
            mediaUrlList: mediaUrlList,
                          onTapRemoveMediaFile: onTapRemoveMediaFile,

            index: index??0,
          );
      }
    } else {
      CreateGroupPostController controller =Get.find();
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
