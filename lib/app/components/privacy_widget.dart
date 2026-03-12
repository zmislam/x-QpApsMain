import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../data/privacy_local_data.dart';
import '../models/privacy_local_model.dart';
import '../config/constants/color.dart';

class PrivacyWidget extends StatelessWidget {
  const PrivacyWidget({
    required this.onChanged,
    super.key,
    this.verticalPadding = 10,
    this.horizontalPadding = 20,
    this.hintText = 'Select privacy',
    this.selectedPrivacy,
  });

  final PrivacyLocalModel? selectedPrivacy;
  final void Function(PrivacyLocalModel? selectedPrivacy) onChanged;
  final double verticalPadding;
  final double horizontalPadding;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<PrivacyLocalModel>(
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          hintText: hintText,
          contentPadding: EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: horizontalPadding,
          ),
        ),
      ),
      items: PrivacyLocalData.privacyList,
      selectedItem: selectedPrivacy,
      onChanged: onChanged,
      popupProps: PopupProps.bottomSheet(
        fit: FlexFit.loose,
        showSearchBox: false,
        // ============================================ Popup Top
        bottomSheetProps: const BottomSheetProps(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: PRIMARY_COLOR),
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ),
          ),
          elevation: 4,
        ),
        itemBuilder: (context, item, isSelected) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 50.0,
                  spreadRadius: 5.0,
                  offset: Offset(0, 5),
                ),
              ],
              borderRadius: BorderRadius.circular(4),
            ),
            child: ListTile(
              leading: item.icon,
              title: Text(item.name),
              selected: isSelected,
            ),
          );
        },
      ),
    );
  }
}
