import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../../../extension/date_time_extension.dart';
import '../../../../../../../../../../components/text_form_field.dart';
import '../controllers/add_work_place_controller.dart';
import '../../../../../../../../../../config/constants/color.dart';
import '../../../../../../../../../../components/button.dart';
import '../../../../../../../../../../components/edit_profile/privacy_model.dart';

class AddWorkPlaceView extends GetView<AddWorkPlaceController> {
  const AddWorkPlaceView({super.key});

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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          controller.isEditing ? 'Edit Workplace' : 'Add Workplace',
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
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: AboutTextFormField(
                  label: 'Workplace Name'.tr,
                  controller: controller.orgNameController,
                  validationText: 'Workplace name is required!',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              /* +++++++++++++++++++++++++Designation Name +++++++++++++++++++++++++*/
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: AboutTextFormField(
                  label: 'Designation'.tr,
                  controller: controller.designationController,
                  validationText: 'Designation name is required',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              /* +++++++++++++++++++++++++Privacy +++++++++++++++++++++++++*/

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
              /* +++++++++++++++++++++++++From Date +++++++++++++++++++++++++*/

              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: AboutClickableTextFormField(
                  controller: controller.fromDateController,
                  label: 'From Date'.tr,
                  prefixIcon: Icons.calendar_month,
                  validationText: 'From Date is required',
                  hintText: 'From Date Here'.tr,
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950, 1, 1),
                      lastDate: DateTime(2050, 1, 1),
                    ).then((value) {
                      if (value != null) {
                        controller.fromDate.value =
                            '${value.year.toString()}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
                        controller.fromDateController.text = (
                            controller.fromDate.value.toString()).toFormatDateOfBirth();
                      }
                    });
                  },
                ),
              ),
              /* +++++++++++++++++++++++++To Date +++++++++++++++++++++++++*/

              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: AboutClickableTextFormField(
                  controller: controller.toDateController,
                  label: 'To Date'.tr,
                  prefixIcon: Icons.calendar_month,
                  // validationText: 'You must select Currently Working if To Date is not provided',
                  hintText: 'To Date Here'.tr,
                  onTap: () {
                    if (!controller.isWorking.value) {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: controller.fromDate.value == null
                            ? DateTime(1950, 1, 1)
                            : DateTime.parse(controller.fromDate.value ?? ''),
                        lastDate: DateTime.now(),
                      ).then((value) {
                        if (value != null) {
                          controller.toDate.value =
                              '${value.year.toString()}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
                          controller.toDateController.text = (
                              controller.toDate.value.toString()).toFormatDateOfBirth();
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
                      value: controller.isWorking.value,
                      onChanged: (bool? value) {
                        if (value != null) {
                          controller.getIsWorkingCurrently(value);
                        }
                      },
                    ),
                  ),
                   SizedBox(
                    child: Text('Currently Working'.tr,
                      style: TextStyle(fontSize: 15),
                      maxLines: 3,
                    ),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: PrimaryButton(
                      onPressed: () {
                        if (controller.formKey.currentState!.validate() &&
                            controller.fromDate.value != null &&
                            (controller.toDate.value != null ||
                                controller.isWorking.value)) {
                          controller.onTapAddWorkPlacePost(
                              id: controller.userWorkPlaceModel?.id);
                        } else {
                          controller.formKey.currentState!.validate();
                          controller.fromDate.refresh();
                          controller.toDate.refresh();
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
        ),
      ),
    );
  }
}
