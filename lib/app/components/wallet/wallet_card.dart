import 'package:flutter/material.dart';

import '../../config/constants/color.dart';

class WalletCard extends StatelessWidget {
  const WalletCard(
      {super.key,
      required this.iconPath,
      required this.title,
      required this.amount});

  final String iconPath;
  final String title;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            width: 7,
          ),
          Image(
            height: 60,
            width: 60,
            image: AssetImage(
              iconPath,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: APP_BLUE,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Text(
                amount,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          const SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }
}
