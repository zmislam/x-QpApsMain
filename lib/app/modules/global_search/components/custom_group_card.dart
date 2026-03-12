import 'package:flutter/material.dart';
import '../../../config/constants/app_assets.dart';
import '../../../config/constants/color.dart';
import 'package:get/get.dart';

class CustomGroupCard extends StatelessWidget {
  final String groupCoverUrl;
  final String groupName;
  final String groupPrivacy;
  final int joinedGroupsCount;
  final String groupDescription;
  final String groupId;
  final String defaultImage;

  final VoidCallback onTap;

  // Constructor for receiving dynamic values
  const CustomGroupCard({
    super.key,
    required this.groupCoverUrl,
    required this.groupName,
    required this.groupPrivacy,
    required this.joinedGroupsCount,
    required this.groupDescription,
    required this.groupId,
    this.defaultImage = AppAssets.DEFAULT_IMAGE,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with error handling and customizable cover image URL
            Expanded(
              child: Image(
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    defaultImage,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                },
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                image: NetworkImage(groupCoverUrl),
              ),
            ),
            const SizedBox(height: 5),
            // Group Name
            Text(
              groupName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            // Group Privacy and Member Count
            Text('$groupPrivacy Group - $joinedGroupsCount Members'.tr,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            // Group Description
            Text(
              groupDescription,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            // View Group Button
            Container(
              height: 35,
              width: double.infinity,
              decoration: BoxDecoration(
                color: PRIMARY_COLOR,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: onTap,
                child: Text('View Group'.tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
