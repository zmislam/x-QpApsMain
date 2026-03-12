import 'package:flutter/material.dart';

import '../../../components/button.dart';

class AdsCreationNavigationWidget extends StatelessWidget {
  final String? actionTitleOne;
  final String? actionTitleTwo;
  final Color? actionOneBGColor;
  final Color? actionTwoBGColor;
  final Function actionOneOnClick;
  final Function actionTwoOnClick;
  const AdsCreationNavigationWidget({super.key, this.actionTitleOne, this.actionTitleTwo, required this.actionOneOnClick, required this.actionTwoOnClick, this.actionOneBGColor, this.actionTwoBGColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PrimaryButton(
            onPressed: () {
              actionOneOnClick();
            },
            text: actionTitleOne ?? 'Previous',
            backgroundColor: actionOneBGColor ?? Theme.of(context).primaryColor,
            verticalPadding: 15,
            horizontalPadding: 10,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: PrimaryButton(
            onPressed: () {
              actionTwoOnClick();
            },
            backgroundColor: actionTwoBGColor ?? Theme.of(context).primaryColor,
            text: actionTitleTwo ?? 'Next',
            verticalPadding: 15,
            horizontalPadding: 10,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
