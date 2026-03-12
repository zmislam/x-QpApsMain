import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileTile extends StatelessWidget {
  final String company;
  final String designation;
  final Widget icon;

  const ProfileTile({super.key, required this.company, required this.designation, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        children: [
          ListTile(
            leading: icon, //Icon(Icons.business_center),
            title: RichText(
              text: TextSpan(
                text: designation.tr,
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: company.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
