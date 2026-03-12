import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../../extension/string/string_image_path.dart';
import '../../../../config/constants/app_assets.dart';
import '../controllers/profile_image_silder_controller.dart';

class ProfileImageSilderView extends GetView<ProfileImageSilderController> {
  const ProfileImageSilderView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = Get.arguments;
    String type = data['type'] ?? '';
    if (type == 'coverPhotos') {
      controller.getCoverPhotos();
    } else {
      controller.getProfilePictures();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      body: Obx(() => Container(
            alignment: Alignment.center,
            child: PageView.builder(
                itemCount: (type == 'coverPhotos')
                    ? controller.coverPhotosList.value.length
                    : controller.profilePicturesList.value.length,
                itemBuilder: (context, index) {
                  String imageUrl = (type == 'coverPhotos')
                      ? controller.coverPhotosList.value[index].media ?? ''
                      : controller.profilePicturesList.value[index].media ?? '';

                  return Image(
                      errorBuilder: (context, error, stackTrace) {
                        return const Image(
                            image: AssetImage(AppAssets.DEFAULT_PROFILE_IMAGE));
                      },
                      image: NetworkImage((imageUrl).formatedProfileUrl));
                }),
          )),
    );
  }
}
