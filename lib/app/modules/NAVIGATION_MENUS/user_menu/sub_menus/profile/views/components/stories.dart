import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../components/shimmer_loaders/photo_type/sliver_photo_shimmer.dart';
import '../../../../../../../components/simmar_loader.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../components/my_day_detail.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../data/login_creadential.dart';
import '../../../../../../../utils/post_utlis.dart';
import '../../controllers/profile_controller.dart';

class StoriesComponent extends StatelessWidget {
  const StoriesComponent({super.key, required this.controller});

  final ProfileController controller;
  @override
  Widget build(BuildContext context) {
    // controller.getStories();
    return Obx(
      () => controller.isLoadingUserStory.value
          ? const PhotoTypeSliverShimmerLoadingView(
              childCount: 9,
              crossAxisCount: 3,
              childAspectRatio: 0.8,
            )
          : controller.storyList.value.isEmpty
              ? SliverToBoxAdapter(
                  child: Center(
                    child: Text('You have no posted stories'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              : SliverGrid.builder(
                  itemCount: controller.storyList.value.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 3,
                      crossAxisSpacing: 3,
                      crossAxisCount: 3,
                      childAspectRatio: 0.7),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Get.to(
                          MyDayDetail(
                            imageURL:
                                ('${controller.storyList.value[index].media}')
                                    .formatedStoryUrl,
                            profileImage:
                                ('${LoginCredential().getUserData().profile_pic}')
                                    .formatedProfileUrl,
                            userName:
                                '${LoginCredential().getUserData().first_name} ${LoginCredential().getUserData().last_name}',
                            createdAt: getDynamicFormatedCommentTime(
                                '${controller.storyList.value[index].createdAt}'),
                            title:
                                ('${controller.storyList.value[index].title}')
                                    .formatedStoryUrl,
                            id: '${controller.storyList.value[index].id}',
                            isProfile: true,
                            viewCont:
                                '${controller.storyList.value[index].viewersCount}',
                          ),
                        );

                        // Get.to(SingleImage(imgURL: '${getFormatedPostUrl('${controller.photoList.value[index].media}')}',));
                      },
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: FadeInImage(
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return const Image(
                                    height: 400,
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      AppAssets.DEFAULT_IMAGE,
                                    ),
                                  );
                                },
                                width: Get.width / 3,
                                height: 157,
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    ('${controller.storyList.value[index].media}')
                                        .formatedStoryUrl),
                                placeholder: const AssetImage(
                                    'assets/image/default_image.png'),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            left: 6,
                            child: SizedBox(
                              width: 60,
                              child: Text(
                                getDynamicFormatedCommentTime(
                                    '${controller.storyList.value[index].createdAt}'),
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  Widget ShimmarLoadingView() {
    return SizedBox(
      height: Get.height,
      child: GridView.builder(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: 12,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, childAspectRatio: 0.7),
          itemBuilder: (BuildContext context, index) {
            return ShimmerLoader(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: Get.width / 3,
                    height: 157,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.withValues(alpha: 0.9)),
                  )),
            );
          }),
    );
  }
}
