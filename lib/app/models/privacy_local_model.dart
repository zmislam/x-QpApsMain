// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class PrivacyLocalModel {
  PrivacyLocalModel({
    required this.name,
    required this.value,
    required this.icon,
  });
  final String name;
  final String value;
  final Widget icon;

  @override
  String toString() => name;
}
