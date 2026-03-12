import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/constants/color.dart';

class ProductDetailsTab extends StatefulWidget {
  final List<String> tabTitles;
  final List<Widget> tabContents;

  const ProductDetailsTab({
    super.key,
    required this.tabTitles,
    required this.tabContents,
  }) : assert(tabTitles.length == tabContents.length);

  @override
  _ProductDetailsTabState createState() => _ProductDetailsTabState();
}

class _ProductDetailsTabState extends State<ProductDetailsTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: widget.tabTitles.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            // Upper border
            Container(
              color: const Color(0xFFCBC9C9),
            ),

            // Tab bar with dividers and borders
            Row(
              children: List.generate(widget.tabTitles.length * 2 - 1, (index) {
                if (index % 2 == 0) {
                  // Tab item
                  int tabIndex = index ~/ 2;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _tabController.animateTo(tabIndex);
                          _tabController.index = tabIndex;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _tabController.index == tabIndex
                              ? PRIMARY_COLOR
                              : Colors.transparent,
                          border: Border.all(color: const Color(0xFFCBC9C9)),
                        ),
                        child: Center(
                          child: Text(
                            widget.tabTitles[tabIndex].tr,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: _tabController.index == tabIndex
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  // Divider between tabs
                  return Container(
                    height: 48,
                    color: const Color(0xFFCBC9C9),
                  );
                }
              }),
            ),

            // Lower border
            Container(color: const Color(0xFFCBC9C9)),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: widget.tabContents,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
