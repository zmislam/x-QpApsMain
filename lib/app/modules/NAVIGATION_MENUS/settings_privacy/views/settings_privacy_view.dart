import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quantum_possibilities_flutter/app/utils/Localization/lib/app/modules/changeLanguage/views/change_language_view.dart';
import '../../../../extension/num.dart';
import '../../../../components/custom_alert_dialog.dart';
import '../../../../config/constants/app_assets.dart';
import '../../../../config/theme/core_app_theme.dart';
import '../controllers/settings_privacy_controller.dart';
import 'block_list_view.dart';
import 'change_password_view.dart';
import 'personal_details_view.dart';
import 'post_privacy_view.dart';
import 'story_privacy_view.dart';
import '../widgets/custom_setting_tiles.dart';
import '../../../../routes/app_pages.dart';

class SettingsPrivacyView extends GetView<SettingsPrivacyController> {
  const SettingsPrivacyView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
          onPressed: () {
            Get.lazyPut(() => SettingsPrivacyController());
            controller.userMenuController.update();
            Get.back();
          },
        ),
        title: Text('Settings & Privacy'.tr,
        ),
        centerTitle: true,
        elevation: 0,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Account Settings'.tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                // color: Colors.white,
                color: Get.theme.cardTheme.color,
                borderRadius: BorderRadius.circular(8),
                // border: Border.all(color: Colors.white),
              ),
              child: Column(
                children: [
                  CustomSettingsListTile(
                    iconPath: AppAssets.PERSON_ICON, // Pass the image URL
                    text: 'Personal details'.tr,
                    onTap: () {
                      Get.lazyPut(() => SettingsPrivacyController());
                      Get.to(() => const PersonalDetailsFormView());
                    },
                  ),
                  CustomSettingsListTile(
                    iconPath: AppAssets.PASSWORD_ICON, // Pass the image URL
                    text: 'Password and security'.tr,
                    onTap: () {
                      Get.lazyPut(() => SettingsPrivacyController());
                      Get.to(() => const ChangePasswordView());
                    },
                  ),
                  CustomSettingsListTile(
                    iconPath: AppAssets.BLOCK_ICON, // Pass the image URL
                    text: 'Block List'.tr,
                    onTap: () {
                      // Handle tap here
                      Get.lazyPut(() => SettingsPrivacyController());

                      Get.to(() => const BlockListView());
                    },
                  ),
                  CustomSettingsListTile(
                    iconPath: AppAssets.Language_Image, // Pass the image URL
                    text: 'Change Language'.tr,
                    onTap: () {
                      // Handle tap here
                      Get.lazyPut(() => SettingsPrivacyController());

                      Get.to(() => ChangeLanguageView());
                    },
                  ),
                  CustomSettingsListTile(
                    iconPath: AppAssets.EXPLORE_ICON, // Reusing icon for now
                    text: 'Feed Preferences'.tr,
                    onTap: () {
                      Get.toNamed(Routes.FEED_PREFERENCES);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text('Privacy Settings'.tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                color: Get.theme.cardTheme.color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  CustomSettingsListTile(
                    iconPath: AppAssets.POST_PRIVACY_ICON, // Pass the image URL
                    text: 'Posts Privacy'.tr,
                    onTap: () {
                      // Handle tap here
                      Get.lazyPut(() => SettingsPrivacyController());

                      Get.to(() => const PostPrivacyView());
                    },
                  ),
                  CustomSettingsListTile(
                    iconPath:
                        AppAssets.STORY_PRIVACY_ICON, // Pass the image URL
                    text: 'Stories Privacy'.tr,
                    onTap: () {
                      // Handle tap here
                      Get.lazyPut(() => SettingsPrivacyController());

                      Get.to(() => const StoryPrivacyView());
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text('App Settings'.tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Material(
              color: Get.theme.cardTheme.color,
              borderRadius: BorderRadius.circular(8),
              child: ListTile(
                leading: Icon(
                  Icons.color_lens_outlined,
                  size: 25,
                  color: Get.theme.iconTheme.color,
                ),
                title: Text('Theme'.tr,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                trailing: Switch(
                    value: !themeController.isDarkMode,
                    onChanged: (value) {
                      themeController.toggleTheme(isDarkMode: !value);
                      controller.update();
                    }),
              ),
            ),
            10.h,
            Container(
              // height: MediaQuery.of(context).size.height * 0.10,
              decoration: BoxDecoration(
                color: Get.theme.cardTheme.color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomSettingsListTile(
                isTrailing: false,
                iconPath: AppAssets.DELETE_ICON, // Pass the image URL
                iconColor: Colors.red,
                text: 'Delete Account'.tr,
                textColor: Colors.red,
                onTap: () {
                  showDialog(
                    context: Get.context!,
                    builder: (context) => CustomAlertDialog(
                      icon: Icons.delete_forever_rounded,
                      iconColor: Colors.red,
                      iconSize: 28,
                      title: 'Delete Account'.tr,
                      description:
                          'Are you sure you want to delete your account? This action is permanent and cannot be undone.'
                              .tr,
                      cancelButtonText: 'Cancel'.tr,
                      confirmButtonText: 'Delete'.tr,
                      onCancel: () {
                        Get.lazyPut(() => SettingsPrivacyController());
                        Navigator.of(context).pop();
                      },
                      onConfirm: () {
                        Get.lazyPut(() => SettingsPrivacyController());
                        // Call your delete method here
                        controller.deleteAccount();
                      },
                    ),
                  );
                  // // Handle tap here
                  // Get.lazyPut(() => SettingsPrivacyController());

                  // Get.to(() => const BlockListView());
                },
              ),
            ),
            10.h,
            Container(
              decoration: BoxDecoration(
                color: Get.theme.cardTheme.color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomSettingsListTile(
                isTrailing: false,
                iconPath: AppAssets.BLOCK_ICON, // Pass the image URL
                iconColor: Colors.deepOrange,
                text: 'Deactivate & Sign Out'.tr,
                textColor: Colors.deepOrange,
                onTap: () {
                  showDialog(
                    context: Get.context!,
                    builder: (context) => CustomAlertDialog(
                      icon: Icons.logout_rounded,
                      iconColor: Colors.deepOrange,
                      iconSize: 28,
                      title: 'Deactivate Account'.tr,
                      description:
                          'Are you sure you want to deactivate your account?'
                              .tr,
                      cancelButtonText: 'Cancel'.tr,
                      confirmButtonText: 'Deactivate & Sign Out'.tr,
                      onCancel: () {
                        Get.lazyPut(() => SettingsPrivacyController());
                        Navigator.of(context).pop();
                      },
                      onConfirm: () {
                        Get.lazyPut(() => SettingsPrivacyController());
                        // Call your delete method here
                        controller.deactivatedAccount();
                      },
                    ),
                  );
                  // // Handle tap here
                  // Get.lazyPut(() => SettingsPrivacyController());

                  // Get.to(() => const BlockListView());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
