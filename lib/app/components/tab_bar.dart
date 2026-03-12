// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:quantum_possibilities_flutter/app/components/image.dart';
import 'package:quantum_possibilities_flutter/app/extension/num.dart';
import 'package:quantum_possibilities_flutter/app/config/constants/color.dart';

class TabItemModel {
  final String title;
  final IconData iconData;
  TabItemModel({
    required this.title,
    required this.iconData,
  });
}

class PrimaryTabBar extends StatelessWidget {
  const PrimaryTabBar({
    super.key,
    required this.tabItemModelList,
  });
  final List<TabItemModel> tabItemModelList;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      labelColor: PRIMARY_COLOR,
      unselectedLabelColor: Colors.black,
      indicatorColor: PRIMARY_COLOR,
      padding: EdgeInsets.zero,
      labelPadding: EdgeInsets.zero,
      tabs: List.generate(tabItemModelList.length, (index) {
        TabItemModel model = tabItemModelList[index];
        return Column(
          children: [
            Icon(model.iconData),
            10.h,
            Text(model.title),
          ],
        );
      }),
    );
  }
}

class ImageTextTabBar extends StatelessWidget {
  const ImageTextTabBar({
    super.key,
    required this.title,
    required this.iconPath,
  });
  final String title;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrimaryAssetImage(
          height: 32,
          width: 32,
          imagePath: iconPath,
        ),
        10.h,
        Text(title),
      ],
    );
  }
}
