import 'package:flutter/material.dart';

class SelectionChipGroup extends StatefulWidget {
  final List<String> options;
  final TextEditingController controller;
  final Function(String selected)? onSelected;

  const SelectionChipGroup({
    super.key,
    required this.options,
    this.onSelected,
    required this.controller,
  });

  @override
  State<SelectionChipGroup> createState() => _SelectionChipGroupState();
}

class _SelectionChipGroupState extends State<SelectionChipGroup> {
  int? selectedIndex;

  @override
  void initState() {
    if (widget.options.isNotEmpty) {
      if (widget.controller.text.isNotEmpty && widget.options.contains(widget.controller.text)) {
        selectedIndex = widget.options.indexWhere(
          (element) => element.contains(widget.controller.text),
        );
      } else {
        selectedIndex = 0;
      }
      widget.controller.text = widget.options[selectedIndex!];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(widget.options.length, (index) {
        final isSelected = selectedIndex == index;
        return ChoiceChip(
          label: Text(widget.options[index]),
          selected: isSelected,
          onSelected: (_) {
            setState(() => selectedIndex = index);
            widget.onSelected?.call(widget.options[index]);
            widget.controller.text = widget.options[selectedIndex!];
          },
          selectedColor: Theme.of(context).primaryColor,
          labelStyle: TextStyle(
            color: isSelected ? Theme.of(context).colorScheme.onPrimary : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        );
      }),
    );
  }
}
