import 'package:flutter/material.dart';
import '../models/friend_list_model.dart';

class CustomMultiSelectDropdownWidget extends StatefulWidget {
  final List<FriendResultModel> items;
  // final List<FriendModel> items;
  final String hint;
  final ValueChanged<List<String>> onSelectionChanged; // Add this callback

  const CustomMultiSelectDropdownWidget({
    super.key,
    required this.items,
    required this.hint,
    required this.onSelectionChanged, // Include it in the constructor
  });

  @override
  _CustomMultiSelectDropdownWidget createState() =>
      _CustomMultiSelectDropdownWidget();
}

class _CustomMultiSelectDropdownWidget
    extends State<CustomMultiSelectDropdownWidget> {
  final List<FriendResultModel> _selectedItems = [];
  // List<FriendModel> _selectedItems = [];
  bool _isDropdownOpen = false;

  void _onItemTapped(FriendResultModel item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        _selectedItems.add(item);
      }

      // Trigger the callback whenever the selection changes
      widget.onSelectionChanged(
          _selectedItems.map((item) => item.friend?.id ?? '').toList());
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
                                        // (item.fullName?? 'Unknown')),
                                        '${item.friend?.firstName} ${item.friend?.lastName ?? ''}'),
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
    // List<FriendModel> availableItems =
    //     widget.items.where((item) => !_selectedItems.contains(item)).toList();
    List<FriendResultModel> availableItems =
        widget.items.where((item) => !_selectedItems.contains(item)).toList();

    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).cardTheme.color,
      ),
      child: ListView(
        shrinkWrap: true,
        children: availableItems.map((item) {
          return ListTile(
            title: Text((item.friend?.firstName ?? '') +
                (' ') +
                (item.friend?.lastName ?? '')),
            // title: Text((item.fullName ?? 'Unknown')),
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
