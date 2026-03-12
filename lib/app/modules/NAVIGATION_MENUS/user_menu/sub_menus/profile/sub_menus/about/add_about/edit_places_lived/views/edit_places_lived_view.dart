import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../../../../../../../../components/edit_profile/privacy_model.dart';
import '../controllers/edit_places_lived_controller.dart';

import '../../../../../../../../../../config/constants/color.dart';

import '../../../../../../../../../../components/button.dart';

class EditPlacesLivedView extends GetView<EditPlacesLivedController> {
  const EditPlacesLivedView({super.key});

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
          title: Obx(() => Text(
                controller.isEditing.value
                    ? 'Edit Places Lived'
                    : 'Add Places Lived',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              )),
        ),
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            /*============================================================Place Type=========================*/
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                Text('Place Type'.tr,
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
            Obx(() {
              return Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    height: 50,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
                    child: DropdownButton<String>(
                      value: controller.placeDropdownalue.value,
                      isExpanded: true,
                      onChanged: (newValue) {
                        controller.setSelectedDropdownValue(newValue!);
                      },
                      items: <String>['Home Town', 'Current City']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      underline: const SizedBox.shrink(),
                    ),
                  ));
            }),
            const SizedBox(height: 20),

            /*================================================================ Current City /Home Town Field=======================*/
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                Obx(
                  () => Text(
                    controller.placeDropdownalue.value == 'Home Town'
                        ? 'Home Town'
                        : 'Current City',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(
              () => Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextFormField(
                  keyboardType: TextInputType.streetAddress,
                  controller: controller.placeAddressController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: controller.placeDropdownalue.value == 'Home Town'
                        ? 'Home Town'
                        : 'Current City',
                  ),
                  onChanged: (value) {
                    controller.placeAddressController.text = value.toString();
                  },
                ),
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

            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: DropdownSearch<PrivacySearchModel>(
                selectedItem: controller.privacyModel,
                asyncItems: (String filter) => controller.getData(filter),
                itemAsString: (PrivacySearchModel u) =>
                    u
                        .userAsPublic()
                        .replaceAll(RegExp(r'_'), ' ')
                        .capitalizeFirst ??
                    'Public',
                onChanged: (PrivacySearchModel? data) {
                  controller.privacyModel = data;
                  controller.getPrivacyDescription(
                      controller.privacyModel?.privacy.toString() ?? 'public');
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
            // ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: PrimaryButton(
                  onPressed: () {
                    controller.onTapEditPlacesLivedPost();
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
