import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../../../../../../../../components/edit_profile/privacy_model.dart';
import '../../../../../../../../../../models/social_media_model.dart';
import '../../add%20website/controllers/add_website_controller.dart';
import '../../../../../../../../../../config/constants/color.dart';

import '../../../../../../../../../../components/button.dart';

class AddWebsiteView extends GetView<AddWebsiteController> {
  const AddWebsiteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: PRIMARY_GREY_DIVIDER_COLOR,
              height: 1.0,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
          title: Text('Add Website or Others Link'.tr,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          // backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            /*============================================================Website Type Name=========================*/
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                Text('Website Type'.tr,
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(() => Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    height: 50,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
                    child: DropdownButton<SocialMediaModel>(
                      value: controller.selectedSocialMediaType.value,
                      isExpanded: true,
                      onChanged: (selectedWebsitesType) {
                        controller
                            .setSelectedDropdownValue(selectedWebsitesType);
                      },
                      items: controller.socialMediaList.map(
                        (socialMedia) {
                          return DropdownMenuItem<SocialMediaModel>(
                            value: socialMedia,
                            child: Text(socialMedia.media_name ?? ''),
                          );
                        },
                      ).toList(),
                      underline: const SizedBox.shrink(),
                    ),
                  ),
                )),
            const SizedBox(height: 20),
            /*=================================Link Field=========================*/
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                Text('Link'.tr,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: TextFormField(
                controller: controller.linkAddressController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'www.google.com'.tr,
                ),
                onChanged: (value) {
                  controller.linkAddressController.text = value.toString();
                },
              ),
            ),
            const SizedBox(height: 20),

            /*============================================================Privacy=========================*/
            Row(
              children: [
                const SizedBox(width: 20),
                Text('Privacy'.tr,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Obx(
              () => Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: DropdownSearch<PrivacySearchModel>(
                  selectedItem: controller.privacyModel.value,
                  asyncItems: (String filter) => controller.getData(filter),
                  itemAsString: (PrivacySearchModel u) =>
                      u
                          .userAsPublic()
                          .replaceAll(RegExp(r'_'), ' ')
                          .capitalizeFirst ??
                      '',
                  onChanged: (PrivacySearchModel? data) {
                    controller.privacyModel.value = data;
                    controller.getPrivacyDescription(
                        controller.privacyModel.value?.privacy ?? 'public');
                  },
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Public'.tr,
                    ),
                  ),
                  popupProps: PopupProps.bottomSheet(
                    bottomSheetProps: BottomSheetProps(
                      shape: const RoundedRectangleBorder(
                          side: BorderSide(
                              color: Color(0xFF2A8068)), //the outline color
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      elevation: 4,
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                    ),
                    fit: FlexFit.loose,
                    showSearchBox: false,
                    itemBuilder: (context, item, isSelected) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardTheme.color,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 50.0,
                              spreadRadius: 5.0,
                              offset: Offset(0, 5),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: ListTile(
                          leading: controller.getIconForPrivacy(
                              isSelected, item.privacy ?? 'Public'),
                          title: Text(item
                                  .userAsPublic()
                                  .replaceAll(RegExp(r'_'), ' ')
                                  .capitalizeFirst ??
                              ''),
                          selected: isSelected,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: PrimaryButton(
                  borderRadius: BorderRadius.circular(5),
                  onPressed: () {
                    controller.onTapAddWebsitePatch(
                        websiteId: controller.websites?.id);
                  },
                  text: 'Save'.tr,
                  horizontalPadding: 20,
                  verticalPadding: 10,
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
        )));
  }
}
