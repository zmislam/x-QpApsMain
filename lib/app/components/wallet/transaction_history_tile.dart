import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../extension/date_time_extension.dart';

class TransactionHistoryTile extends StatelessWidget {
  const TransactionHistoryTile(
      {super.key, required this.transactionHistoryModel});

  final  transactionHistoryModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 80,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              transactionHistoryModel.amount?.toStringAsFixed(2) ?? 'N/A',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
          Text(
            getDynamicFormatedTime(transactionHistoryModel.createdAt ?? ''),
            style: const TextStyle(
                color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: Container(
              height: 30,
              width: 79,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: transactionHistoryModel?.type == 'withdraw'
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1)),
              child: Center(
                child: Text(
                  transactionHistoryModel.type?.toString().capitalizeFirst ??
                      'N/A',
                  style: TextStyle(
                      color: transactionHistoryModel?.type == 'withdraw'
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getDynamicFormatedTime(String time) {
    // print("time of date ........."+time);

    DateTime postDateTime;
    if (time.toString() == 'null' || time.isEmpty || time.toString() == '') {
      postDateTime = DateTime.now().toLocal();
    } else {
      postDateTime = DateTime.parse(time).toLocal();
    }
    return postDateTimeFormat.format(postDateTime);
  }
}
