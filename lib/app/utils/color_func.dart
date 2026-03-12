
import 'package:flutter/material.dart';

Color getColorFromHex(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll('#', '');
  if (hexColor.length == 6) {
    hexColor = 'FF$hexColor';
    debugPrint(
        'Your Hex Color IS ::::::::::::::::::::::::::::::::${Color(int.parse(hexColor, radix: 16))}::::::::::::::::::::::::::::');
  }
  return Color(int.parse(hexColor, radix: 16));
}

Map<String, dynamic> getStatusProperties(String? status) {
  switch (status) {
    case 'onprocessing':
      return {
        'displayText': 'Processing',
        'statusColor': const Color(0xFFE46A11),
        'boxColor': const Color(0xFFFDF1E8),
      };
    case 'delivered':
      return {
        'displayText': 'Delivered',
        'statusColor': const Color(0xFF0D894F),
        'boxColor': const Color(0xFFECFDF3),
      };
    case 'refund':
      return {
        'displayText': 'Refunded',
        'statusColor': const Color(0xFFDF9C0B),
        'boxColor': const Color(0xFFFDF9E8),
      };
    case 'canceled':
      return {
        'displayText': 'Canceled',
        'statusColor': const Color(0xFFFF033A),
        'boxColor': const Color(0xFFFFEFEF),
      };
    case 'accepted':
      return {
        'displayText': 'Accepted',
        'statusColor': const Color(0xFF01A4A4),
        'boxColor': const Color(0xFFE5FFFF),
      };
    default:
      return {
        'displayText': 'Pending', //#835101  //#F8DD4E
        'statusColor': const Color(0xFF835101),
        'boxColor': const Color(0xFFF8DD4E),
      };
  }
}

Color getStatusColor(String? status) {
  switch (status?.toLowerCase()) {
    case 'pending':
      return Colors.orange; // Color for pending status
    case 'paid':
      return Colors.green; // Color for paid status
    case 'delivered':
      return Colors.blue; // Color for delivered status
    case 'processing':
      return Colors.purple; // Color for processing status
    default:
      return Colors.grey; // Default color for unknown statuses
  }
}
