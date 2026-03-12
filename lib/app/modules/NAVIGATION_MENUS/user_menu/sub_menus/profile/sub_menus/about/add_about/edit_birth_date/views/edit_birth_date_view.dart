import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

import 'package:get/get.dart';
import '../../../../../../../../../../components/button.dart';

import '../../../../../../../../../../components/edit_profile/privacy_model.dart';
import '../../../../../../../../../../config/constants/color.dart';
import '../controllers/edit_birth_date_controller.dart';

class EditBirthDateView extends GetView<EditBirthDateController> {
  const EditBirthDateView({super.key});
  @override
  Widget build(BuildContext context) {
    controller;
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
          title: Text('Edit Birthday Date'.tr,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        body: Obx(
          () => Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(40),
                child: DatePickerWidget(
                  looping: true, // default is not looping
                  firstDate: DateTime(1950, 01, 01),
                  lastDate: DateTime.now().subtract(const Duration(days: 4750)),
                  initialDate: controller.selectedDate.value,
                  dateFormat: 'dd-MMM-yyyy',
                  locale: DatePicker.localeFromString('en'),
                  onChange: (DateTime newDate, context) {
                    // )controller.onSelectDate(newDate);
                    controller.selectedDate.value = newDate;
                  },
                  pickerTheme: const DateTimePickerTheme(
                    itemTextStyle:
                        TextStyle(color: PRIMARY_COLOR, fontSize: 19),
                    dividerColor: PRIMARY_COLOR,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
              Row(
                children: [
                  const SizedBox(width: 20),
                  Text('Privacy'.tr,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: DropdownSearch<PrivacySearchModel>(
                  selectedItem: controller.selectedPrivacyModel.value,
                  asyncItems: (String filter) => controller.getData(filter),
                  itemAsString: (PrivacySearchModel u) =>
                      u
                          .userAsPublic()
                          .replaceAll(RegExp(r'_'), ' ')
                          .capitalizeFirst ??
                      '',
                  onChanged: (PrivacySearchModel? data) {
                    controller.selectedPrivacyModel.value = data;
                    controller.getPrivacyDescription(controller
                            .selectedPrivacyModel.value?.privacy
                            .toString() ??
                        '');
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
              const SizedBox(height: 20),
              Row(
                children: [
                  const SizedBox(width: 20),
                  Text('Show Type'.tr,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
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
                  child: DropdownButton<String>(
                    value: controller.selectedViewType.value,
                    isExpanded: true,
                    onChanged: (newValue) {
                      controller.selectedViewType.value = newValue ?? '';
                    },
                    items: controller.viewTypeList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    underline: const SizedBox.shrink(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                        child: PrimaryButton(
                      onPressed: () {
                        controller.updateBirthday();
                      },
                      text: 'Save'.tr,
                      verticalPadding: 15,
                    )),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
