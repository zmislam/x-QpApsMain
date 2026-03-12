import 'package:flutter/material.dart';
import '../../../../../extension/date_time_extension.dart';
import '../models/buyer_order_tracking_model.dart';

class OrderActivityList extends StatelessWidget {
  final List<OrderTrackingData> activities;

  const OrderActivityList({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          activities.map((activity) => buildActivityRow(activity)).toList(),
    );
  }

  Widget buildActivityRow(OrderTrackingData activity) {
    return ListTile(
      leading: Image(
        image: _getIconForActivity(activity.subtagMessage),
        width: 40,
        height: 40,
        // color: Colors.teal,
      ),
      title: Text(activity.subtagMessage ?? 'No Title'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            activity.message ?? '',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          Text(
            (activity.checkpointTime?.toFormatToReadableDate()??''),
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  AssetImage _getIconForActivity(String? subtagMessage) {
    switch (subtagMessage) {
      case 'Info Received':
        return const AssetImage('assets/icon/buyer_panel/info_received.png');
      case 'In Transit':
        return const AssetImage('assets/icon/buyer_panel/in_transit.png');
      case 'Acceptance scan':
        return const AssetImage('assets/icon/buyer_panel/scan.png');
      case 'Arrival scan':
        return const AssetImage('assets/icon/buyer_panel/arrival_scan.png');
      case 'Departure Scan':
        return const AssetImage('assets/icon/buyer_panel/departure.png');
      case 'Out for Delivery':
        return const AssetImage('assets/icon/buyer_panel/out_for_delivery.png');
      case 'Delivered':
        return const AssetImage('assets/icon/buyer_panel/delivered.png');
      default:
        return const AssetImage('assets/icon/buyer_panel/arrival_region.png');
    }
  }
}
