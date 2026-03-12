import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../components/simmar_loader.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../controllers/page_profile_controller.dart';
import '../../../../../../../components/single_image.dart';
import '../../admin_page/model/page_profile_picture_model.dart';

class CoverPhotosView extends StatelessWidget {
  const CoverPhotosView({
    super.key,
    required this.controller,
    // required this.userNAme,
  });
  final PageProfileController controller;
  // final String userNAme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.white,
        appBar: AppBar(
          // backgroundColor: Colors.white,
          leading: const BackButton(
            color: Colors.black,
          ),
          title: const Text(
            textAlign: TextAlign.center,
            'Cover Photos',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Obx(
                  () => controller.isLoadingProfilePhoto.value == true
                      ? ShimmarLoadingView()
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 0.7,
                                  crossAxisSpacing: 0.7),
                          itemCount: controller.coverPhotosList.value.length,
                          itemBuilder: (context, index) {
                            AdminPageProfilePictureModel
                                adminPageProfilePictureModel =
                                controller.coverPhotosList.value[index];

                            return Stack(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.to(SingleImage(
                                      imgURL:
                                          ('${adminPageProfilePictureModel.media}')
                                              .formatedPostUrl,
                                    ));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: FadeInImage(
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        return const Image(
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                            AppAssets.DEFAULT_IMAGE,
                                          ),
                                        );
                                      },
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          ('${controller.coverPhotosList.value[index].media}')
                                              .formatedPostUrl),
                                      placeholder: const AssetImage(
                                          'assets/image/default_image.png'),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                ),
              )
            ],
          ),
        )));
  }
}

Widget ShimmarLoadingView() {
  return SizedBox(
    height: Get.height,
    child: GridView.builder(
        physics: const ScrollPhysics(),
        itemCount: 18,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (BuildContext context, index) {
          return ShimmerLoader(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withValues(alpha: 0.9)),
                )),
          );
        }),
  );
}
