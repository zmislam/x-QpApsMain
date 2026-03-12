import 'package:flutter/material.dart';
import '../../../../../../../config/constants/color.dart';

class PrivacyRow<T> extends StatelessWidget {
  const PrivacyRow({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.child,
  });

  final T value;
  final T groupValue;
  final void Function(T?) onChanged;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: child),
        Radio<T>(
          value: value,
          activeColor: PRIMARY_COLOR,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
