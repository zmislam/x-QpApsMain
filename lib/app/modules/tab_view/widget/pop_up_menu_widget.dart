import 'package:flutter/material.dart';
import '../../../config/constants/color.dart';

import '../../../config/constants/qp_icons_icons.dart';

class CustomPopupMenu extends StatelessWidget {
  final List<PopupMenuItemData> menuItems;

  const CustomPopupMenu({Key? key, required this.menuItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
        showMenu(
          context: context,
          color: Theme.of(context).cardTheme.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          position: RelativeRect.fromLTRB(
            overlay.size.width - 50, // Position near the top-right
            kToolbarHeight + 20, // Below the app bar
            60,
            0,
          ),
          items: menuItems
              .map((item) => PopupMenuItem(
                    onTap: item.onTap,
                    child: Row(
                      children: [
                        if (item.iconAsset != null)
                          Image.asset(
                            item.iconAsset.toString(),
                            height: 20,
                            width: 20,
                          ),
                        if (item.iconAsset == null) Icon(item.icon, size: 24, color: PRIMARY_COLOR),
                        const SizedBox(width: 10),
                        Text(item.text, style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    ),
                  ))
              .toList(),
        );
      },
      child: CircleAvatar(
        // backgroundColor: Color.fromARGB(255, 223, 252, 252),
        backgroundColor: Theme.of(context).appBarTheme.foregroundColor,
        radius: 15,
        child: Icon(
          QpIcon.add,
          // Icons.search_rounded,
          size: 29,
          color: Theme.of(context).canvasColor,
        ),
      ),
    );
  }
}

class PopupMenuItemData {
  final IconData icon;
  final String? iconAsset;
  final String text;
  final VoidCallback onTap;

  PopupMenuItemData({
    required this.icon,
    required this.text,
    required this.onTap,
    this.iconAsset,
  });
}
