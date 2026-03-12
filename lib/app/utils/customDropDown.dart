import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:get/get.dart';

class CustomDropdown extends StatelessWidget {
  final String title;
  final String selectedValue;
  final List<String> items;
  final String errorText;
  final ValueChanged<String?> onChanged;
  final bool showAsterisk;

  const CustomDropdown({
    super.key,
    required this.title,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    this.errorText = '',
    this.showAsterisk = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Title with optional asterisk ---
        RichText(
          text: TextSpan(
            text: title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            children: [
              if (showAsterisk)
                TextSpan(
                  text: ' *'.tr,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // --- Dropdown container ---
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            border: Border.all(
              color: errorText.isNotEmpty ? Colors.red : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              value: selectedValue,
              hint: Text('Select Item'.tr,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              items: items
                  .map((String item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ))
                  .toList(),
              onChanged: onChanged,
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 16),
                height: 50,
                width: double.infinity,
              ),
              iconStyleData: IconStyleData(
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 45,
                padding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ),

        // --- Error text ---
        if (errorText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 12),
            child: Text(
              errorText,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
