import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/constants/color.dart';

OutlineInputBorder ENABLED_BORDER = OutlineInputBorder(
    borderSide: const BorderSide(
      width: 1,
      color: ENABLED_BORDER_COLOR,
    ),
    borderRadius: BorderRadius.circular(5));
const OutlineInputBorder FOCUSED_BORDER = OutlineInputBorder(
  borderSide: BorderSide(width: 1, color: FOCUSED_BORDER_COLOR),
);
const OutlineInputBorder PLAIN_WHITE_COLOR = OutlineInputBorder(
  borderSide: BorderSide(width: 1, color: Colors.white),
);
const OutlineInputBorder ERROR_BORDER = OutlineInputBorder(
  borderSide: BorderSide(width: 1, color: ERROR_BORDER_COLOR),
);
const OutlineInputBorder FOCUSED_ERROR_BORDER = OutlineInputBorder(
  borderSide: BorderSide(width: 1, color: FOCUSED_ERROR_BORDER_COLOR),
);

class PrimaryDropDownField extends StatelessWidget {
  const PrimaryDropDownField({Key? key, required this.list, this.validationText, this.hint, required this.onChanged, this.contentPadding = const EdgeInsets.fromLTRB(10, 20, 10, 20), this.value, this.isExpanded}) : super(key: key);

  final List<dynamic> list;
  final String? hint;
  final String? validationText;
  final void Function(String? value) onChanged;
  final String? value;
  final bool? isExpanded;
  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      dropdownColor: Get.theme.cardTheme.color,
      hint: Text(hint ?? ''),
      value: (value == '') ? null : value,
      items: list.map((e) => DropdownMenuItem<String>(value: e.toString(), child: Text('$e'.tr))).toList(),
      onChanged: onChanged,
      isExpanded: isExpanded ?? false,
      decoration: InputDecoration(
        contentPadding: contentPadding,
        enabledBorder: ENABLED_BORDER,
        focusedBorder: FOCUSED_BORDER,
        errorBorder: ERROR_BORDER,
        focusedErrorBorder: FOCUSED_ERROR_BORDER,
      ),
      validator: (value) {
        if ((value ?? '').isEmpty) {
          return validationText;
        } else {
          return null;
        }
      },
    );
  }
}

class PrimaryDropDownFieldExtended<T> extends StatelessWidget {
  const PrimaryDropDownFieldExtended({
    Key? key,
    required this.items,
    this.validationText,
    this.hint,
    required this.onChanged,
    this.contentPadding = const EdgeInsets.fromLTRB(10, 20, 10, 20),
    this.selectedItem,
    required this.displayField,
    required this.valueField,
  }) : super(key: key);

  final List<T> items;
  final String? hint;
  final String? validationText;
  final void Function(T? value) onChanged;
  final T? selectedItem;
  final EdgeInsetsGeometry contentPadding;
  final String Function(T item) displayField;
  final dynamic Function(T item) valueField;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      dropdownColor: Get.theme.cardTheme.color,
      hint: Text(hint ?? ''),
      value: selectedItem,
      items: items
          .map((item) => DropdownMenuItem<T>(
                value: item,
                child: Text(displayField(item)),
              ))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: contentPadding,
        enabledBorder: ENABLED_BORDER,
        focusedBorder: FOCUSED_BORDER,
        errorBorder: ERROR_BORDER,
        focusedErrorBorder: FOCUSED_ERROR_BORDER,
      ),
      validator: (value) {
        if (value == null) {
          return validationText;
        } else {
          return null;
        }
      },
    );
  }
}

class BottomSheetDropdownSearch<T> extends StatefulWidget {
  const BottomSheetDropdownSearch({
    Key? key,
    required this.list,
    this.hint,
    this.validationText,
    required this.onChanged,
    this.selectedItem,
    this.onSearch, // Added search function
  }) : super(key: key);

  final List<T> list;
  final String? hint;
  final String? validationText;
  final void Function(T? object) onChanged;
  final T? selectedItem;
  final Future<List<T>> Function(String searchText)? onSearch;

  @override
  _BottomSheetDropdownSearchState<T> createState() => _BottomSheetDropdownSearchState<T>();
}

class _BottomSheetDropdownSearchState<T> extends State<BottomSheetDropdownSearch<T>> {
  final TextEditingController _searchController = TextEditingController();
  List<T> _items = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _items = widget.list;
  }

  void _onSearchChanged() {
    String searchText = _searchController.text.trim();
    if (widget.onSearch != null) {
      widget.onSearch!(searchText).then((results) {
        setState(() {
          _items = results;
        });
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      selectedItem: widget.selectedItem,
      asyncItems: (String searchText) async {
        return widget.onSearch?.call(searchText) ?? _items;
      },
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          hintText: widget.hint,
          fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      popupProps: PopupProps.bottomSheet(
        showSelectedItems: true,
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          controller: _searchController, // ✅ Attach Controller
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            hintText: 'Search here'.tr,
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
      items: _items,
      itemAsString: (T u) => u.toString(),
      onChanged: widget.onChanged,
    );
  }
}

class SecondaryDropDownField extends StatelessWidget {
  const SecondaryDropDownField({Key? key, required this.list, required this.selectedItem, this.validationText, this.hint, required this.onChanged}) : super(key: key);

  final List<Object> list;
  final Object? selectedItem;
  final String? hint;
  final String? validationText;
  final void Function(Object? value)? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Object>(
      value: selectedItem,
      hint: Text(
        hint ?? '',
        style: const TextStyle(fontSize: 16),
      ),
      items: list.map((e) => DropdownMenuItem<Object>(value: e, child: Text('$e'.tr))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
        enabledBorder: ENABLED_BORDER.copyWith(borderRadius: BorderRadius.circular(10)),
        focusedBorder: FOCUSED_BORDER,
        errorBorder: ERROR_BORDER,
        focusedErrorBorder: FOCUSED_ERROR_BORDER,
      ),
      validator: (value) {
        if (value == null) {
          return validationText;
        } else {
          return null;
        }
      },
    );
  }
}

class BorderlessDropDownField extends StatelessWidget {
  const BorderlessDropDownField({Key? key, required this.list, required this.selectedItem, this.validationText, this.hint, required this.onChanged}) : super(key: key);

  final List<Object> list;
  final Object? selectedItem;
  final String? hint;
  final String? validationText;
  final void Function(Object? value)? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Object>(
      value: selectedItem,
      hint: Text(
        hint ?? '',
        style: const TextStyle(fontSize: 16),
      ),
      items: list.map((e) => DropdownMenuItem<Object>(value: e, child: Text('$e'.tr))).toList(),
      onChanged: onChanged,
      decoration: const InputDecoration(
        fillColor: Colors.white,
        filled: true,
        border: InputBorder.none,
      ),
      validator: (value) {
        if (value == null) {
          return validationText;
        } else {
          return null;
        }
      },
    );
  }
}

class PrimaryDropDownSearch<T> extends StatelessWidget {
  const PrimaryDropDownSearch({
    super.key,
    this.hintText,
    required this.items,
    this.itemBuilder,
    this.onChanged,
    this.asyncItems,
    this.padding = const EdgeInsets.all(10),
  });

  final String? hintText;
  final List<T> items;
  final Widget Function(BuildContext context, T item, bool isSelected)? itemBuilder;
  final void Function(T? item)? onChanged;
  final Future<List<T>> Function(String)? asyncItems;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      asyncItems: asyncItems,
      items: items,
      onChanged: onChanged,
      dropdownButtonProps: DropdownButtonProps(
        padding: padding,
      ),
      dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
        hintText: hintText,
        enabledBorder: ENABLED_BORDER,
        focusedBorder: FOCUSED_BORDER,
        errorBorder: ERROR_BORDER,
        focusedErrorBorder: FOCUSED_ERROR_BORDER,
      )),
      popupProps: PopupProps.bottomSheet(
        fit: FlexFit.loose,
        itemBuilder: itemBuilder,
        showSearchBox: true,
        bottomSheetProps: const BottomSheetProps(
            // backgroundColor: Colors.white,
            ),
      ),
    );
  }
}

class PrimaryDropDownSearchSelect<T> extends StatelessWidget {
  const PrimaryDropDownSearchSelect({
    super.key,
    this.hintText,
    required this.items,
    required this.selectedItem,
    this.itemBuilder,
    this.onChanged,
    this.asyncItems,
    this.padding = const EdgeInsets.all(10),
  });

  final String? hintText;
  final List<T> items;
  final Widget Function(BuildContext context, T item, bool isSelected)? itemBuilder;
  final void Function(T? item)? onChanged;
  final Future<List<T>> Function(String)? asyncItems;
  final EdgeInsetsGeometry padding;
  final T selectedItem;

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      asyncItems: asyncItems,
      items: items,
      onChanged: onChanged,
      dropdownButtonProps: DropdownButtonProps(
        padding: padding,
      ),
      dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
        hintText: hintText,
        enabledBorder: ENABLED_BORDER,
        focusedBorder: FOCUSED_BORDER,
        errorBorder: ERROR_BORDER,
        focusedErrorBorder: FOCUSED_ERROR_BORDER,
      )),
      selectedItem: selectedItem,
      popupProps: PopupProps.bottomSheet(
        fit: FlexFit.loose,
        itemBuilder: itemBuilder,
        showSearchBox: true,
        bottomSheetProps: const BottomSheetProps(
            // backgroundColor: Colors.white,
            ),
      ),
    );
  }
}

class PrimaryDropDownSelectEdit<T> extends StatelessWidget {
  const PrimaryDropDownSelectEdit({
    super.key,
    this.hintText,
    required this.items,
    this.itemBuilder,
    this.onChanged,
    this.asyncItems,
    this.padding = const EdgeInsets.all(10),
  });

  final String? hintText;
  final List<T> items;
  final Widget Function(BuildContext context, T item, bool isSelected)? itemBuilder;
  final void Function(T? item)? onChanged;
  final Future<List<T>> Function(String)? asyncItems;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      asyncItems: asyncItems,
      items: items,
      onChanged: onChanged,
      // dropdownButtonProps: DropdownButtonProps(
      //   padding: padding,
      // ),
      // dropdownDecoratorProps: DropDownDecoratorProps(
      //     dropdownSearchDecoration: InputDecoration(
      //   hintText: hintText,
      //   enabledBorder: ENABLED_BORDER,
      //   focusedBorder: FOCUSED_BORDER,
      //   errorBorder: ERROR_BORDER,
      //   focusedErrorBorder: FOCUSED_ERROR_BORDER,
      // )),
      popupProps: PopupProps.bottomSheet(
        fit: FlexFit.loose,
        itemBuilder: itemBuilder,
        showSearchBox: true,
        bottomSheetProps: const BottomSheetProps(
            // backgroundColor: Colors.white,
            ),
      ),
    );
  }
}

class PrimaryEditDropDownSearch<T> extends StatelessWidget {
  const PrimaryEditDropDownSearch({
    super.key,
    this.hintText,
    required this.items,
    required this.selectedItem,
    this.itemBuilder,
    this.onChanged,
    this.asyncItems,
    this.padding = const EdgeInsets.all(10),
  });

  final String? hintText;
  final List<T> items;
  final Widget Function(BuildContext context, T item, bool isSelected)? itemBuilder;
  final void Function(T? item)? onChanged;
  final Future<List<T>> Function(String)? asyncItems;
  final EdgeInsetsGeometry padding;
  final T selectedItem;

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      asyncItems: asyncItems,
      items: items,
      onChanged: onChanged,
      dropdownButtonProps: DropdownButtonProps(
        padding: padding,
      ),
      selectedItem: selectedItem,
      dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
        hintText: hintText,
        enabledBorder: ENABLED_BORDER,
        focusedBorder: FOCUSED_BORDER,
        errorBorder: ERROR_BORDER,
        focusedErrorBorder: FOCUSED_ERROR_BORDER,
      )),
      popupProps: PopupProps.bottomSheet(
        fit: FlexFit.loose,
        itemBuilder: itemBuilder,
        showSearchBox: true,
        bottomSheetProps: const BottomSheetProps(
            // backgroundColor: Colors.white,
            ),
      ),
    );
  }
}

class BottomSheetDropdownMultiSelect<T> extends StatefulWidget {
  const BottomSheetDropdownMultiSelect({
    Key? key,
    required this.list,
    this.hint,
    this.validationText,
    required this.onChanged,
    this.selectedItems = const [],
    this.onSearch,
    this.itemBuilder,
    this.displayStringForItem,
    this.minLengthForSearch,
  }) : super(key: key);

  final List<T> list;
  final int? minLengthForSearch;
  final String? hint;
  final String? validationText;
  final void Function(List<T> objects) onChanged;
  final List<T> selectedItems;
  final Future<List<T>> Function(String searchText)? onSearch;
  final Widget Function(T item, bool isSelected)? itemBuilder;
  final String Function(T item)? displayStringForItem;

  @override
  _BottomSheetDropdownMultiSelectState<T> createState() => _BottomSheetDropdownMultiSelectState<T>();
}

class _BottomSheetDropdownMultiSelectState<T> extends State<BottomSheetDropdownMultiSelect<T>> {
  late List<T> _filteredList;
  late List<T> _selectedItems;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _filteredList = List.from(widget.list);
    _selectedItems = List.from(widget.selectedItems);
  }

  @override
  void didUpdateWidget(BottomSheetDropdownMultiSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedItems != widget.selectedItems) {
      _selectedItems = List.from(widget.selectedItems);
    }
    if (oldWidget.list != widget.list) {
      _filteredList = List.from(widget.list);
    }
  }

  String _displayStringForItem(T item) {
    if (widget.displayStringForItem != null) {
      return widget.displayStringForItem!(item);
    }
    return item.toString();
  }

  void _toggleItem(T item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        _selectedItems.add(item);
      }
      widget.onChanged(_selectedItems);
    });
  }

  Future<void> _performSearch(String query) async {
    if ((widget.minLengthForSearch ?? 0) > query.length) return;
    setState(() {
      _isSearching = true;
    });

    if (widget.onSearch != null) {
      try {
        final results = await widget.onSearch!(query);
        // * CHECK IF WE ARE MOUNDED
        if (mounted) {
          setState(() {
            _filteredList = results;
            _isSearching = false;
          });
          setState(() {});
        }
      } catch (e) {
        // ! HANDEL ERRORS IF NEEDED
        if (mounted) {
          setState(() {
            _isSearching = false;
          });
        }
      }
    } else {
      setState(() {
        _filteredList = widget.list.where((item) => _displayStringForItem(item).toLowerCase().contains(query.toLowerCase())).toList();
        _isSearching = false;
      });
    }
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.5,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search...'.tr,
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _filteredList = List.from(widget.list);
                                    });
                                  },
                                )
                              : null,
                        ),
                        onChanged: (value) async {
                          // ? NEED TO DETECT IF THE USER HAS STOPPED EDITING
                          // ? NEED TO MINIMISE QUERY COUNT

                          _performSearch(value);
                          // ! UPDATE STATE HAS ISSUE NEEDED TO USE GETX ON THE VIEW PAGE
                          print(_filteredList);
                          setState(() {});
                        },
                      ),
                    ),
                    _isSearching
                        ? const Center(child: CircularProgressIndicator())
                        : Expanded(
                            child: ListView.builder(
                              controller: scrollController,
                              itemCount: _filteredList.length,
                              itemBuilder: (context, index) {
                                final item = _filteredList[index];
                                final isSelected = _selectedItems.contains(item);

                                if (widget.itemBuilder != null) {
                                  return InkWell(
                                    onTap: () {
                                      _toggleItem(item);
                                      setState(() {});
                                    },
                                    child: widget.itemBuilder!(item, isSelected),
                                  );
                                }

                                return ListTile(
                                  title: Text(_displayStringForItem(item)),
                                  trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.green) : const Icon(Icons.circle_outlined),
                                  onTap: () {
                                    _toggleItem(item);
                                    setState(() {});
                                  },
                                );
                              },
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('Close'.tr),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: _showBottomSheet,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade500),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _selectedItems.isEmpty
                      ? Text(
                          widget.hint ?? 'Select items',
                          style: TextStyle(color: Colors.grey.shade600),
                        )
                      : SelectedItemsWrapper(
                          items: _selectedItems,
                          displayStringForItem: _displayStringForItem,
                          onRemove: (item) {
                            _toggleItem(item);
                          },
                        ),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        if (widget.validationText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 12.0),
            child: Text(
              widget.validationText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class SelectedItemsWrapper<T> extends StatelessWidget {
  final List<T> items;
  final String Function(T) displayStringForItem;
  final Function(T) onRemove;

  const SelectedItemsWrapper({
    Key? key,
    required this.items,
    required this.displayStringForItem,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: items.map((item) {
        return Chip(
          label: Text(
            displayStringForItem(item),
            style: const TextStyle(fontSize: 12),
          ),
          deleteIcon: const Icon(Icons.close, size: 16),
          onDeleted: () => onRemove(item),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        );
      }).toList(),
    );
  }
}
