import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomBottomSheet({
  required BuildContext context,
  required VoidCallback onDelete,
  required VoidCallback onReport,
  required bool isAdminOrModerator,
}) {
  showModalBottomSheet(
    context: context,
    // backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Adjust height according to content
          children: [
            isAdminOrModerator == true
                ? ListTile(
                    leading: const Icon(Icons.delete, color: Colors.grey),
                    title: Text('Delete'.tr, style: TextStyle(fontSize: 16)),
                    onTap: () {
                      Navigator.pop(context); // Close bottom sheet
                      onDelete();
                    },
                  )
                : const SizedBox(),
            isAdminOrModerator == true
                ? const Divider(height: 1)
                : const SizedBox(),
            ListTile(
              leading: const Icon(Icons.flag, color: Colors.grey),
              title: Text('Report'.tr, style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context); // Close bottom sheet
                onReport();
              },
            ),
          ],
        ),
      );
    },
  );
}
