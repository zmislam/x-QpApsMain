import 'package:flutter/material.dart';
import '../../../enum/live_post_type_enum.dart';

class LiveShareSelectionWidget extends StatefulWidget {
  final Function(LivePostTypeEnum) onSelected;
  const LiveShareSelectionWidget({super.key, required this.onSelected});

  @override
  State<LiveShareSelectionWidget> createState() => _LiveShareSelectionWidgetState();
}

class _LiveShareSelectionWidgetState extends State<LiveShareSelectionWidget> {
  LivePostTypeEnum? selectedType;

  void _selectType(LivePostTypeEnum type) {
    setState(() {
      selectedType = type;
    });
    widget.onSelected(type);
  }

  @override
  void initState() {
    // TODO: implement initState
    selectedType = LivePostTypeEnum.ON_TIMELINE;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Map<LivePostTypeEnum, String> labels = {
      LivePostTypeEnum.ON_TIMELINE: 'Timeline',
      LivePostTypeEnum.ON_REELS: 'Reels',
      LivePostTypeEnum.ON_BOTH: 'Both',
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: LivePostTypeEnum.values.map((type) {
        final bool isSelected = selectedType == type;
        return GestureDetector(
          onTap: () => _selectType(type),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: isSelected
                ? Chip(label: Text(labels[type]!),backgroundColor: Colors.transparent,color: const WidgetStatePropertyAll(Colors.white12),padding: EdgeInsets.zero,)
                : Text(
              labels[type]!,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        );
      }).toList(),
    );
  }
}
