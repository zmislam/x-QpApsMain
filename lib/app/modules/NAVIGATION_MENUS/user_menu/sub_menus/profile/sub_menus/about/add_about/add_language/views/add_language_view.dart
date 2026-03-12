import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../../../../../../../../components/edit_profile/privacy_model.dart';
import '../controllers/add_language_controller.dart';

import '../../../../../../../../../../config/constants/color.dart';

import '../../../../../../../../../../components/button.dart';

class AddLanguageView extends GetView<AddLanguageController> {
  const AddLanguageView({super.key});

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
          title: Text('Add Language'.tr,
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

            /*================================================================ Phone /Email Field=======================*/
            Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Text('Language'.tr,
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
              child: Container(
                height: 50,
                width: double.maxFinite,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: TextFormField(
                    controller: controller.languageController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Language'.tr),
                    onChanged: (value) {
                      controller.languageController.text = value.toString();
                    },
                  ),
                ),
              ),
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
            Obx(() => Padding(
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
                            controller.privacyModel.value?.privacy.toString() ??
                                '');
                      },
                      dropdownDecoratorProps:  DropDownDecoratorProps(
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
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
                )),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: PrimaryButton(
                  onPressed: () {
                    controller.isEditing
                        ? controller.onTapEditLanguagePacth(
                            Id: controller.languageModel.value?.id ?? '')
                        : controller.onTapAddLangaugePatch();
                  },
                  text: 'Save'.tr,
                  horizontalPadding: 20,
                  verticalPadding: 10,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
        )));
  }
}
