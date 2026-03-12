import 'package:flutter/material.dart';
import '../../../../../../../components/dropdown.dart';

import '../../../../../../../config/constants/color.dart';
import 'package:get/get.dart';

class PagePrivacy extends StatelessWidget {
  const PagePrivacy({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> lists = ['Everyone', 'Only Me', 'Friend'];
    List<String> list = [
      'On',
      'Off',
    ];
    List<String> items = [
      'Yes',
      'No',
    ];
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        // backgroundColor: Colors.white,
        title: Text(' Page Privacy'.tr,
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        leading: const BackButton(
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              Text('Page Basic information'.tr,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              Text('Who can post on your Page?'.tr,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              PrimaryDropDownField(
                  list: lists, hint: '', onChanged: (changed) {}),
              const SizedBox(
                height: 10,
              ),
              Text('Allow people to message your Page?'.tr,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              PrimaryDropDownField(
                  list: list, hint: '', onChanged: (changed) {}),
              const SizedBox(
                height: 10,
              ),
              Text('Hide number of reactions'.tr,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              PrimaryDropDownField(
                  list: items, hint: '', onChanged: (changed) {}),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: PRIMARY_COLOR,
                    borderRadius: BorderRadius.circular(10)),
                child: TextButton(
                  onPressed: () {},
                  child: Text('Save Changes'.tr,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
