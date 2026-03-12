import 'package:flutter/material.dart';

extension SizedBoxExtension on num {
  SizedBox get h => SizedBox(height: toDouble());
  SizedBox get w => SizedBox(width: toDouble());
}

extension DurationExtension on num {
  String get secondToMinSecString {
    int minutes = this ~/ 60;
    int seconds = toInt() % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

extension ToQPFlakes on num {
  String get toQPFlakes {
    return '${this / 1000000000000000000} QP Flakes';
  }
}
