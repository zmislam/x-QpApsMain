import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/constants/app_assets.dart';

import '../../../../extension/url.dart';
import '../../../../routes/app_pages.dart';
import '../controllers/user_menu_controller.dart';
import '../sub_menus/all_pages/pages/views/create_page_view.dart';

class UserProfileChangeButton extends StatefulWidget {
  const UserProfileChangeButton({super.key});

  @override
  State<UserProfileChangeButton> createState() => _UserProfileChangeButtonState();
}

class _UserProfileChangeButtonState extends State<UserProfileChangeButton> {
  final userMenuController = Get.find<UserMenuController>();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.keyboard_arrow_down,
        size: 25,
      ),
      onPressed: () {
        userMenuController.getAllPages();
        Get.bottomSheet(
          Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                color: Theme.of(context).cardTheme.color),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Bottom sheet visual bar
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: 80,
                  height: 5,
                  decoration: BoxDecoration(color: Colors.grey.shade500, borderRadius: BorderRadius.circular(15)),
                ),

                // Bottom sheet list outer body
                Expanded(
                  child: _BottomSheetMainBody(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _GoToCreatePageButton() {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
            Get.to(() => const CreatePageView());
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Material(
              borderRadius: BorderRadius.circular(10),
              clipBehavior: Clip.hardEdge,
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade300,
                    child: const Icon(
                      Icons.add,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text('Create Page Now'.tr,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _BottomSheetMainBody() {
    final userMenuController = Get.find<UserMenuController>();
    return Obx(() {
      if (userMenuController.loading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (!userMenuController.loading.value && userMenuController.listOfProfiles.isNotEmpty) {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: userMenuController.listOfProfiles.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    /// ----------------------------------- On selecting a profile ------------------
                    onTap: () {
                      Navigator.of(context).pop();
                      userMenuController.profileSwitch(id: userMenuController.listOfProfiles[index].id.toString()).then(
                        (value) {
                          Get.offAndToNamed(Routes.ACCOUNT_SWITCH_PAGE);
                        },
                      );
                    },

                    leading: CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: const AssetImage(AppAssets.DEFAULT_IMAGE),
                      foregroundImage: CachedNetworkImageProvider((userMenuController.listOfProfiles[index].profilePic ?? '').pageImageUrlBuild),
                    ),
                    title: Text(
                      userMenuController.listOfProfiles[index].pageName.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${userMenuController.listOfProfiles[index].followerCount.toString()} Followers'.tr),
                    trailing: userMenuController.listOfProfiles[index].isSelected
                        ? const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          )
                        : null,
                  );
                },
              ),
            ),
            userMenuController.loginCredential.getProfileSwitch() == true ? const SizedBox() : _GoToCreatePageButton()
          ],
        );
      } else if (!userMenuController.loading.value && userMenuController.listOfProfiles.isEmpty) {
        return _GoToCreatePageButton();
      } else {
        return  Center(child: Text('Please try again later'.tr));
      }
    });
  }
}
