import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../../../extension/date_time_extension.dart';
import '../../../../../../../../../../components/button.dart';
import '../../../../../../../../../../components/edit_profile/privacy_model.dart';
import '../../../../../../../../../../components/text_form_field.dart';
import '../../../../../../../../../../config/constants/color.dart';
import '../controllers/add_education_controller.dart';

class AddEducationView extends GetView<AddEducationController> {
  const AddEducationView({super.key});

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
          title: Text(
            controller.isEditing ? 'Edit Education' : 'Add Education',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
            child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              /*============================================================Institute Name=========================*/

              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: AboutTextFormField(
                  label: 'Educational Workplace Name'.tr,
                  controller: controller.instituteNameController,
                  validationText: 'Educational Workplace name is required!',
                ),
              ),
              const SizedBox(
                height: 20,
              ),

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
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: DropdownSearch<PrivacySearchModel>(
                    selectedItem: controller.privacyModel,
                    asyncItems: (String filter) => controller.getData(filter),
                    itemAsString: (PrivacySearchModel u) =>
                        u
                            .userAsPublic()
                            .replaceAll(RegExp(r'_'), ' ')
                            .capitalizeFirst ??
                        '',
                    onChanged: (PrivacySearchModel? data) {
                      controller.privacyModel = data;
                      controller.getPrivacyDescription(
                          controller.privacyModel?.privacy.toString() ?? '');
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
              ),
              const SizedBox(
                height: 20,
              ),
              /*============================================================From=========================*/

              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: AboutClickableTextFormField(
                  controller: controller.startDateController,
                  label: 'Start Date'.tr,
                  prefixIcon: Icons.calendar_month,
                  validationText: 'Start Date is required',
                  hintText: 'Start Date Here'.tr,
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950, 1, 1),
                      lastDate: DateTime(2050, 1, 1),
                    ).then((value) {
                      if (value != null) {
                        controller.startDate.value =
                            '${value.year.toString()}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
                        controller.startDateController.text = (
                            controller.startDate.value.toString()).toFormatDateOfBirth();
                      }
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              /*============================================================To=========================*/
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: AboutClickableTextFormField(
                  controller: controller.endDateController,
                  label: 'End Date'.tr,
                  prefixIcon: Icons.calendar_month,
                  // validationText: 'You must select Currently Studying if To Date is not provided',
                  hintText: 'To Date Here'.tr,
                  onTap: () {
                    if (!controller.isStudying.value) {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: controller.startDate.value == null
                            ? DateTime(1950, 1, 1)
                            : DateTime.parse(controller.startDate.value ?? ''),
                        lastDate: DateTime.now(),
                      ).then((value) {
                        if (value != null) {
                          controller.endDate.value =
                              '${value.year.toString()}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
                          controller.endDateController.text = (
                              controller.endDate.value.toString()).toFormatDateOfBirth();
                        }
                      });
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Obx(
                    () => Checkbox(
                      tristate: false,
                      checkColor: Colors.white,
                      activeColor: PRIMARY_COLOR,
                      value: controller.isStudying.value,
                      onChanged: (bool? value) {
                        if (value != null) {
                          controller.getIsStudyingCurrently(value);
                        }
                      },
                    ),
                  ),
                   SizedBox(
                    child: Text('Currenly Studying'.tr,
                      style: TextStyle(fontSize: 15),
                      maxLines: 3,
                    ),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: PrimaryButton(
                      onPressed: () {
                        if (controller.formKey.currentState!.validate() &&
                            controller.startDate.value != null &&
                            (controller.endDate.value != null ||
                                controller.isStudying.value)) {
                          controller.isEditing
                              ? controller.onTapEditEducationPatch(
                                  id: controller.educationalWorkPlaceModel?.id)
                              : controller.onTapAddEducationPost();
                        } else {
                          controller.formKey.currentState!.validate();
                          controller.startDate.refresh();
                          controller.endDate.refresh();
                        }
                      },
                      text: 'Save'.tr,
                      horizontalPadding: 20,
                      verticalPadding: 10,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ],
          ),
        )));
  }
}
