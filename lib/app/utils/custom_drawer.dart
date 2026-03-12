import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Custom Drawer Widget
class CustomDrawer extends StatelessWidget {
  final String title;
  final List<DrawerItem> drawerItems;

  const CustomDrawer({
    Key? key,
    required this.title,
    required this.drawerItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // backgroundColor: Colors.white,
      child: Column(
        children: [
          _buildHeader(context),
          const Divider(color: Colors.grey, thickness: 0.5),
          _buildDrawerItems(),
        ],
      ),
    );
  }

  // Header Section of the Drawer
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 12, bottom: 8),
      child: Row(
        children: [
          InkWell(
            onTap: () => Get.back(),
            child: const Icon(
              Icons.arrow_back,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // List of Drawer Items
  Widget _buildDrawerItems() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: drawerItems.length,
        itemBuilder: (context, index) {
          return CustomDrawerTitle(
            iconPath: drawerItems[index].iconPath,
            title: drawerItems[index].title,
            onTap: drawerItems[index].onTap,
          );
        },
      ),
    );
  }
}

// Drawer Item Model
class DrawerItem {
  final String iconPath;
  final String title;
  final VoidCallback onTap;

  DrawerItem({
    required this.iconPath,
    required this.title,
    required this.onTap,
  });
}

// Individual Drawer Item (Tile)
class CustomDrawerTitle extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback onTap;

  const CustomDrawerTitle({
    Key? key,
    required this.iconPath,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        iconPath,
        height: 20,
        width: 20,
      ),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }
}
