// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:quantum_possibilities_flutter/app/config/constants/app_assets.dart';
import 'package:quantum_possibilities_flutter/app/models/phone_list_model.dart';

import 'package:quantum_possibilities_flutter/app/config/constants/color.dart';
import 'package:get/get.dart';

class OhterContactInfoTile extends StatelessWidget {
  const OhterContactInfoTile({
    super.key,
    this.workIcon,
    required this.model,
  });
  final PhoneListModel model;
  final String? workIcon;
  // AboutController aboutController = Get.find();

  @override
  Widget build(BuildContext context) {
    debugPrint(model.phone);
    return Container(
      margin: const EdgeInsets.only(
        bottom: 5,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: model.phone != null
                  ? Image.asset(
                      AppAssets.USER_PHONE_ICON,
                      width: 40,
                      height: 40,
                      color: PRIMARY_COLOR,
                    )
                  : const Icon(
                      Icons.email_outlined,
                      size: 40,
                      color: PRIMARY_COLOR,
                    ),
            ),
            const SizedBox(width: 20),
            Visibility(
              visible: model.phone != null ? true : false,
              child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.phone ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text('Mobile'.tr),
                        const SizedBox(width: 5),
                        Container(
                          padding: const EdgeInsets.all(
                              5.0), // Add padding inside the container
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey), // Grey border color
                            borderRadius: BorderRadius.circular(
                                20.0), // Optional: rounded corners
                          ),
                          child: Text('Verification Pending'.tr,
                            style: TextStyle(
                              color: Colors.orange, // Yellow text color
                              fontSize: 10.0, // Adjust the font size as needed
                              fontWeight: FontWeight
                                  .normal, // Optional: make the text bold
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Icon(
                    model.privacy.toString() == 'public'
                        ? Icons.public
                        : model.privacy.toString() == 'friends'
                            ? Icons.group
                            : Icons.lock,
                    size: 20,
                    color: ENABLED_BORDER_COLOR),
              ],
            )
          ],
        ),
      ),
    );
  }
}
