import 'package:flutter/material.dart';
import '../../extension/date_time_extension.dart';
import '../../extension/string/string.dart';
import '../../models/educational_work_place.dart';
import '../../config/constants/color.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class OtherEducationalWorkPlaceTile extends StatelessWidget {
  const OtherEducationalWorkPlaceTile({
    super.key,
    this.workIcon,
    required this.model,
  });
  final EducationalWorkPlace model;
  final String? workIcon;
  // AboutController aboutController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 5,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: PRIMARY_COLOR,
              ),
              height: 60,
              width: 60,
              child: model.institute_name != null
                  ? Center(
                      child: Text(
                          model.institute_name?.substring(0, 1).toUpperCase() ??
                              '',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    )
                  : const Icon(
                      Icons.business_center,
                      size: 40,
                      color: Colors.grey,
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    (model.institute_name ?? '').capitalizeFirstOfEach,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  if (model.designation != null)
                    Text(StringExtensions(model.designation!).capitalizeFirst),
                  if (model.startDate != null)
                    Row(
                      children: [
                        Visibility(
                          visible: model.startDate?.isNotEmpty ?? false
                              ? true
                              : false,
                          child: Text(
                            model.startDate
                                .toString()
                                .split('T')[0]
                                .toWorkPlaceDuration(),
                          ),
                        ),
                        Visibility(
                            visible: model.startDate?.isNotEmpty ?? false
                                ? true
                                : false,
                            child: Text(' - '.tr)),
                        Text(
                          model.endDate != null
                              ? model.endDate
                                  .toString()
                                  .split('T')[0]
                                  .toWorkPlaceDuration()
                              : 'Present',
                        ),
                      ],
                    ),
                ],
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
