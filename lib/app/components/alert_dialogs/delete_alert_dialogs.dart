import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/constants/color.dart';

/// Facebook-style delete confirmation dialog.
///
/// Clean minimal design with centered text and Cancel/Delete text buttons.
Future<void> showDeleteAlertDialogs({
  required BuildContext context,
  String? title,
  String? subTitleLineOne,
  String? deletingItemType,
  String? subTitleLineTwo,
  required Function onDelete,
  required Function onCancel,
}) async {
  final itemName = deletingItemType?.toLowerCase() ?? 'comment';
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      actionsPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title ?? 'Delete ${itemName.capitalizeFirst}',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            subTitleLineOne ??
                'Are you sure that you want to permanently remove this $itemName?',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
        ],
      ),
      actions: [
        const Divider(height: 1, thickness: 0.5),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => onCancel(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    'Cancel'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: PRIMARY_COLOR,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Container(width: 0.5, height: 44, color: Colors.grey.shade300),
            Expanded(
              child: InkWell(
                onTap: () => onDelete(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    'Delete'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.red.shade400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
