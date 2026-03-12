import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DropdownField extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String?> onChanged;

  const DropdownField({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> privacyOptions = ['public', 'friends', 'only_me'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: DropdownButton<String>(
            value: privacyOptions.contains(value)
                ? value
                : 'public', // Default to 'public' if not valid
            items: privacyOptions.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option.capitalizeFirst
                    .toString()
                    .replaceFirst(RegExp(r'_'), ' ')),
              );
            }).toList(),
            onChanged: onChanged,
            isExpanded: true,
            underline: Container(),
          ),
        ),
      ],
    );
  }
}
