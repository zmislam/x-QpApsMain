import 'package:flutter/material.dart';
import '../../../../../config/constants/color.dart';
import 'package:get/get.dart';

Widget buildStatCard(
    BuildContext context, String title, String amount, String assetPath) {
  return Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Theme.of(context).cardTheme.color,
      borderRadius: BorderRadius.circular(8.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.2),
          spreadRadius: 2,
          blurRadius: 5,
        ),
      ],
    ),
    child: Row(
      children: [
        Image.asset(
          assetPath,
          height: 40,
          width: 40,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.image, color: Colors.grey, size: 40);
          },
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF718EBF),
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

//===============================================Order Card Widget ==================================================//

Widget buildOrderCard({
  required String orderId,
  String? storeName,
  required String quantity,
  required String amount,
  required String status,
  required Color statusColor,
  required Color boxColor,
  required String date,
  required BuildContext context,
}) {
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
        buildOrderDetailRow('Order ID:', orderId,
            valueFontWeight: FontWeight.bold),
        buildOrderDetailRow('Store Name:', storeName ?? ''),
        buildOrderDetailRow('Quantity:', quantity),
        buildOrderDetailRow('Order Amount:', '\$$amount'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
              Text('Order Status:'.tr,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: boxColor,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Text(
                status,
                style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10),
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
                Icon(Icons.calendar_today, size: 14),
                SizedBox(
                  width: 10,
                ),
                Text('Time & Date:'.tr,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ],
            ),
            Text(
              date,
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ],
    ),
  );
}

//===============================================Order Detail Widget ==================================================//
Widget buildOrderDetailRow(String title, String value,
    {FontWeight? valueFontWeight}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
        Text(value,
            style: TextStyle(
                color: title == 'Order ID:' ? PRIMARY_COLOR : null,
                fontSize: 11,
                fontWeight: valueFontWeight ?? FontWeight.normal)),
      ],
    ),
  );
}
