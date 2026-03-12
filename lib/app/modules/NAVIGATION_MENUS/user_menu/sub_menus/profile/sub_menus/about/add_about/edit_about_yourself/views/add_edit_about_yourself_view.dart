import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../../../../../../../../components/edit_profile/privacy_model.dart';
import '../controllers/add_edit_about_yourself_controller.dart';
import '../../../../../../../../../../config/constants/color.dart';

import '../../../../../../../../../../components/button.dart';

class AddAboutYourselfView extends GetView<AddAboutYourselfController> {
  const AddAboutYourselfView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.white,
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
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Get.back(),
          ),
          title: Text('Add About You'.tr,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
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
            /*============================================================About You Description=========================*/
            Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Text('About You'.tr,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
           


            Padding(
  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
  child: Obx(() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 120,
          width: double.maxFinite,
          decoration: BoxDecoration(
            border: Border.all(
              color: controller.aboutYouLength.value > 400 ? Colors.red : Colors.grey,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: TextFormField(
              controller: controller.aboutYourselfController,
              maxLines: 10,
              // maxLength: 100,
              decoration: const InputDecoration(
                counterStyle: TextStyle(
                  height: double.minPositive,
                ),
                counterText: '',
              ),
              onChanged: (value) {
                controller.updateBioLength(value.length);
              },
            ),
          ),
        ),
        const SizedBox(height: 5),
      Padding(
  padding: const EdgeInsets.only(left: 10.0, right: 10),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      if (controller.aboutYouLength.value > 400)
        Flexible(
          child: Text('Text exceeds 400 characters'.tr,
            style: TextStyle(color: Colors.red),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      Flexible(
        child: Align(
          alignment: Alignment.centerRight,
          child: Text('${controller.aboutYouLength.value} / 400'.tr,
            style: TextStyle(
              color: controller.aboutYouLength.value > 400 ? Colors.red : Colors.grey,
            ),
          ),
        ),
      ),
    ],
  ),
),

      ],
    );
  }),
),

            const SizedBox(height: 20),

            /*============================================================Privacy=========================*/
            Row(
              children: [
                SizedBox(width: 20),
                Text('Privacy'.tr,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                height: 50,
                width: double.maxFinite,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5)),
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
                        controller.privacyModel.value?.privacy.toString() ?? '');
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
                      // backgroundColor: Colors.white,
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                    ),
                    fit: FlexFit.loose,
                    showSearchBox: false,
                    itemBuilder: (context, item, isSelected) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                    controller.onTapEditAboutPatch();
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
