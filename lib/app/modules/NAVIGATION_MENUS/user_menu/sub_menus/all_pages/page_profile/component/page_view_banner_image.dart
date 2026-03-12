import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../components/single_image.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../controllers/page_profile_controller.dart';

class PageViewBannerImage extends StatelessWidget {
  final String banner;
  final String profilePic;

  final bool enableImageUpload;

  const PageViewBannerImage({
    super.key,
    required this.banner,
    required this.profilePic,
    required this.enableImageUpload,
  });

  @override
  Widget build(BuildContext context) {
    final PageProfileController pageProfileController =
        Get.put(PageProfileController());

    return SizedBox(
      height: 305,
      child: Stack(
        children: [
          Positioned(
            child: InkWell(
              onTap: () {
                Get.to(SingleImage(
                    imgURL: (pageProfileController.pageProfileModel.value
                                ?.pageDetails?.coverPic ??
                            '')
                        .formatedProfileUrl));
              },
              child: Image.network(
                banner,
                width: Get.width,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Image(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      AppAssets.DEFAULT_IMAGE,
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 30,
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            left: 15,
            bottom: 0,
            child: Stack(
              children: [
                // CircleAvatar(
                //   radius: 30,
                //   child: Container(
                //     height: 156,
                //     width: 156,
                //     color: Colors.black,
                //   ),
                // ),
                Container(
                    height: 156,
                    width: 156,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            profilePic,
                          ),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          width: 4,
                        )),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: InkWell(
                        onTap: () {
                          Get.to(SingleImage(
                              imgURL: (pageProfileController.pageProfileModel
                                          .value?.pageDetails?.profilePic ??
                                      '')
                                  .formatedProfileUrl));
                        },
                        child: Image(
                          width: double.maxFinite,
                          height: 256,
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            profilePic,
                          ),
                          errorBuilder: (context, error, stackTrace) {
                            return const Image(
                              image: AssetImage(AppAssets.DEFAULT_IMAGE),
                            );
                          },
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
