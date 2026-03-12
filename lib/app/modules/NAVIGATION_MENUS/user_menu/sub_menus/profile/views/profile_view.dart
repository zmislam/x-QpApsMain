import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../extension/string/string_image_path.dart';
import '../controllers/monitizationController.dart';
import 'components/profile_all_reels_component.dart';
import 'components/showMonitizationModel.dart';
import 'components/showVerificationModal.dart';
import 'components/stories.dart';
import 'components/feed.dart';
import 'components/photos.dart';
import '../../../../../../components/simmar_loader.dart';
import '../../../../../../data/login_creadential.dart';
import '../../../../../../components/profile_tile.dart';
import '../../../../../../components/profile_view_banner_image.dart';
import '../../../../../../config/constants/app_assets.dart';
import '../../../../../../routes/app_pages.dart';
import '../../../../../../config/constants/color.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ============================ new code in profile ========================
    return SafeArea(
      top: true,
      child: Scaffold(
        // ========================= body section ==============================
        body: RefreshIndicator(
          backgroundColor: Theme.of(context).cardTheme.color,
          color: PRIMARY_COLOR,
          onRefresh: () async {
            controller.getUserData();
            controller.pinnedPostList.value.clear();
            controller.pinnedPostList.refresh();
            controller.postList.value.clear();
            controller.postList.refresh();
            controller.pageNo = 1;
            controller.totalPageCount = 0;
            controller.getPosts();
          },
          child: CustomScrollView(
            controller: controller.postScrollController,
            slivers: [
              // ========================== profile view banner image section ================
              SliverToBoxAdapter(
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      PrifileViewBannerImage(
                        profileImageUpload: () async {
                          await controller.uploadUserProfilePicture();
                          controller.profileModel.refresh();
                          controller.getUserData();
                        },
                        coverImageUpload: () async {
                          await controller.uploadUserCoverPicture();
                          controller.profileModel.refresh();
                          controller.getUserData();
                        },
                        banner: controller.profileModel.value?.cover_pic != null
                            ? ('${controller.profileModel.value?.cover_pic}')
                                .formatedProfileUrl
                            : AppAssets.DEFAULT_CIRCLE_PROFILE_IMAGE,
                        profilePic: controller
                                    .profileModel.value?.profile_pic !=
                                null
                            ? ('${controller.profileModel.value?.profile_pic}')
                                .formatedProfileUrl
                            : AppAssets.DEFAULT_CIRCLE_PROFILE_IMAGE,
                        enableImageUpload: true,
                        removeCoverPhoto: () {
                          controller.removeCoverPhoto();
                        },
                        removeProfilePhoto: () {
                          controller.removeProfilePhoto();
                        },
                      ),
                      const SizedBox(height: 8),
                      // ======================= user info section =============
                      Obx(() {
                        final profile = controller.profileModel.value;
                        return Column(
                          children: [
                            GestureDetector(
                              onTap:() async{
                                final response = await controller
                                    .createPaymentIntent();
                                debugPrint(
                                    'Backend Response: $response');
                                debugPrint(
                                    'Client Secret: ${controller.clientSecretKey.value}');
                                debugPrint(
                                    'Has _secret_: ${controller.clientSecretKey.value.contains('_secret_')}');
                                if (controller.clientSecretKey
                                    .value.isNotEmpty) {
                                  showVerificationModal(
                                      Get.context!, profile!);
                              }},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${profile?.first_name ?? ''} ${profile?.last_name ?? ''}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),

                                  // 🟦 Show verified badge if profile is verified
                                  if (profile?.isProfileVerified == true) ...[
                                    const SizedBox(width: 6),
                                    const Icon(
                                      Icons.verified, // Material verified icon
                                      color: Color(
                                          0xFF0D7377), // same as your app theme color
                                      size: 22,
                                    ),
                                  ],

                                  const SizedBox(width: 8),

                                  controller.isLoading.value
                                      ? const SizedBox.shrink()
                                      : PopupMenuButton<String>(
                                          icon: const Icon(Icons.menu,
                                              color: Colors.black),
                                          color: Colors.white,
                                          offset: const Offset(150, 50),
                                          onSelected: (String value) async {
                                            if (value == 'monetization') {
                                              showMonetizationModal(context);
                                            } else if (value ==
                                                'turnOffEarning') {
                                              final monitizationController = Get
                                                      .isRegistered<
                                                          MonetizationController>()
                                                  ? Get.find<
                                                      MonetizationController>()
                                                  : Get.put(
                                                      MonetizationController());
                                              await monitizationController
                                                  .disableMonetization();
                                            } else if (value == 'verify') {
                                              if (profile != null) {
                                                final response = await controller
                                                    .createPaymentIntent();
                                                debugPrint(
                                                    'Backend Response: $response');
                                                debugPrint(
                                                    'Client Secret: ${controller.clientSecretKey.value}');
                                                debugPrint(
                                                    'Has _secret_: ${controller.clientSecretKey.value.contains('_secret_')}');
                                                if (controller.clientSecretKey
                                                    .value.isNotEmpty) {
                                                  showVerificationModal(
                                                      Get.context!, profile);
                                                } else {
                                                  Get.snackbar(
                                                    'Payment Error',
                                                    'Unable to initialize payment session. Please try again.',
                                                    snackPosition:
                                                        SnackPosition.BOTTOM,
                                                    backgroundColor: Colors.red,
                                                    colorText: Colors.white,
                                                  );
                                                }
                                              }
                                            }
                                          },
                                          itemBuilder: (BuildContext context) {
                                            final items =
                                                <PopupMenuEntry<String>>[];

                                            final monetization = profile
                                                    ?.monetization
                                                    ?.toLowerCase() ??
                                                '';
                                            final isEarningDashboardOn =
                                                (monetization == 'pending' ||
                                                    monetization == 'approved');
                                            final isApproved =
                                                monetization == 'approved';
                                            final isVerified =
                                                profile?.isProfileVerified ??
                                                    false;

                                            if (!isEarningDashboardOn) {
                                              items.add(
                                                 PopupMenuItem<String>(
                                                  value: 'monetization',
                                                  child: Text('Turn on Monetization'.tr),
                                                ),
                                              );
                                            }

                                            if (isApproved) {
                                              items.add(
                                                 PopupMenuItem<String>(
                                                  value: 'turnOffEarning',
                                                  child: Text('Turn off Earning Mode'.tr),
                                                ),
                                              );
                                            }

                                            if (!isVerified) {
                                              items.add(
                                                 PopupMenuItem<String>(
                                                  value: 'verify',
                                                  child: Text('Verify Now'.tr),
                                                ),
                                              );
                                            }

                                            return items;
                                          },
                                        ),
                                ],
                              ),
                            ),
                            Obx(() {
                              final profile = controller.profileModel.value;
                              if (profile == null) {
                                return const SizedBox.shrink();
                              }
                              final isApproved =
                                  (profile.monetization?.toLowerCase() ==
                                      'approved');
                              return isApproved
                                  ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF0D7377),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        elevation: 4,
                                      ),
                                      onPressed: () {
                                        Get.toNamed(Routes.EARN_DASHBOARD);
                                      },
                                      child: Text(
                                        'Earning Dashboard'.tr,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink();
                            }),
                          ],
                        );
                      }),
                      const SizedBox(height: 8),
                      // ======================= user bio section ==============
                      InkWell(
                        onTap: () async {
                          Get.bottomSheet(await showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Get.back();
                                          Get.toNamed(Routes.ADD_BIO,
                                              arguments: {
                                                'bio': controller.profileModel
                                                        .value?.user_bio ??
                                                    '',
                                              });
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.edit,
                                              color: PRIMARY_COLOR,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('Edit Bio'.tr,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                        child: Divider(),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          controller
                                              .onTapEditBioPatch(); // remove bio with empty text
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.delete,
                                              color: PRIMARY_COLOR,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('Remove Bio'.tr,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }));
                        },
                        child: Visibility(
                          visible: controller.profileModel.value?.user_bio != ''
                              ? true
                              : false,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    controller.profileModel.value?.user_bio ??
                                        '',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24)
                    ],
                  ),
                ),
              ),
              // =========================== user other info section ===================================
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ======================== workspace ======================
                    Obx(
                      () => (controller.profileModel.value?.userWorkplaces
                                  ?.isNotEmpty ??
                              false)
                          ? ProfileTile(
                              company: controller.profileModel.value
                                      ?.userWorkplaces?.first.org_name ??
                                  '',
                              designation:
                                  '${controller.profileModel.value?.userWorkplaces?.first.designation ?? 'Work'} at ',
                              //'Founder and CEO at ',
                              icon: const Image(
                                height: 25,
                                width: 25,
                                image: AssetImage(
                                  AppAssets.WORK_ICON,
                                ),
                              ),
                            )
                          : Container(),
                    ),
                    // ======================== education ======================
                    Obx(
                      () => (controller.profileModel.value?.educationWorkplaces
                                  ?.isNotEmpty ??
                              false)
                          ? ProfileTile(
                              company: controller
                                      .profileModel
                                      .value
                                      ?.educationWorkplaces
                                      ?.first
                                      .institute_name ??
                                  '',
                              designation:
                                  '${controller.profileModel.value?.educationWorkplaces?.first.designation ?? 'Studied'} at ',
                              //'Founder and CEO at ',
                              icon: const Image(
                                height: 30,
                                width: 30,
                                image: AssetImage(AppAssets.SCHOOL_ICON),
                              ))
                          : Container(),
                    ),
                    // ===================== present town ======================
                    Obx(
                      () => Visibility(
                        visible:
                            controller.profileModel.value?.present_town != null
                                ? true
                                : false,
                        child: ProfileTile(
                          company:
                              '${controller.profileModel.value?.present_town}',
                          designation: 'Lives in ',
                          icon: const Image(
                            height: 30,
                            width: 30,
                            image: AssetImage(AppAssets.HOME_ICON),
                          ),
                        ),
                      ),
                    ),
                    // ======================== home town ======================
                    Obx(
                      () => Visibility(
                        visible:
                            controller.profileModel.value?.home_town != null
                                ? true
                                : false,
                        child: ProfileTile(
                          company:
                              '${controller.profileModel.value?.home_town}',
                          designation: controller.userModel.home_town == null
                              ? ''
                              : 'From ',
                          icon: const Image(
                            height: 30,
                            width: 30,
                            image: AssetImage(AppAssets.LOCATION_ICON),
                          ),
                        ),
                      ),
                    ),
                    // ===================== about info ========================
                    Obx(() => controller.profileModel.value != null
                        ? InkWell(
                            child:  ProfileTile(
                              company: '',
                              designation: 'See your about info.'.tr,
                              icon: Icon(Icons.more_horiz),
                            ),
                            onTap: () {
                              Get.toNamed(Routes.ABOUT);
                            },
                          )
                        : Container()),
                    const Divider(),
                  ],
                ),
              ),
              // ========================== tab bar ============================
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 7,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            controller.viewNumber.value = 0;
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Obx(() => Text('Your Feed'.tr,
                                  style: TextStyle(
                                    color: controller.viewNumber.value == 0
                                        ? PRIMARY_COLOR
                                        : null,
                                  ),
                                )),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            controller.viewNumber.value = 1;
                            await controller.getPhotos();
                            await controller.getAlbums();
                            await controller.getProfilePictures();
                            await controller.getVideos();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Obx(
                              () => Text('Photos'.tr,
                                style: TextStyle(
                                  color: controller.viewNumber.value == 1
                                      ? PRIMARY_COLOR
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            controller.viewNumber.value = 2;
                            await controller.getStories();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Obx(
                              () => Text('Stories'.tr,
                                style: TextStyle(
                                  color: controller.viewNumber.value == 2
                                      ? PRIMARY_COLOR
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            controller.viewNumber.value = 3;
                            controller.viewReelsTabNumber.value = 0;
                            controller.getPersonalReels();
                            // controlle
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Obx(
                              () => Text('Reels'.tr,
                                style: TextStyle(
                                  color: controller.viewNumber.value == 3
                                      ? PRIMARY_COLOR
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.toNamed(Routes.MY_PROFILE_FRIENDS,
                                arguments:
                                    '${LoginCredential().getUserData().username}');
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Text('Friends'.tr,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider()
                  ],
                ),
              ),
              // ========================== widget list ========================
              Obx(() {
                if (controller.viewNumber.value == 0) {
                  // ====================== feed component =====================
                  return FeedComponent(controller: controller);
                } else if (controller.viewNumber.value == 1) {
                  // ====================== photos component ===================
                  return PhotosComponent(controller: controller);
                } else if (controller.viewNumber.value == 2) {
                  // ====================== stories component ==================
                  return StoriesComponent(controller: controller);
                } else if (controller.viewNumber.value == 3) {
                  // ====================== reels component ====================
                  return ProfileReelsComponent(controller: controller);
                }
                return const SliverToBoxAdapter();
              })
            ],
          ),
        ),
      ),
    );
  }

  // ============================== loading view ===============================
  Widget ShimmarLoadingView() {
    return SizedBox(
      height: Get.height,
      child: GridView.builder(
          physics: const ScrollPhysics(),
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
