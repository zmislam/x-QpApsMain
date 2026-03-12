// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../../../models/friend.dart';
// import '../../../../../components/image.dart';
// import '../../../../../utils/image.dart';
// import '../controller/create_group_post_controller.dart';

// class TagPeople extends GetView<CreateGroupPostController> {
//   const TagPeople({super.key});

//   @override
//   Widget build(BuildContext context) {
//     debugPrint(
//         'friend list ..............${controller.friendController.friendList.value}');

//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(
//           color: Colors.black, //change your color here
//         ),
//         title: const Text(
//           'Tag Friends',
//           style: TextStyle(
//             color: Colors.black,
//           ),
//         ),
//         // backgroundColor: Colors.white,
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(25),
//               color: Colors.grey.withValues(alpha:0.2),
//             ),
//             child: TextFormField(
//               decoration: const InputDecoration(
//                   prefixIcon: Icon(Icons.search),
//                   hintText: 'Search friends'.tr,
//                   hintStyle: TextStyle(fontSize: 15),
//                   border: InputBorder.none),
//               onChanged: (value) {
//                 if (value.isNotEmpty) {
//                   controller.tagPeopleController.value = value;
//                   controller.searchFriendList.value.clear();

//                   controller.searchFriendList.value = controller
//                       .friendController.friendList.value
//                       .where((friendModel) =>
//                           friendModel.friend!.username
//                               .toString()
//                               .toUpperCase()
//                               .contains(value.toString().toUpperCase()) ||
//                           friendModel.friend!.firstName
//                               .toString()
//                               .toUpperCase()
//                               .contains(value.toString().toUpperCase()) ||
//                           friendModel.friend!.lastName
//                               .toString()
//                               .toUpperCase()
//                               .contains(value.toString().toUpperCase()))
//                       .toList();

//                   debugPrint(
//                       'friend controller .....${controller.searchFriendList.value}');
//                 } else {
//                   controller.tagPeopleController.value = '';
//                 }
//               },
//             ),
//           ),
//           Obx(
//             () => Wrap(
//               spacing: 4.0,
//               children: controller.checkFriendList.value
//                   .map((friendModel) => Chip(
//                       backgroundColor: Colors.grey.withValues(alpha:0.4),
//                       onDeleted: () {
//                         controller.checkFriendList.value.remove(friendModel);
//                         controller.checkFriendList.refresh();
//                       },
//                       label: Text(
//                           '${friendModel.friend?.firstName ?? ''} ${friendModel.friend?.lastName ?? ''}')))
//                   .toList(),
//             ),
//           ),
//           Expanded(
//               child: Obx(() => controller.tagPeopleController.value == ''
//                   ? ListView.builder(
//                       shrinkWrap: true,
//                       physics: const ScrollPhysics(),
//                       itemCount:
//                           controller.friendController.friendList.value.length,
//                       itemBuilder: (context, index) {
//                         FriendModel friendModel =
//                             controller.friendController.friendList.value[index];
//                         return Row(
//                           children: [
//                             Padding(
//                               padding:
//                                   const EdgeInsets.only(left: 20.0, top: 10.0),
//                               child: NetworkCircleAvatar(
//                                 imageUrl: getFormatedProfileUrl(
//                                     friendModel.friend?.profilePic ?? ''),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(left: 15.0),
//                               child: Text(
//                                 '${friendModel.friend?.firstName ?? ''} ${friendModel.friend?.lastName ?? ''}',
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                             const Expanded(child: SizedBox()),
//                             Obx(() => Checkbox(
//                                 value: controller.checkFriendList.value
//                                     .contains(friendModel),
//                                 onChanged: (onChanged) {
//                                   if (onChanged == true) {
//                                     controller.checkFriendList.value
//                                         .add(friendModel);
//                                     controller.checkFriendList.refresh();
//                                   } else {
//                                     controller.checkFriendList.value
//                                         .remove(friendModel);
//                                     controller.checkFriendList.refresh();
//                                   }
//                                 }))
//                           ],
//                         );
//                       })
//                   : ListView.builder(
//                       shrinkWrap: true,
//                       physics: const ScrollPhysics(),
//                       itemCount: controller.searchFriendList.value.length,
//                       itemBuilder: (context, index) {
//                         FriendModel friendModel =
//                             controller.searchFriendList.value[index];
//                         return Row(
//                           children: [
//                             Padding(
//                               padding:
//                                   const EdgeInsets.only(left: 20.0, top: 10.0),
//                               child: NetworkCircleAvatar(
//                                 imageUrl: getFormatedProfileUrl(
//                                     friendModel.friend?.profilePic ?? ''),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(left: 15.0),
//                               child: Text(
//                                 '${friendModel.friend?.firstName ?? ''} ${friendModel.friend?.lastName ?? ''}',
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                             const Expanded(child: SizedBox()),
//                             Obx(() => Checkbox(
//                                 value: controller.checkFriendList.value
//                                     .contains(friendModel),
//                                 onChanged: (onChanged) {
//                                   if (onChanged == true) {
//                                     controller.checkFriendList.value
//                                         .add(friendModel);
//                                     controller.checkFriendList.refresh();
//                                   } else {
//                                     controller.checkFriendList.value
//                                         .remove(friendModel);
//                                     controller.checkFriendList.refresh();
//                                   }
//                                 }))
//                           ],
//                         );
//                       }))),
//         ],
//       ),
//     );
//   }
// }
