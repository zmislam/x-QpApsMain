import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../extension/num.dart';
import '../../extension/date_time_extension.dart';
import '../../models/help_model.dart';

class HelpCenterCard extends StatelessWidget {
  const HelpCenterCard({super.key, required this.model});
  final HelpModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 5, bottom: 10),
      margin: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                offset: Offset(0, 2),
                spreadRadius: 0.5)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: Get.width / 2 + 10,
                child: Text('Ticket #${model.id}'.tr,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  height: 25,
                  width: 72,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: model.status == 'solved'
                          ? Colors.green.withValues(alpha: 0.5)
                          : model.status == 'pending'
                              ? Colors.blue.withValues(alpha: 0.5)
                              : Colors.yellow.withValues(alpha: 0.5)),
                  child: Center(
                    child: Text(
                      model.status.toString().capitalizeFirst.toString(),
                      style: TextStyle(
                          fontSize: 10,
                          color: model.status == 'solved'
                              ? Colors.green
                              : model.status == 'pending'
                                  ? Colors.deepPurple
                                  : Colors.red,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                child: Text(
                  model.topics.toString(),
                  maxLines: 1,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Text(
                  (model.createdAt.toString().toFormatToReadableDate()),
                  maxLines: 1,
                  style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
          5.h,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: Get.width - 50,
                child: Text(
                  model.description.toString(),
                  maxLines: 1,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
