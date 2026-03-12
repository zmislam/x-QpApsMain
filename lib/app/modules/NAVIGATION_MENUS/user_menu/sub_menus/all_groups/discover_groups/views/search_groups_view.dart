// // ignore_for_file: invalid_use_of_protected_member

// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:quantum_possibilities_flutter/app/components/dropdown.dart';
// import 'package:quantum_possibilities_flutter/app/config/app_assets.dart';
// import 'package:quantum_possibilities_flutter/app/modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/discover_groups/controllers/discover_groups_controller.dart';
// import 'package:quantum_possibilities_flutter/app/modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/discover_groups/models/all_group_model.dart';

// import '../../../../../../../routes/app_pages.dart';
// import '../../../../../../../utils/color.dart';
// import '../../../../../../../utils/image.dart';

// class DiscoverGroupSearchView extends StatelessWidget {
//   const DiscoverGroupSearchView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     DiscoverGroupsController controller = Get.find();
//     controller.filteredGroupsList.clear();
//     controller.searchedGroupList.value.clear();

//     return Scaffold(
//       // backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(
//           'Search Groups',
//           style: TextStyle(color: Colors.black),
//         ),
//         leading: const BackButton(
//           color: Colors.black,
//         ),
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(left: 20, right: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 10),
//             TextFormField(
//               decoration: InputDecoration(
//                 border: const OutlineInputBorder(),
//                 focusedBorder: FOCUSED_BORDER,
//                 hintText: 'Search groups'.tr,
//                 hintStyle:
//                     const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                 suffixIcon: IconButton(
//                   onPressed: () {
//                     controller.filteredGroupsList.value =
//                         controller.searchedGroupList.value;
//                   },
//                   icon: const Icon(Icons.search),
//                 ),
//                 contentPadding:
//                     const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//               ),
//               onChanged: (String text) {
//                 if (controller.debounce?.isActive ?? false) {
//                   controller.debounce?.cancel();
//                 }

//                 controller.debounce = Timer(const Duration(seconds: 2), () {
//                   if (text.isNotEmpty) {
//                     controller.getSearchGroup(text);
//                   } else {
//                     controller.filteredGroupsList.value =
//                         List<AllGroupModel>.from(controller.searchedGroupList.value);
//                   }
//                 });
//               },
//             ),
//             const SizedBox(height: 40),
//             Obx(() => Expanded(
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: controller.searchedGroupList.value.length,
//                     itemBuilder: (context, index) {
//                       AllGroupModel searchGroupModel =
//                           controller.searchedGroupList.value[index];

//                       return Padding(
//                         padding: const EdgeInsets.all(10),
//                         child: InkWell(
//                           onTap: () {
//                             Get.toNamed(Routes.GROUP_PROFILE,
//                                 arguments: {
//                                   'id': searchGroupModel.id,
//                                   'group_type': 'discoverGroups'
//                                 });
//                           },
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Image(
//                                 errorBuilder: (context, error, stackTrace) {
//                                   return const Image(
//                                     height: 100,
//                                     width: double.infinity,
//                                     fit: BoxFit.cover,
//                                     image: AssetImage(
//                                       AppAssets.DEFAULT_IMAGE,
//                                     ),
//                                   );
//                                 },
//                                 height: 100,
//                                 width: double.infinity,
//                                 fit: BoxFit.cover,
//                                 image: NetworkImage(
//                                   getFormatedPageProfileUrl(
//                                       searchGroupModel.groupCoverPic ?? ''),
//                                 ),
//                               ),
//                               const SizedBox(height: 5),
//                               Text(
//                                 searchGroupModel.groupName ?? '',
//                                 overflow: TextOverflow.ellipsis,
//                                 style: const TextStyle(
//                                     fontSize: 14, fontWeight: FontWeight.bold),
//                               ),
//                               const SizedBox(height: 5),
//                               Text(
//                                 '${(searchGroupModel.category as List<String>?)?.join('') ?? ''}',
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               const SizedBox(height: 5),
//                               Text(
//                                 '${searchGroupModel.followerCount}-people follow',
//                               ),
//                               const SizedBox(height: 10),
//                               Container(
//                                 height: 35,
//                                 width: double.infinity,
//                                 decoration: BoxDecoration(
//                                   color: PRIMARY_COLOR,
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 child: TextButton(
//                                   onPressed: () {
//                                     controller
//                                         .followPage(allPagesModel.id ?? '');
//                                   },
//                                   child: const Text(
//                                     'Follow',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ))
//           ],
//         ),
//       ),
//     );
//   }
// }
