import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/constants/qp_icons_icons.dart';
import '../../../../data/login_creadential.dart';
import '../../../../extension/num.dart';
import '../../../../extension/string/string_image_path.dart';
import '../../../tab_view/controllers/tab_view_controller.dart';

import '../../../../components/image.dart';
import '../../../../config/constants/app_assets.dart';
import '../../../../routes/app_pages.dart';
import '../../settings_privacy/views/settings_privacy_view.dart';
import '../components/user_property_card.dart';
import '../components/user_setting_card.dart';
import '../controllers/user_menu_controller.dart';
import '../sub_menus/all_pages/pages/controllers/pages_controller.dart';
import '../widget/change_to_original_profile.dart';
import '../widget/user_profile_change_button.dart';

class UserMenuView extends GetView<UserMenuController> {
  const UserMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = LoginCredential().getUserInfoData().isProfileVerified;
    return Scaffold(
        // =========================== body section ==============================
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //====================================================== Menu & Search Section ======================================================//

             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Shortcuts'.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                Icon(
                  Icons.search,
                  size: 30,
                )
              ],
            ),
            const SizedBox(height: 10),
            //====================================================== Profile Card ======================================================//
            InkWell(
              onTap: () async {
                if (controller.loginCredential.getProfileSwitch()) {
                  await Get.toNamed(Routes.ADMIN_PAGE,
                      arguments: controller.loginCredential
                          .getUserData()
                          .pageUserName);
                } else {
                  await Get.toNamed(Routes.PROFILE, preventDuplicates: false);
                  controller.userModel.value =
                      controller.loginCredential.getUserData();
                }
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Obx(
                            () => NetworkCircleAvatar(
                          imageUrl: (controller.profileImage.value).formatedProfileUrl,
                          radius: 30,
                        ),
                      ),
                      const SizedBox(width: 10),

                      Expanded(
                        child: Obx(
                              () {
                            final name = controller.profileName.value;
                            return RichText(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  if (profile == true)
                                    const WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 4),
                                        child: Icon(
                                          Icons.verified,
                                          color: Color(0xFF0D7377),
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),

                      if (controller.loginCredential.getProfileSwitch())
                        const ChangeToOriginalProfile(),

                      const UserProfileChangeButton(),
                    ],
                  ),
                ),
              ),

            ),
            const SizedBox(height: 10),
            //====================================================== User Properties Section ======================================================//

            GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                  childAspectRatio: 2.5,
                ),
                itemCount:
                    (controller.loginCredential.getProfileSwitch() == true)
                        ? 7
                        : 10,
                itemBuilder: (context, index) {
                  if (controller.loginCredential.getProfileSwitch() == true) {
                    switch (index) {
                      case 0:
                        return UserPropertyCard(
                          asset: AppAssets.EXPLORE_ICON,
                          title: 'Explore'.tr,
                          onTap: () {
                            Get.toNamed(Routes.EXPLORE);
                          },
                        );

                      case 1:
                        return UserPropertyCard(
                          asset: AppAssets.PAGE_ICON,
                          title: 'Pages'.tr,
                          onTap: () {
                            PagesController pagesController =
                                Get.find<PagesController>();
                            pagesController.getAllPages();
                            Get.toNamed(Routes.PAGES);
                          },
                        );
                      case 2:
                        return UserPropertyCard(
                          asset: AppAssets.BOOKMARKS_ICON,
                          title: 'Bookmarks'.tr,
                          onTap: () {
                            Get.toNamed(Routes.BOOKMARKS);
                          },
                        );
                      case 3:
                        return UserPropertyCard(
                          asset: AppAssets.MARKET_PLACE_ICON,
                          title: 'Marketplace'.tr,
                          onTap: () {
                            debugPrint('MArket Place  Tapped:::::3');
                            DefaultTabController.of(context).animateTo(3);
                          },
                        );
                      case 4:
                        return UserPropertyCard(
                          asset: AppAssets.BUYER_PANEL_ICON,
                          title: 'Buyer Panel'.tr,
                          onTap: () {
                            Get.toNamed(Routes.BUYER_DASHBOARD);
                          },
                        );
                      case 5:
                        return UserPropertyCard(
                          asset: AppAssets.SELLER_PANEL_ICON,
                          title: 'Seller Panel'.tr,
                          onTap: () {
                            Get.toNamed(Routes.SELLER_DASHBOARD);
                          },
                        );
                      case 6:
                        return UserPropertyCard(
                          asset: AppAssets.SELLER_PANEL_ICON,
                          title: 'Wallet'.tr,
                          onTap: () {
                            // Get.toNamed(Routes.WALLET);
                            Get.toNamed(Routes.QP_WALLET_DASHBOARD);
                          },
                        );
                      default:
                        return const SizedBox
                            .shrink(); // Return an empty widget for safety
                    }
                  } else {
                    switch (index) {
                      case 0:
                        return UserPropertyCard(
                          icon: QpIcon.explore,
                          asset: AppAssets.EXPLORE_ICON,
                          title: 'Explore'.tr,
                          onTap: () {
                            Get.toNamed(Routes.EXPLORE);
                          },
                        );
                      case 1:
                        return UserPropertyCard(
                          icon: QpIcon.friendTwo,
                          asset: AppAssets.FRIENDS_ICON,
                          title: 'Friends'.tr,
                          onTap: () {
                            Get.toNamed(Routes.MY_PROFILE_FRIENDS,
                                arguments:
                                    controller.userModel.value?.id ?? '');
                          },
                        );
                      case 2:
                        return UserPropertyCard(
                          icon: QpIcon.group,
                          asset: AppAssets.GROUPS_ICON,
                          title: 'Groups'.tr,
                          onTap: () {
                            Get.toNamed(Routes.GROUPS);
                          },
                        );
                      case 3:
                        return UserPropertyCard(
                          icon: QpIcon.page,
                          asset: AppAssets.PAGE_ICON,
                          title: 'Pages'.tr,
                          onTap: () {
                            PagesController pageController =
                                Get.find<PagesController>();
                            pageController.getAllPages();
                            Get.toNamed(Routes.PAGES);
                          },
                        );
                      case 4:
                        return UserPropertyCard(
                          icon: QpIcon.bookmark,
                          asset: AppAssets.BOOKMARKS_ICON,
                          title: 'Bookmarks'.tr,
                          onTap: () {
                            Get.toNamed(Routes.BOOKMARKS);
                          },
                        );
                      case 5:
                        return UserPropertyCard(
                          icon: QpIcon.marketplace,
                          asset: AppAssets.MARKET_PLACE_ICON,
                          title: 'Marketplace'.tr,
                          onTap: () {
                            TabViewController tabViewController =
                                Get.find<TabViewController>();
                            LoginCredential loginCredential = LoginCredential();

                            if (loginCredential.getProfileSwitch()) {
                              // * GO TO MARKETPLACE WHEN ON PAGE PROFILE
                              tabViewController.tabController.animateTo(3);
                            } else {
                              // * GO TO MARKETPLACE WHEN ON GENERAL PROFILE
                              tabViewController.tabController.animateTo(4);
                            }
                          },
                        );
                      case 6:
                        return UserPropertyCard(
                          icon: QpIcon.buyer,
                          asset: AppAssets.BUYER_PANEL_ICON,
                          title: 'Buyer Panel'.tr,
                          onTap: () {
                            Get.toNamed(Routes.BUYER_DASHBOARD);
                          },
                        );
                      case 7:
                        return UserPropertyCard(
                          icon: QpIcon.seller,
                          asset: AppAssets.SELLER_PANEL_ICON,
                          title: 'Seller Panel'.tr,
                          onTap: () {
                            Get.toNamed(Routes.SELLER_DASHBOARD);
                          },
                        );
                      case 8:
                        return UserPropertyCard(
                          icon: QpIcon.wallet,
                          asset: AppAssets.SELLER_PANEL_ICON,
                          title: 'Wallet'.tr,
                          onTap: () {
                            Get.toNamed(Routes.QP_WALLET_DASHBOARD);
                          },
                        );
                      case 9:
                        return UserPropertyCard(
                          icon: QpIcon.marketplace,
                          asset: '',
                          title: 'Ad Manager'.tr,
                          onTap: () {
                            Get.toNamed(Routes.ADS_CAMPAIGN_HOME);
                          },
                        );
                      default:
                        return const SizedBox
                            .shrink(); // Return an empty widget for safety
                    }
                  }
                }),

            // const SizedBox(height: 10),

            //====================================================== Setting Section ======================================================//

            Card(
              // color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    UserSettingCard(
                        icon: QpIcon.setting,
                        imagePath: AppAssets.SETTINGS_ICON,
                        title: 'Settings & privacy'.tr,
                        onTap: () async {
                          await Get.to(() => const SettingsPrivacyView());
                          controller.userModel.value =
                              controller.loginCredential.getUserData();
                        }),
                    const SizedBox(height: 20),
                    UserSettingCard(
                        icon: QpIcon.help,
                        imagePath: AppAssets.HELP_CENTER_ICON,
                        title: 'Help and Support Center'.tr,
                        onTap: () {
                          Get.toNamed(Routes.HELP_SUPPORT);
                        }),
                    const SizedBox(height: 20),
                    UserSettingCard(
                      // icon: QpIcon.setting,  //TODO: Change to QpIcon.feedback when added to the font
                      imagePath: AppAssets.GIVE_US_FEEDBACK_ICON,
                      title: 'Give us Feedback'.tr,
                      onTap: () {},
                    ),
                    const SizedBox(height: 20),
                    UserSettingCard(
                      icon: QpIcon.signOut,
                      imagePath: AppAssets.SIGN_OUT_ICON,
                      title: 'Sign Out'.tr,
                      onTap: controller.onTapSignOut,
                    ),
                    MediaQuery.of(context).padding.bottom > 0 ? 30.h : 0.h,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
