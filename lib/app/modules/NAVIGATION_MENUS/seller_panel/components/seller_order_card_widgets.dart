import 'package:flutter/material.dart';
import '../../../../config/constants/color.dart';
import 'package:get/get.dart';

Widget buildSellerOrderCard(
    {required String orderId,
    String? productName,
    String? items,
    required String orderAmount,
    required String status,
    required Color statusColor,
    required Color boxColor,
    required String date,
    required BuildContext context}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8.0),
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Theme.of(context).cardTheme.color,
      borderRadius: BorderRadius.circular(8.0),
      boxShadow: [
        BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 2,
            blurRadius: 5),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSellerOrderDetailRow('Order ID:', orderId,
            valueFontWeight: FontWeight.bold),
        buildSellerOrderDetailRow('Product Name:', productName ?? ''),
        buildSellerOrderDetailRow('Order Amount:', '$orderAmount\$   '),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Order Status:'.tr,
                style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: boxColor,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Text(
                status,
                style:
                    TextStyle(color: statusColor, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16),
                SizedBox(
                  width: 10,
                ),
                Text('Time & Date:'.tr,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text(
              date,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget buildSellerOrderBoardCard(
    {required String orderId,
    String? productName,
    String? items,
    required String orderAmount,
    required String status,
    required Color statusColor,
    required Color boxColor,
    required String date,
    required BuildContext context}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8.0),
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Theme.of(context).cardTheme.color,
      borderRadius: BorderRadius.circular(8.0),
      boxShadow: [
        BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 2,
            blurRadius: 5),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSellerOrderDetailRow('Order ID:', orderId,
            valueFontWeight: FontWeight.bold),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Order Items:'.tr,
                style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              child: Text(
                items ?? '0',
                style: TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        buildSellerOrderDetailRow('Order Amount:', '$orderAmount\$   '),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Order Status:'.tr,
                style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: boxColor,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Text(
                status,
                style:
                    TextStyle(color: statusColor, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16),
                SizedBox(
                  width: 10,
                ),
                Text('Time & Date:'.tr,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text(
              date,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ],
    ),
  );
}

//===============================================Order Detail Widget ==================================================//
Widget buildSellerOrderDetailRow(String title, String value,
    {FontWeight? valueFontWeight}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Flexible(
          flex: 3,
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              color: title == 'Order ID:' ? PRIMARY_COLOR : null,
              fontWeight: valueFontWeight ?? FontWeight.normal,
            ),
          ),
        ),
      ],
    ),
  );
}
