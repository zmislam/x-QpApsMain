import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../extension/string/string_image_path.dart';
import '../../../../config/constants/app_assets.dart';
import '../../../../config/constants/color.dart';
import '../../../../routes/app_pages.dart';
import '../../user_menu/sub_menus/all_pages/pages/model/allpages_model.dart';

class SuggestedPagesWidget extends StatelessWidget {
  final AllPagesModel pageModel;
  final Function onFollowClick;

  const SuggestedPagesWidget({super.key, required this.pageModel, required this.onFollowClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: InkWell(
        onTap: () {
          Get.toNamed(
            Routes.PAGE_PROFILE,
            arguments: pageModel.pageUserName,
          );
        },
        child: Card(
          color: Theme.of(context).cardTheme.color,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  clipBehavior: Clip.hardEdge,
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                    errorBuilder: (context, error, stackTrace) {
                      return const Image(
                        height: 120,
                        width: 200,
                        fit: BoxFit.cover,
                        image: AssetImage(AppAssets.DEFAULT_IMAGE),
                      );
                    },
                    height: 120,
                    width: 200,
                    fit: BoxFit.cover,
                    image: NetworkImage(('${pageModel.coverPic}').formatedProfileUrl),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  pageModel.pageName ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 200,
                  child: Text(
                    (pageModel.category as List<String>?)?.join('') ?? '',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 5),
                Text('${pageModel.followerCount}-people follow'.tr,
                ),
                const SizedBox(height: 10),
                Container(
                  height: 35,
                  width: 200,
                  decoration: BoxDecoration(
                    color: PRIMARY_COLOR,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: () {
                      onFollowClick();
                      // controller
                      //     .followPage(pageModel.id ?? '');
                    },
                    child: Text('Follow'.tr,
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                // const SizedBox(
                //   height: 10,
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
