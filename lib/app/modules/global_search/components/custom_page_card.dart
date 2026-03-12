import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../extension/string/string_image_path.dart';
import '../../../config/constants/app_assets.dart';
import '../../../config/constants/color.dart';
import '../../../routes/app_pages.dart';

class CustomPageCard extends StatelessWidget {
  final String coverPicUrl;
  final String pageName;
  final String bio;
  final String pageUserName;
  final String defaultImage;

  const CustomPageCard({
    Key? key,
    required this.coverPicUrl,
    required this.pageName,
    required this.bio,
    required this.pageUserName,
    this.defaultImage = AppAssets.DEFAULT_IMAGE,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.PAGE_PROFILE, arguments: {
          'pageUserName': pageUserName,
          'isFromPageReels': 'false'
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Cover Image
            Expanded(
              child: Image(
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    defaultImage,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                },
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                image: NetworkImage((coverPicUrl).formatedProfileUrl),
              ),
            ),
            const SizedBox(
              height: 5,
            ),

            // Page Name
            Text(
              pageName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 5,
            ),

            // Page Bio
            Text(
              bio,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 10,
            ),

            // View Page Button
            Container(
              height: 35,
              width: double.infinity,
              decoration: BoxDecoration(
                color: PRIMARY_COLOR,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  Get.toNamed(Routes.PAGE_PROFILE, arguments: pageUserName);
                },
                child: Text('View Page'.tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
