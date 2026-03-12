import 'package:flutter/material.dart';
import '../../config/constants/color.dart';
import '../../extension/date_time_extension.dart';

class BillHistoryTile extends StatelessWidget {
  const BillHistoryTile({super.key, required this.billHistoryList, this.onTap});

  final billHistoryList;
  final VoidCallback? onTap;

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
              billHistoryList.totalBillAmount?.toStringAsFixed(2) ?? 'N/A',
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              getDynamicFormatedTime(billHistoryList.createdAt ?? ''),
              style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: InkWell(
              onTap: onTap ?? () {},
              child: Container(
                height: 40,
                width: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: billHistoryList?.status == 'unpaid'
                        ? PRIMARY_COLOR
                        : Colors.grey.withValues(alpha: 0.3)),
                child: Center(
                  child: Text(
                    billHistoryList.status?.toString() == 'unpaid'
                        ? 'Pay Now'
                        : 'Paid',
                    style: TextStyle(
                        color: billHistoryList?.status == 'unpaid'
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
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
    return productDateTimeFormat.format(postDateTime);
  }
}
