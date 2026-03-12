// import 'package:drop_down_list/drop_down_list.dart';
// import 'package:drop_down_list/model/selected_list_item.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ProductSelectionDropdown extends StatelessWidget {
//   final List<SelectedListItem> productList;
//   final RxList<SelectedListItem> selectedProducts;

//   ProductSelectionDropdown({
//     Key? key,
//     required this.productList,
//     required this.selectedProducts,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => GestureDetector(
//         onTap: () => _showProductDropdown(context),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Text(
//             selectedProducts.isEmpty
//                 ? 'Select Multi Products'
//                 : '${selectedProducts.length} item(s) selected',
//             style: const TextStyle(fontSize: 16),
//           ),
//         ),
//       ),
//     );
//   }

//   void _showProductDropdown(BuildContext context) {
//     DropDownState(
//       DropDown(
//         bottomSheetTitle: const Text(
//           "Select Products",
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
//         ),
//         submitButtonChild: const Text(
//           'Done',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         clearButtonChild: const Text(
//           'Clear',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         enableMultipleSelection: true,
//         // searchBoxHintText: 'Search...',
//         data: productList,
//         onSelected: (List<dynamic> selectedList) {
//           selectedProducts.value = selectedList.cast<SelectedListItem>();
//         },
//       ),
//     ).showModal(context);
//   }
// }
