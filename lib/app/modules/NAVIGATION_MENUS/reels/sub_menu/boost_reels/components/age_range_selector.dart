import 'package:flutter/material.dart';

import '../../../../../../config/constants/color.dart';
import 'package:get/get.dart';

class AgeRangeSelector extends StatefulWidget {
  final Function(RangeValues) onRangeSelected; // Callback function
  final Function(String) onAgeSelected; // Callback function

  const AgeRangeSelector(
      {super.key,
      required this.onRangeSelected,
      required this.onAgeSelected}); // Constructor

  @override
  _AgeRangeSelectorState createState() => _AgeRangeSelectorState();
}

class _AgeRangeSelectorState extends State<AgeRangeSelector> {
  String selectedOption = 'allAges'; // Default selection
  RangeValues ageRange = const RangeValues(16, 100); // Default age range

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dropdown to select "All Ages" or "Age Range"
        DropdownButton<String>(
          isExpanded: true,
          value: selectedOption,
          items: [
            DropdownMenuItem(value: 'allAges', child: Text('All Ages'.tr)),
            DropdownMenuItem(value: 'ageRange', child: Text('Age Range'.tr)),
          ],
          onChanged: (value) {
            setState(() {
              selectedOption = value!;
            });
            widget.onAgeSelected(value ?? '');
          },
        ),

        const SizedBox(height: 10),

        // Show Range Slider only if "Age Range" is selected
        if (selectedOption == 'ageRange')
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Selected Age Range: ${ageRange.start.round()} - ${ageRange.end.round()}'.tr,
                style: const TextStyle(fontSize: 14, color: Color(0xff344054)),
              ),
              RangeSlider(
                activeColor: PRIMARY_COLOR,
                inactiveColor: PRIMARY_COLOR,
                values: ageRange,
                min: 16.0,
                max: 100,
                divisions: 100,
                labels: RangeLabels(
                  ageRange.start.round().toString(),
                  ageRange.end.round().toString(),
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    ageRange = values;
                  });
                  widget.onRangeSelected(values); // Pass values to parent
                },
              ),
            ],
          ),
      ],
    );
  }
}
