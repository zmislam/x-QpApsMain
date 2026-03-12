import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../components/dropdown.dart';
import '../../admin_page/controller/admin_page_controller.dart';
import '../../pages/model/admin_page_make_admin_model.dart';
import '../../../../../../../config/constants/color.dart';

class PageAddAdminModerator extends StatelessWidget {
  const PageAddAdminModerator({super.key});

  @override
  Widget build(BuildContext context) {
    AdminPageController adminPageController = Get.find();
    PageMakeAdminModel? pageMakeAdminModel;
    adminPageController.getPageAdminList();
    adminPageController.selectedPageAdminList.clear();
    adminPageController.pageAdminList.clear();
    adminPageController.filteredFriendList.clear();

    List<String> roles = ['Admin', 'Moderator'];

    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        // backgroundColor: Colors.white,
        leading: const BackButton(
          color: Colors.black,
        ),
        title: Text('Add Page Admin & Moderator'.tr,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Role'.tr,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              PrimaryDropDownField(
                list: roles,
                hint: 'Role',
                onChanged: (changed) {
                  adminPageController.selectedUserRole.value =
                      changed ?? 'Admin';
                },
              ),
              const SizedBox(height: 20),
              Obx(
                () => Visibility(
                  visible: adminPageController.selectedPageAdminList.isNotEmpty,
                  child: SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          adminPageController.selectedPageAdminList.length,
                      itemBuilder: (BuildContext context, int index) {
                        pageMakeAdminModel =
                            adminPageController.selectedPageAdminList[index];

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          // height: 50,
                          // width: 120,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(pageMakeAdminModel?.friend?.firstName ??
                                    ''),
                                InkWell(
                                  onTap: () {
                                    adminPageController.selectedPageAdminList
                                        .removeAt(index);
                                    adminPageController.selectedPageAdminList
                                        .refresh();
                                  },
                                  child: const Icon(Icons.close,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Search Friends'.tr,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search friends...'.tr,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (value) {
                  adminPageController.searchFriends(value);
                },
              ),
              const SizedBox(height: 20),
              Text('All Friends'.tr,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Obx(() {
                // Filter friends while excluding the current user
                List<PageMakeAdminModel> filteredList = adminPageController
                    .filteredFriendList
                    .where((friend) =>
                        friend.id !=
                        adminPageController.loginCredential.getUserData().id)
                    .toList();

                if (filteredList.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Text('No search found'.tr,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: adminPageController.filteredFriendList
                      .where((friend) =>
                          friend.id !=
                          adminPageController.loginCredential.getUserData().id)
                      .toList()
                      .length,
                  itemBuilder: (context, index) {
                    // Get the filtered list of friends, excluding the current user
                    List<PageMakeAdminModel> filteredList = adminPageController
                        .filteredFriendList
                        .where((friend) =>
                            friend.id !=
                            adminPageController.loginCredential
                                .getUserData()
                                .id)
                        .toList();

                    // Get the friend for the current index
                    PageMakeAdminModel filteredFriend = filteredList[index];

                    return InkWell(
                      onTap: () {
                        if (!adminPageController.selectedPageAdminList
                            .contains(filteredFriend)) {
                          adminPageController.selectedPageAdminList
                              .add(filteredFriend);
                        }
                      },
                      child: Container(
                        height: 60,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                (filteredFriend.friend?.profilePic ?? '')
                                    .formatedProfileUrl,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '${filteredFriend.friend?.firstName ?? ''} ${filteredFriend.friend?.lastName ?? ''}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
              const SizedBox(height: 20),
              Obx(
                () => Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: adminPageController.selectedPageAdminList.isNotEmpty
                        ? PRIMARY_COLOR
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: () {
                      adminPageController.makePageAdmin(
                          adminPageController.pageUserName ?? '',
                          pageMakeAdminModel?.friend?.id ?? '');
                    },
                    //   adminPageController.selectedPageAdminList.value.isNotEmpty
                    //       ? () {
                    //           adminPageController.makePageAdmin(
                    //               adminPageController.pageUserName ?? '',
                    //               pageMakeAdminModel?.friend?.id ?? '');
                    //         }
                    //       : null;
                    // },
                    child: Text('Add'.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
