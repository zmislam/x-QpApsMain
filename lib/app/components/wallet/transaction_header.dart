import 'package:flutter/material.dart';

class TransactionHeader extends StatelessWidget {
  const TransactionHeader(
      {super.key,
      required this.firstTitle,
      required this.secondTitle,
      required this.thirdTitle});

  final String firstTitle;
  final String secondTitle;
  final String thirdTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 50,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              firstTitle,
              style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
          Text(
            secondTitle,
            style: const TextStyle(
                color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 25.0),
            child: Text(
              thirdTitle,
              style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
