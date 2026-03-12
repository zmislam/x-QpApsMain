import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../components/button.dart';
import '../controllers/boost_post_controller.dart';
import '../widgets/campaign_form_one.dart';
import '../widgets/campaign_form_two.dart';

class BoostPostView extends GetView<BoostPostController> {
    BoostPostView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title:   Text('Boost Post'.tr,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon:   Icon(Icons.arrow_back, size: 24, color: Colors.black),
          ),
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
                      CampaignFormSectionOne(controller: controller),
                        SizedBox(height: 10),
                      CampaignFormSectionTwo(controller: controller),
                        SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding:   EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: PrimaryButton(
                horizontalPadding: 50,
                onPressed: () {
                  if (controller.formKey.currentState!.validate()) {
                    controller.saveBoostPost();
                  } else {
                    Get.snackbar(
                      'Validation Error',
                      'Please fill all required fields correctly.',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
                text: 'Boost Now'.tr,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class BoostPostView extends GetView<BoostPostController> {
//     BoostPostView({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       top: false,
//       child: Scaffold(
//         // backgroundColor: Colors.white,
//         // ==================== appbar section =================================
//         appBar: AppBar(
//           // backgroundColor: Colors.white,
//           title:   Text(
//             'Boost Post',
//             style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//           ),
//           centerTitle: true,
//           leading: IconButton(
//               onPressed: () => Get.back(),
//               icon:
//                     Icon(Icons.arrow_back, size: 24, color: Colors.black)),
//         ),
//         // ============================== body section =========================
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Form(
//                   key: controller.formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       Container(
//                         width: double.infinity,
//                         padding:   EdgeInsets.symmetric(horizontal: 20),
//                         margin:   EdgeInsets.symmetric(horizontal: 10),
//                         decoration: BoxDecoration(
//                             border: Border.all(
//                               color: Colors.grey.withValues(alpha:0.5),
//                             ),
//                             borderRadius: BorderRadius.circular(5)),
//                         child: buildCampaignFormOne(
//                             campaignNameController:
//                                 controller.campaignNameController,
//                             fromDateController: controller.fromDateController,
//                             endDateController: controller.endDateController,
//                             fromDate: (controller.fromDate.value).obs,
//                             endDate: (controller.endDate.value).obs,
//                             onCategoryChanged: (String? data) {
//                               controller.selectedCampaignCategory = data ?? '';
//                             },
//                             context: context),
//                       ),
//                         SizedBox(
//                         height: 10,
//                       ),
//                       Container(
//                         width: double.infinity,
//                         padding:   EdgeInsets.symmetric(horizontal: 20),
//                         margin:   EdgeInsets.symmetric(horizontal: 10),
//                         decoration: BoxDecoration(
//                             border: Border.all(
//                               color: Colors.grey.withValues(alpha:0.5),
//                             ),
//                             borderRadius: BorderRadius.circular(5)),
//                         child: buildCampaignFormTwo(
//                             totalBudgetController:
//                                 controller.totalBudgetController,
//                             dailyBudgetController:
//                                 controller.dailyBudgetController,
//                             destinationController:
//                                 controller.destinationController,
//                             onCLocationChanged: (String? data) {
//                               controller.onCLocationChanged = data ?? '';
//                             },
//                             onKeyWordsChanged: (String? data) {
//                               controller.onKeyWordsChanged = data ?? '';
//                             },
//                             onGenderChanged: (String? data) {
//                               controller.onGenderChanged = data ?? '';
//                             },
//                             onAgeRangeChanged: (RangeValues? value) {
//                               controller.rangeValues =
//                                   value ??   RangeValues(0, 100);
//                             },
//                             onAgeChanged: (String? data) {
//                               controller.ageGroup = data ?? '';
//                             },
//                             context: context),
//                       ),
//                         SizedBox(
//                         height: 15,
//                       ),

//                       //   SizedBox(
//                       //     height: 15,
//                       //   ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding:   EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//               child: PrimaryButton(
//                   horizontalPadding: 50,
//                   onPressed: () {
//                     if (controller.formKey.currentState!.validate()) {
//                       controller.saveBoostPost();
//                     } else {
//                       Get.snackbar('Validation Error',
//                           'Please fill all required fields correctly.',
//                           backgroundColor: Colors.red, colorText: Colors.white);
//                     }
//                   },
//                   text: 'Boost Now'.tr),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildCampaignFormOne({
//     required TextEditingController campaignNameController,
//     required TextEditingController fromDateController,
//     required TextEditingController endDateController,
//     required RxString fromDate,
//     required RxString endDate,
//     required Function(String?) onCategoryChanged,
//     required BuildContext context,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//           SizedBox(height: 10),
//           Text(
//           'Campaign Name',
//           style: TextStyle(fontSize: 16, color: Color(0xff344054)),
//         ),
//           SizedBox(height: 10),
//         PrimaryTextFormField(
//           controller: campaignNameController,
//           hinText: 'Campaign Name',
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Campaign Name is required';
//             }
//             return null;
//           },
//         ),
//           SizedBox(height: 10),
//           Text(
//           'Campaign Category',
//           style: TextStyle(fontSize: 16, color: Color(0xff344054)),
//         ),
//           SizedBox(height: 10),
//         BottomSheetDropdownSearch<String>(
//           hint: 'Select Category',
//           list: controller.campaignCategoryList,
//           onChanged: onCategoryChanged,
//         ),
//           SizedBox(height: 10),
//           Text(
//           'Start Date',
//           style: TextStyle(fontSize: 16, color: Color(0xff344054)),
//         ),
//           SizedBox(height: 10),
//         PrimaryTextFormField(
//           controller: fromDateController,
//           onTap: () =>
//               controller.selectDate(context, fromDate, fromDateController),
//           hinText: 'Start Date',
//           suffixIcon:   Icon(Icons.calendar_today_outlined),
//           suffixIconColor: Colors.grey,
//           readOnly: true,
//         ),
//           SizedBox(height: 10),
//           Text(
//           'End Date',
//           style: TextStyle(fontSize: 16, color: Color(0xff344054)),
//         ),
//           SizedBox(height: 10),
//         PrimaryTextFormField(
//           controller: endDateController,
//           onTap: () =>
//               controller.selectDate(context, endDate, endDateController),
//           hinText: 'End Date',
//           suffixIcon:   Icon(Icons.calendar_today_outlined),
//           suffixIconColor: Colors.grey,
//           readOnly: true,
//         ),
//           SizedBox(height: 20),
//       ],
//     );
//   }

//   Widget buildCampaignFormTwo({
//     required TextEditingController totalBudgetController,
//     required TextEditingController dailyBudgetController,
//     required TextEditingController destinationController,
//     required Function(String?) onCLocationChanged,
//     required Function(String?) onKeyWordsChanged,
//     required Function(String?) onGenderChanged,
//     required Function(String?) onAgeChanged,
//     required Function(RangeValues?) onAgeRangeChanged,
//     required BuildContext context,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//           SizedBox(height: 10),
//           Text(
//           'Total Budget',
//           style: TextStyle(fontSize: 16, color: Color(0xff344054)),
//         ),
//           SizedBox(height: 10),
//         PrimaryTextFormField(
//           controller: totalBudgetController,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please enter a total budget';
//             }

//             double? totalBudget = double.tryParse(value);
//             double? dailyBudget = double.tryParse(dailyBudgetController.text);

//             if (totalBudget == null) {
//               return 'Please enter a valid number';
//             }

//             if (dailyBudget != null && totalBudget < dailyBudget) {
//               return 'Total budget cannot be less than the daily budget';
//             }

//             return null;
//           },
//           onChanged: (value) {
//             controller.totalBudget.value = double.tryParse(value ?? '') ?? 0.0;
//             return null;
//           },
//           hinText: '\$ Total Budget',
//         ),
//           SizedBox(height: 10),
//           Text(
//           'Daily Budget',
//           style: TextStyle(fontSize: 16, color: Color(0xff344054)),
//         ),
//           SizedBox(height: 10),
//         PrimaryTextFormField(
//           controller: dailyBudgetController,
//           hinText: '\$ Daily Budget',
//           readOnly: true,
//         ),
//           SizedBox(height: 10),
//           Text(
//           'User Destination',
//           style: TextStyle(fontSize: 16, color: Color(0xff344054)),
//         ),
//           SizedBox(height: 10),
//         PrimaryTextFormField(
//           controller: destinationController,
//           hinText: 'Destination',
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please enter a destination link';
//             }
//             if (!controller.isValidURL(value)) {
//               return 'Please enter a valid URL';
//             }
//             return null; // ✅ No error
//           },
//         ),
//           SizedBox(height: 10),
//           Text(
//           'Search For Location',
//           style: TextStyle(fontSize: 16, color: Color(0xff344054)),
//         ),
//           SizedBox(height: 10),
//         BottomSheetDropdownSearch<String>(
//           list:   [],
//           onChanged: onCLocationChanged,
//           hint: 'Search Location',
//           onSearch: (String searchText) async {
//             debugPrint('Searching: $searchText');
//             List<AllLocation> locations =
//                 await controller.getLocation(searchText);
//             List<String> locationNames = locations
//                 .map((location) => location.locationName)
//                 .whereType<String>()
//                 .toList();
//             return locationNames;
//           },
//         ),
//           SizedBox(height: 10),
//           Text(
//           'Keywords',
//           style: TextStyle(fontSize: 16, color: Color(0xff344054)),
//         ),
//           SizedBox(height: 10),
//         BottomSheetDropdownSearch<String>(
//           list: controller.keywordsList,
//           onChanged: onKeyWordsChanged,
//         ),
//           SizedBox(height: 10),
//           Text(
//           'Select Gender',
//           style: TextStyle(fontSize: 16, color: Color(0xff344054)),
//         ),
//           SizedBox(height: 10),
//         BottomSheetDropdownSearch<String>(
//           list: controller.genderList,
//           onChanged: onGenderChanged,
//         ),
//           SizedBox(height: 10),
//           Text(
//           'Select Age Range',
//           style: TextStyle(fontSize: 16, color: Color(0xff344054)),
//         ),
//           SizedBox(height: 10),
//         AgeRangeSelector(
//           onRangeSelected: onAgeRangeChanged,
//           onAgeSelected: onAgeChanged,
//         ),
//           SizedBox(height: 20),
//       ],
//     );
//   }
// }
