// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class PrimarySearchBar extends StatelessWidget {
  const PrimarySearchBar({
    Key? key,
    this.controller,
    required this.hintText,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
  }) : super(key: key);

  final TextEditingController? controller;
  final String hintText;
  final void Function()? onTap;
  final void Function(String query)? onChanged;
  final void Function(String query)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      backgroundColor:
          WidgetStateProperty.all<Color>(Colors.grey.withValues(alpha: 0.3)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      side: WidgetStateProperty.all(
        const BorderSide(width: 1, color: Colors.grey),
      ),
      controller: controller,
      hintText: hintText,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      elevation: const WidgetStatePropertyAll(0),
    );
  }
}
