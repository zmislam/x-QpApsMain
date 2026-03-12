// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:quantum_possibilities_flutter/app/modules/NAVIGATION_MENUS/buyer_panel/buyer_refund_and_return/controllers/buyer_return_refund_controller.dart';

// class ViewReturnQrBottomSheetContent extends StatelessWidget {
//   // BuyerReturnRefundController returnController = Get.put(BuyerReturnRefundController());
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Align(
//             alignment: Alignment.topRight,
//             child: IconButton(
//               icon: Icon(Icons.close),
//               onPressed: () => Get.back(),
//             ),
//           ),
//           Text(
//             'View Return Details',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 20),
//           Image.asset('assets/qr_code.png', height: 150, width: 150), // Replace with your QR code widget or image
//           SizedBox(height: 20),
//           Text(
//             'Please attach this QR code securely to the outside of your return package. When you drop off your package with the courier, they will scan this code to track your return.',
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//           ),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {
//               // Add functionality to save the QR code
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Color(0xFF00695C),
//               foregroundColor: Colors.white,
//               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             ),
//             child: Text('Save This QR'.tr),
//           ),
//           SizedBox(height: 20),
//           Text(
//             'After booking your return Product Please enter your tracking number below to keep your return on record and receive updates',
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//           ),
//           SizedBox(height: 20),
//           TextField(
//             decoration: InputDecoration(
//               labelText: 'Courier service Name'.tr,
//               hintText: 'FedEx'.tr,
//               border: OutlineInputBorder(),
//               contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//             ),
//           ),
//           SizedBox(height: 10),
//           TextField(
//             decoration: InputDecoration(
//               labelText: 'Tracking number'.tr,
//               hintText: '783408090590'.tr,
//               border: OutlineInputBorder(),
//               contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//             ),
//           ),
//           SizedBox(height: 10),
//           TextField(
//             decoration: InputDecoration(
//               labelText: 'Note'.tr,
//               hintText: '783408090590'.tr,
//               border: OutlineInputBorder(),
//               contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//             ),
//           ),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {
//               // Add functionality to submit the details
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Color(0xFF00695C),
//               foregroundColor: Colors.white,
//               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             ),
//             child: Text('Submit'.tr),
//           ),
//           SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }