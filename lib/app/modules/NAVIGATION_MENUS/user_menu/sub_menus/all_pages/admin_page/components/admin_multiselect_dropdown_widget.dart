import 'package:flutter/material.dart';

import '../../pages/model/page_friend_model.dart';

class AdminMultiselectDropdownWidget extends StatefulWidget {
  final List<PageFriendmodel> items;
  final String hint;
  final ValueChanged<List<String>> onSelectionChanged;
  const AdminMultiselectDropdownWidget({
    super.key,
    required this.items,
    required this.hint,
    required this.onSelectionChanged,
  });

  @override
  _AdminMultiselectDropdownWidget createState() =>
      _AdminMultiselectDropdownWidget();
}

class _AdminMultiselectDropdownWidget
    extends State<AdminMultiselectDropdownWidget> {
  List<PageFriendmodel> _selectedItems = [];
  bool _isDropdownOpen = false;

  void _onItemTapped(PageFriendmodel item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        _selectedItems.add(item);
      }

      widget.onSelectionChanged(_selectedItems
          .map((item) => item.connectedUserId?.id ?? '')
          .toList());
    });
  }

  void _toggleDropdown() {
    setState(() {
      _isDropdownOpen = !_isDropdownOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _toggleDropdown,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _selectedItems.isEmpty
                      ? Text(widget.hint,
                          style: const TextStyle(color: Colors.grey))
                      : Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: _selectedItems
                              .map((item) => Chip(
                                    // backgroundColor: Colors.white,
                                    label: Text(
                                        (item.connectedUserId?.firstName ??
                                                'Unknown') +
                                            (' ') +
                                            (item.connectedUserId?.lastName ??
                                                'Unknown')),
                                    deleteIcon: const Icon(Icons.clear),
                                    onDeleted: () => _onItemTapped(item),
                                  ))
                              .toList(),
                        ),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        if (_isDropdownOpen) _buildDropdownList(),
      ],
    );
  }

  Widget _buildDropdownList() {
    List<PageFriendmodel> availableItems =
        widget.items.where((item) => !_selectedItems.contains(item)).toList();

    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: ListView(
        shrinkWrap: true,
        children: availableItems.map((item) {
          return ListTile(
            title: Text((item.connectedUserId?.firstName ?? 'Unknown') +
                (' ') +
                (item.connectedUserId?.lastName ?? 'Unknown')),
            onTap: () {
              _onItemTapped(item);
              _toggleDropdown();
            },
          );
        }).toList(),
      ),
    );
  }
}
