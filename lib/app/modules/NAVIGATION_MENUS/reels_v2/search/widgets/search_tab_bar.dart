import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_search_controller.dart';

class SearchTabBar extends GetView<ReelsSearchController> {
  const SearchTabBar({super.key});

  static const _tabs = ['Top', 'Reels', 'Sounds', 'Hashtags', 'Creators'];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.searchQuery.value.isEmpty) return const SizedBox();
      return SizedBox(
        height: 44,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          itemCount: _tabs.length,
          itemBuilder: (context, index) {
            return Obx(() {
              final isActive = controller.activeTab.value == index;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => controller.setActiveTab(index),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: isActive ? Colors.white : Colors.grey[900],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _tabs[index],
                      style: TextStyle(
                        color: isActive ? Colors.black : Colors.white70,
                        fontSize: 14,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            });
          },
        ),
      );
    });
  }
}
