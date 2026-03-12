import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final DateFormat postDateTimeFormat = DateFormat('MMM d, yyyy hh:mm a');
final DateFormat productDateTimeFormat = DateFormat('MMM d, yyyy');
final DateFormat postTimeFormat = DateFormat('hh:mm a');

// Extension on String for Date formatting
extension StringDateExtensions on String? {
  String toFormatDateOfBirth() {
    try {
      final dt = DateTime.parse(this ?? '');
      return DateFormat('MMMM dd, yyyy').format(dt);
    } catch (e) {
      return '';
    }
  }

  String toWorkPlaceDuration() {
    try {
      final dt = DateTime.parse(this ?? '');
      return DateFormat('yyyy MMMM').format(dt);
    } catch (e) {
      return '';
    }
  }

  String toFormatToReadableDate() {
    try {
      final dateTime = DateTime.parse(this ?? '');
      return DateFormat('MMM d, yyyy h:mm a').format(dateTime);
    } catch (e) {
      return '';
    }
  }

  String toDetailFormatDateTime() {
    try {
      final dt = DateTime.parse(this ?? '');
      final formatted = DateFormat('EEE, MMM d, y h:mm a').format(dt);
      debugPrint('Formatted Date: $formatted');
      return formatted;
    } catch (e) {
      debugPrint('Error parsing date: $e');
      return '';
    }
  }

  String toWordlyTimeText() {
    try {
      DateTime postDateTime = DateTime.parse(this!).toLocal();
      DateTime currentDatetime = DateTime.now();
      int millisecondsDifference =
          currentDatetime.millisecondsSinceEpoch - postDateTime.millisecondsSinceEpoch;
      int minutesDifference =
          (millisecondsDifference / Duration.millisecondsPerMinute).truncate();

      if (minutesDifference < 1) {
        return 'a few seconds ago';
      } else if (minutesDifference < 30) {
        return '$minutesDifference minutes ago';
      } else if (DateUtils.isSameDay(postDateTime, currentDatetime)) {
        return 'Today at ${postTimeFormat.format(postDateTime)}';
      } else {
        return postDateTimeFormat.format(postDateTime);
      }
    } catch (e) {
      return '';
    }
  }

  String toFormatInvoiceNumber() {
    if (this == null) return 'No Id';
    final parts = this!.split('-');
    if (parts.length >= 5) {
      return '${parts[0]}-${parts[1]}-${parts[4]}';
    }
    return this!;
  }
  String toFormatDateAndTime(DateTime? dateTime) {
  if (dateTime == null) return 'N/A';
  return DateFormat('MMMM d, yyyy h:mm a').format(dateTime);
}
}

// Extension on DateTime
extension DateTimeExtensions on DateTime? {
  String toFormatDateAndTime() {
    if (this == null) return 'N/A';
    return DateFormat('MMMM d, yyyy h:mm a').format(this!);
  }
}

// Extension on Duration
extension DurationExtensions on Duration {
  String formatAsHMS() {
    int hours = inHours;
    int minutes = inMinutes % 60;
    int seconds = inSeconds % 60;

    String formattedHours = hours.toString().padLeft(2, '0');
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = seconds.toString().padLeft(2, '0');

    return '$formattedHours:$formattedMinutes:$formattedSeconds';
  }
}
