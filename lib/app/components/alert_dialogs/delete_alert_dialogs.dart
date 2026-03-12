import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/constants/app_assets.dart';

Future<void> showDeleteAlertDialogs({
  required BuildContext context,
  String? title,
  String? subTitleLineOne,
  String? deletingItemType,
  String? subTitleLineTwo,
  required Function onDelete,
  required Function onCancel,
}) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: SizedBox(
        height: 250,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Image(
              height: 50,
              width: 50,
              fit: BoxFit.cover,
              image: AssetImage(AppAssets.DELETE__ICON),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              title ?? 'Delete ${deletingItemType != null ? deletingItemType.toString().capitalizeFirst : 'Post'}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(subTitleLineOne ?? 'Are you sure you want to delete this ${deletingItemType != null ? deletingItemType.toString().toLowerCase() : 'post'} ?'),
            Text(subTitleLineTwo ?? 'This action cannot be undone.'),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    side: const BorderSide(color: Colors.grey, width: 1),
                    // shadowColor: Colors.greenAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    minimumSize: const Size(100, 40), //////// HERE
                  ),
                  onPressed: () async {
                    onCancel();
                  },
                  child: Text('Cancel'.tr,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    minimumSize: const Size(100, 40), //////// HERE
                  ),
                  onPressed: () {
                    onDelete();
                  },
                  child: Text('Delete'.tr, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white)),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
