// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class CustomSearchDelegate extends SearchDelegate {

//   @override
//   String get searchFieldLabel => 'Search tickets';

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: const Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//           // controller.filterSearch.value = '';
//           // controller.getHelpSupportList();
//         },
//       ),
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, null);
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return _buildSearchResults();
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text('Recent Searches'.tr,
//                   style: TextStyle(fontWeight: FontWeight.bold)),
//               TextButton(
//                 onPressed: () {},
//                 child: const Text('Clear History'.tr),
//               )
//             ],
//           ),
//         ),
//         Expanded(child: _buildSearchResults()),
//       ],
//     );
//   }

//   Widget _buildSearchResults() {
//     return Obx(() {
//       if (controller.helpSupportList.isEmpty) {
//         return const Center(
//           child: Text('No results found'.tr, style: TextStyle(color: Colors.grey)),
//         );
//       }
      
//       return ListView.builder(
//         itemCount: controller.helpSupportList.length,
//         itemBuilder: (context, index) {
//           final ticket = controller.helpSupportList[index];
//           return ListTile(
//             title: Text(ticket.title),
//             subtitle: Text(ticket.description),
//             onTap: () {
//               close(context, null);
//               Get.to(() => HelpSupportDetailsView(ticket.id.toString()));
//             },
//           );
//         },
//       );
//     });
//   }
// }

// // Modified SearchBarWidget to use SearchDelegate
// class SearchBarWidget extends StatelessWidget {
//   const SearchBarWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         showSearch(
//           context: context,
//           delegate: CustomSearchDelegate(),
//         );
//       },
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         child: Container(
//           height: 47.86,
//           decoration: BoxDecoration(
//             color: Colors.grey.withValues(alpha:0.1),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: const Row(
//             children: [
//               Padding(
//                 padding: EdgeInsets.only(left: 15.0, right: 10.0),
//                 child: Icon(Icons.search, color: Colors.grey),
//               ),
//               Text('Search tickets...'.tr, 
//                    style: TextStyle(color: Colors.grey)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }