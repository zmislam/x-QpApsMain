import 'package:flutter/material.dart';
import '../../../../../../components/button.dart';
import 'package:get/get.dart';

class CustomDropdownBottomSheet extends StatelessWidget {
  final String title;
  final List<String> items;
  final String? initialValue;
  final Function(String) onItemSelected;

  const CustomDropdownBottomSheet({
    Key? key,
    required this.title,
    required this.items,
    this.initialValue,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: _DropdownBottomSheet(
        title: title,
        items: items,
        initialValue: initialValue ?? (items.isNotEmpty ? items.first : ''),
        onItemSelected: onItemSelected,
      ),
    );
  }
}

class _DropdownBottomSheet extends StatefulWidget {
  final String title;
  final List<String> items;
  final String initialValue;
  final Function(String) onItemSelected;

  const _DropdownBottomSheet({
    required this.title,
    required this.items,
    required this.initialValue,
    required this.onItemSelected,
  });

  @override
  _DropdownBottomSheetState createState() => _DropdownBottomSheetState();
}

class _DropdownBottomSheetState extends State<_DropdownBottomSheet> {
  String selectedValue = '';
  TextEditingController searchController = TextEditingController();
  List<String> filteredItems = [];

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
    filteredItems = widget.items;
  }

  void filterList(String query) {
    setState(() {
      filteredItems = widget.items
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.5,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Text(
                //   widget.title,
                //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                // ),
                // const SizedBox(height: 10),
                // TextField(
                //   controller: searchController,
                //   onChanged: filterList,
                //   decoration: InputDecoration(
                //     hintText: 'Search...'.tr,
                //     prefixIcon: const Icon(Icons.search),
                //   ),
                // ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      String item = filteredItems[index];
                      return ListTile(
                        title: Text(item),
                        onTap: () {
                          setState(() {
                            selectedValue = item;
                          });
                          widget.onItemSelected(item);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    onPressed: () => Navigator.pop(context),
                    text: 'Close'.tr,
                    verticalPadding: 10,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => openBottomSheet(context),
      child: Container(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              selectedValue,
              style: TextStyle(fontSize: 16),
            ),
            const Icon(Icons.arrow_drop_down,
                size: 24), // ✅ Added Dropdown Icon
          ],
        ),
      ),
    );
  }
}

class SearchAbleDropdownBottomSheet<T> extends StatelessWidget {
  final String title;
  final Future<List<T>> Function(String) asyncItems;
  T? selectedItem;
  final void Function(T) onItemSelected;
  final double? heightFactor;

  SearchAbleDropdownBottomSheet({
    Key? key,
    required this.title,
    required this.asyncItems,
    this.selectedItem,
    required this.onItemSelected,
    this.heightFactor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        openBottomSheet(context, heightFactor);
      },
      child: Container(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 15, bottom: 15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (selectedItem ?? '').toString(),
              style: TextStyle(fontSize: 16),
            ),
            const Icon(Icons.arrow_drop_down,
                size: 24), // ✅ Added Dropdown Icon
          ],
        ),
      ),
    );
  }

  void openBottomSheet(
    BuildContext context,
    double? heightFactor
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        Future<List<T>> futureItems = asyncItems('');
        return StatefulBuilder(builder: (context, setState) {
          void onSearchChanged(String query) {
            setState(() {
              futureItems = asyncItems(query);
            });
          }

          return FractionallySizedBox(
            heightFactor: heightFactor?? 0.50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text('Search Here...'.tr,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    onChanged: (query) {
                      onSearchChanged(query);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search...'.tr,
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: FutureBuilder<List<T>>(
                      future: futureItems,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'.tr));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(
                            child: Text('No items found!'.tr),
                          );
                        } else {
                          List<T> items = snapshot.data!;
                          return ListView.separated(
                            shrinkWrap: true,
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 10,
                            ),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: () {
                                    onItemSelected(items[index]);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    items[index].toString(),
                                    style: TextStyle(fontSize: 16),
                                  ));
                            },
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      onPressed: () => Navigator.pop(context),
                      text: 'Close'.tr,
                      verticalPadding: 10,
                    ),
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
