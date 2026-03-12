import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../components/button.dart';
import '../../../../../../components/text_form_field.dart';

import '../../../../../../models/location_model.dart';
import '../components/age_range_selector.dart';
import '../components/custom_dropdown_bottomsheet.dart';
import '../components/keyword_selection_widget.dart';
import '../controllers/boost_reels_controller.dart';

class BoostReelsView extends GetView<BoostReelsController> {
  const BoostReelsView({super.key});

  @override
  Widget build(BuildContext context) {
    // controller.generateThumbnail(
    //     getFormatedReelUrl(controller.reelsModel.value.video ?? ''));
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        // backgroundColor: Colors.white,
        title: Text('Boost Reels'.tr,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // InkWell(
                    //   onTap: () {
                    //     Get.toNamed(Routes.PROFILE);
                    //   },
                    //   child: Row(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       const SizedBox(width: 10),
                    //       RoundCornerNetworkImage(
                    //         imageUrl: getFormatedProfileUrl(controller
                    //                 .reelsModel.value.reel_user?.profile_pic ??
                    //             ''),
                    //         //  getFormatedProfileUrl(
                    //         //   model.share_post_id!.user_id!.profile_pic ?? '',
                    //         // ),
                    //       ),
                    //       const SizedBox(width: 10),
                    //       Expanded(
                    //         child: Column(
                    //           mainAxisAlignment: MainAxisAlignment.start,
                    //           crossAxisAlignment: CrossAxisAlignment.stretch,
                    //           children: [
                    //             RichText(
                    //                 text: TextSpan(children: [
                    //               TextSpan(
                    //                 text:
                    //                     '${controller.reelsModel.value.reel_user?.first_name ?? ''} ${controller.reelsModel.value.reel_user?.last_name ?? ''}',
                    //                 style: TextStyle(
                    //                   fontWeight: FontWeight.bold,
                    //                   fontSize: 16,
                    //                   color: Colors.black,
                    //                 ),
                    //               ),
                    //               // TextSpan(children: [
                    //               //   model.share_post_id?.feeling_id != null
                    //               //       ? TextSpan(children: [
                    //               //           TextSpan(
                    //               //               children: [
                    //               //                 TextSpan(
                    //               //                     text: ' is feeling'.tr,
                    //               //                     style: TextStyle(
                    //               //                         color: Colors.black,
                    //               //                         fontWeight: FontWeight.w500,
                    //               //                         fontSize: 16)),
                    //               //                 WidgetSpan(
                    //               //                     child: Padding(
                    //               //                   padding: const EdgeInsets.only(
                    //               //                       left: 3.0),
                    //               //                   child: ReactionIcon(model
                    //               //                           .feeling_id?.logo
                    //               //                           .toString() ??
                    //               //                       ''),
                    //               //                 )),
                    //               //                 TextSpan(
                    //               //                     text:
                    //               //                         ' ${model.feeling_id?.feelingName}',
                    //               //                     style: TextStyle(
                    //               //                       color: Colors.black,
                    //               //                       fontWeight: FontWeight.w500,
                    //               //                       fontSize: 16,
                    //               //                     )),
                    //               //               ],
                    //               //               style: TextStyle(
                    //               //                   color: Colors.black, fontSize: 16)),
                    //               //         ])
                    //               //       : TextSpan(
                    //               //           text: '',
                    //               //           style: TextStyle(
                    //               //               color: Colors.grey.shade700,
                    //               //               fontSize: 16)),
                    //               //   TextSpan(
                    //               //       text: getSharedLocationText(model),
                    //               //       style: TextStyle(
                    //               //           color: Colors.black,
                    //               //           fontWeight: FontWeight.w500,
                    //               //           fontSize: 16)),
                    //               //   TextSpan(
                    //               //       text: getTagText(model),
                    //               //       recognizer: TapGestureRecognizer()
                    //               //         ..onTap = () {
                    //               //           Get.to(() => PostTagList(
                    //               //                 postModel: model,
                    //               //               ));
                    //               //         },
                    //               //       style: TextStyle(
                    //               //           color: Colors.black,
                    //               //           fontWeight: FontWeight.w500,
                    //               //           fontSize: 16))
                    //               // ]),
                    //             ])),
                    //             const SizedBox(height: 4),
                    //             Row(
                    //               mainAxisAlignment: MainAxisAlignment.start,
                    //               children: [
                    //                 Text(
                    //                     '${wordlyTimeText(controller.reelsModel.value.createdAt ?? '')} '),
                    //                 // Text(
                    //                 //   getTextAsPostType(
                    //                 //       model.share_post_id!.post_type ?? ''),
                    //                 //   style:
                    //                 //       TextStyle(fontWeight: FontWeight.w500),
                    //                 // ),
                    //                 const SizedBox(
                    //                   width: 5,
                    //                 ),

                    //                 // Icons.public,
                    //                 getIconAsPrivacy(controller
                    //                         .reelsModel.value.reels_privacy
                    //                         ?.toLowerCase() ??
                    //                     'public'),
                    //               ],
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       const Padding(
                    //         padding: EdgeInsets.only(right: 10.0),
                    //         child: Icon(Icons.more_vert),
                    //       )
                    //     ],
                    //   ),
                    // ),

                    // Padding(
                    //     padding: const EdgeInsets.symmetric(
                    //         horizontal: 10.0, vertical: 15),
                    //     child: SizedBox(
                    //         height: 320,
                    //         width: double.infinity,
                    //         child: (controller.reelsModel.value.image != null &&
                    //                 controller.reelsModel.value.video == null)
                    //             ? PrimaryNetworkImage(
                    //                 fitImage: BoxFit.fitHeight,
                    //                 imageUrl: getFormatedReelUrl(
                    //                   controller
                    //                           .reelsModel.value.image?.first ??
                    //                       '',
                    //                 ))
                    //             : AspectRatio(
                    //                 aspectRatio: controller
                    //                     .videoPlayerController!
                    //                     .value
                    //                     .aspectRatio,
                    //                 child: VideoPlayer(
                    //                     controller.videoPlayerController!),
                    //               ))
                    //     //  PrimaryNetworkImage(
                    //     //   imageUrl:
                    //     //       controller.reelsModel.value.reel_user?.profile_pic ??
                    //     //           '',
                    //     //   height: 320,
                    //     //   width: double.infinity,
                    //     //   fitImage: BoxFit.fitWidth,
                    //     // ),
                    //     ),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.withValues(alpha: 0.5),
                          ),
                          borderRadius: BorderRadius.circular(5)),
                      child: buildCampaignFormOne(
                          campaignNameController:
                              controller.campaignNameController,
                          fromDateController: controller.fromDateController,
                          endDateController: controller.endDateController,
                          fromDate: (controller.fromDate.value).obs,
                          endDate: (controller.endDate.value).obs,
                          onCategoryChanged: (String? data) {
                            controller.selectedCampaignCategory = data ?? '';
                          },
                          context: context),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.withValues(alpha: 0.5),
                          ),
                          borderRadius: BorderRadius.circular(5)),
                      child: buildCampaignFormTwo(
                          totalBudgetController:
                              controller.totalBudgetController,
                          dailyBudgetController:
                              controller.dailyBudgetController,
                          destinationController:
                              controller.destinationController,
                          onCLocationChanged: (String? data) {
                            controller.onCLocationChanged = data ?? '';
                          },
                          onKeyWordsChanged: (String? data) {
                            controller.onKeyWordsChanged = data ?? '';
                          },
                          onGenderChanged: (String? data) {
                            controller.onGenderChanged = data ?? '';
                          },
                          onAgeRangeChanged: (RangeValues? value) {
                            controller.rangeValues =
                                value ?? const RangeValues(0, 100);
                          },
                          onAgeChanged: (String? data) {
                            controller.ageGroup = data ?? '';
                          },
                          context: context),
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    // const SizedBox(
                    //     height: 15,
                    //   ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: PrimaryButton(
                horizontalPadding: 50,
                onPressed: () {
                  if (controller.formKey.currentState!.validate()) {
                    controller.saveBoostPost();
                  } else {
                    Get.snackbar('Validation Error',
                        'Please fill all required fields correctly.',
                        backgroundColor: Colors.red, colorText: Colors.white);
                  }
                },
                text: 'Boost Now'.tr),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _handleBoostButton,
      //   child: Icon(Icons.play_arrow),
      // ),
    );
  }

  Widget buildCampaignFormOne({
    required TextEditingController campaignNameController,
    required TextEditingController fromDateController,
    required TextEditingController endDateController,
    required RxString fromDate,
    required RxString endDate,
    required Function(String?) onCategoryChanged,
    required BuildContext context,
  }) {
    // void _selectDate(BuildContext context, RxString dateValue,
    //     TextEditingController controller) async {
    //   final DateTime? pickedDate = await showDatePicker(
    //     context: context,
    //     initialDate: DateTime.now(),
    //     firstDate: DateTime.now(),
    //     lastDate: DateTime(2050, 1, 1),
    //   );
    //   if (pickedDate != null) {
    //     dateValue.value =
    //         '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
    //         debugPrint("DateValue:::::::::::::${  dateValue.value}");
    //     controller.text = formatDateOfBirth(dateValue.value);
    //   }
    // }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text('Campaign Name'.tr,
          style: TextStyle(fontSize: 16, color: Color(0xff344054)),
        ),
        const SizedBox(height: 10),
        PrimaryTextFormField(
          controller: campaignNameController,
          hinText: 'Campaign Name',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Campaign Name is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        Text('Campaign Category'.tr,
          style: TextStyle(fontSize: 16, color: Color(0xff344054)),
        ),
        const SizedBox(height: 10),
        // BottomSheetDropdownSearch<String>(
        //   hint: 'Select Category',
        //   list: controller.campaignCategoryList,
        //   onChanged: onCategoryChanged,
        // ),
        CustomDropdownBottomSheet(
          title: '',
          items: controller.campaignCategoryList,
          onItemSelected: onCategoryChanged,
        ),
        const SizedBox(height: 10),
        Text('Start Date'.tr,
          style: TextStyle(fontSize: 16, color: Color(0xff344054)),
        ),
        const SizedBox(height: 10),
        PrimaryTextFormField(
          controller: fromDateController,
          onTap: () =>
              controller.selectDate(context, fromDate, fromDateController),
          hinText: 'Start Date',
          suffixIcon: const Icon(Icons.calendar_today_outlined),
          suffixIconColor: Colors.grey,
          readOnly: true,
        ),
        const SizedBox(height: 10),
        Text('End Date'.tr,
          style: TextStyle(fontSize: 16, color: Color(0xff344054)),
        ),
        const SizedBox(height: 10),
        PrimaryTextFormField(
          controller: endDateController,
          onTap: () =>
              controller.selectDate(context, endDate, endDateController),
          hinText: 'End Date',
          suffixIcon: const Icon(Icons.calendar_today_outlined),
          suffixIconColor: Colors.grey,
          readOnly: true,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildCampaignFormTwo({
    required TextEditingController totalBudgetController,
    required TextEditingController dailyBudgetController,
    required TextEditingController destinationController,
    required Function(String?) onCLocationChanged,
    required Function(String?) onKeyWordsChanged,
    required Function(String?) onGenderChanged,
    required Function(String?) onAgeChanged,
    required Function(RangeValues?) onAgeRangeChanged,
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text('Total Budget'.tr,
          style: TextStyle(fontSize: 16, color: Color(0xff344054)),
        ),
        const SizedBox(height: 10),
        PrimaryTextFormField(
          controller: totalBudgetController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a total budget';
            }

            double? totalBudget = double.tryParse(value);
            double? dailyBudget = double.tryParse(dailyBudgetController.text);

            if (totalBudget == null) {
              return 'Please enter a valid number';
            }

            if (dailyBudget != null && totalBudget < dailyBudget) {
              return 'Total budget cannot be less than the daily budget';
            }

            return null;
          },
          onChanged: (value) {
            controller.totalBudget.value = double.tryParse(value ?? '') ?? 0.0;
            return null;
          },
          hinText: '\$ Total Budget',
        ),
        const SizedBox(height: 10),
        Text('Daily Budget'.tr,
          style: TextStyle(fontSize: 16, color: Color(0xff344054)),
        ),
        const SizedBox(height: 10),
        PrimaryTextFormField(
          controller: dailyBudgetController,
          hinText: '\$ Daily Budget',
          readOnly: true,
        ),
        const SizedBox(height: 10),
        Text('URL'.tr,
          style: TextStyle(fontSize: 16, color: Color(0xff344054)),
        ),
        const SizedBox(height: 10),
        PrimaryTextFormField(
          controller: destinationController,
          hinText: 'Destination',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a destination link';
            }
            if (!controller.isValidURL(value)) {
              return 'Please enter a valid URL';
            }
            return null; // ✅ No error
          },
        ),
        const SizedBox(height: 10),
        Text('Search For Location'.tr,
          style: TextStyle(fontSize: 16, color: Color(0xff344054)),
        ),
        const SizedBox(height: 10),
        Obx(
          () => SearchAbleDropdownBottomSheet<AllLocation>(
            title: 'Select Location'.tr,
            selectedItem: controller.selectedLocation.value,
            asyncItems: controller.getFutureLocation,
            onItemSelected: (value) {
              controller.selectedLocation.value = value;
              controller.onCLocationChanged =
                  controller.selectedLocation.value?.locationName ?? '';
            },
          ),
        ),
        // BottomSheetDropdownSearch<String>(
        //   list: const [],
        //   onChanged: onCLocationChanged,
        //   hint: 'Search Location',
        //   onSearch: (String searchText) async {
        //     if (searchText.trim().isEmpty) {
        //       return [];
        //     }

        //     debugPrint('Searching: $searchText');

        //     try {
        //       List<AllLocation> locations =
        //           await controller.getLocation(searchText);

        //       // ✅ Ensure the new location list is reflected
        //       controller.locationList.value = locations;
        //       controller.locationList.refresh(); // ✅ Force UI Update

        //       return locations
        //           .map((location) => location.locationName ?? '')
        //           .toList();
        //     } catch (e) {
        //       debugPrint('Error fetching locations: $e');
        //       return [];
        //     }
        //   },
        // ),

        const SizedBox(height: 10),
        Text('Keywords'.tr,
          style: TextStyle(fontSize: 16, color: Color(0xff344054)),
        ),
        const SizedBox(height: 10),
        KeywordSelectionWidget(),
        // BottomSheetDropdownSearch<String>(
        //   list: controller.keywordsList,
        //   onChanged: onKeyWordsChanged,
        // ),
        const SizedBox(height: 10),
        Text('Select Gender'.tr,
          style: TextStyle(fontSize: 16, color: Color(0xff344054)),
        ),
        const SizedBox(height: 10),
        CustomDropdownBottomSheet(
          title: '',
          items: controller.genderList,
          onItemSelected: onGenderChanged,
        ),
        // BottomSheetDropdownSearch<String>(
        //   list: controller.genderList,
        //   onChanged: onGenderChanged,
        // ),
        const SizedBox(height: 10),
        Text('Select Age Range'.tr,
          style: TextStyle(fontSize: 16, color: Color(0xff344054)),
        ),
        const SizedBox(height: 10),
        AgeRangeSelector(
          onRangeSelected: onAgeRangeChanged,
          onAgeSelected: onAgeChanged,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
