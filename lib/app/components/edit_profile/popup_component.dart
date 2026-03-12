// import 'package:flutter/material.dart';
// import 'package:quantum_possibilities_flutter/app/utils/color.dart';

// class EditProfilePopUpMenu extends StatelessWidget {
//   final VoidCallback? onTapDelete;
//   final VoidCallback? onTapEdit;
//   final Color? color;

//   const EditProfilePopUpMenu({
//     Key? key,
//     this.onTapDelete,
//     this.onTapEdit,
//     this.color,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     List<PopupMenuEntry<String>> menuItems = [];
    
//     if (onTapEdit != null) {
//       menuItems.add(
//         PopupMenuItem<String>(
//           value: 'edit',
//           child: InkWell(
//             onTap: onTapEdit,
//             child: Row(
//               children: [
//                 Icon(Icons.edit, size: 20, color: color??PRIMARY_COLOR), // Replace PRIMARY_COLOR with desired color
//                 SizedBox(width: 8),
//                 Text('Edit'.tr),
//               ],
//             ),
//           ),
//         ),
//       );
//     }

//     if (onTapDelete != null) {
//       menuItems.add(
//         PopupMenuItem<String>(
//           value: 'delete',
//           child: InkWell(
//             onTap: onTapDelete,
//             child: Row(
//               children: [
//                 Icon(Icons.delete, size: 20, color: color??PRIMARY_COLOR), // Replace PRIMARY_COLOR with desired color
//                 SizedBox(width: 8),
//                 Text('Delete'.tr),
//               ],
//             ),
//           ),
//         ),
//       );
//     }

//     return PopupMenuButton<String>(
//       offset: const Offset(-50, 0), // Adjust position to align with edit icon
//       onSelected: (value) {
//         switch (value) {
//           case 'edit':
//             if (onTapEdit != null) onTapEdit!();
//             break;
//           case 'delete':
//             if (onTapDelete != null) onTapDelete!();
//             break;
//         }
//       },
//       itemBuilder: (BuildContext context) => menuItems,
//       icon: const Icon(Icons.more_horiz),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:quantum_possibilities_flutter/app/config/constants/color.dart';
import 'package:get/get.dart';

class EditProfilePopUpMenu extends StatelessWidget {
  final VoidCallback? onTapDelete;
  final VoidCallback? onTapEdit;
  final Color? color;
  // final bool? isEditEnable ;

  const EditProfilePopUpMenu({
    Key? key,
    this.onTapDelete,
    this.onTapEdit,
    this.color,
    // this.isEditEnable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(-50, 0), 
      onSelected: (value) {
        switch (value) {
          case 'edit':
            if (onTapEdit != null) onTapEdit!();
            break;
          case 'delete':
            if (onTapDelete != null) onTapDelete!();
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        List<PopupMenuEntry<String>> menuItems = [];
    
        if (onTapEdit != null) {
          menuItems.add(
            PopupMenuItem<String>(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20, color: color??PRIMARY_COLOR), 
                  const SizedBox(width: 8),
                  Text('Edit'.tr),
                ],
              ),
            ),
          );
        }

        if (onTapDelete != null) {
          menuItems.add(
            PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: color??PRIMARY_COLOR), 
                  const SizedBox(width: 8),
                  Text('Delete'.tr),
                ],
              ),
            ),
          );
        }
        
        return menuItems;
      },
      icon: const Icon(Icons.more_horiz),
    );
  }
}
