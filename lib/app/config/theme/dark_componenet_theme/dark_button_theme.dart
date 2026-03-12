import 'package:flutter/material.dart';

import '../../constants/color.dart';
import '../text_theme.dart';

class DarkCustomButtonTheme {
  static const buttonTheme =  ButtonThemeData(
    buttonColor: PRIMARY_COLOR,
    textTheme: ButtonTextTheme.normal,
  );

  static TextButtonThemeData textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      textStyle: AppText.TEXT_BUTTON_TEXT
    ),
  );
  static  ElevatedButtonThemeData elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      textStyle: AppText.BUTTON_TEXT,
      backgroundColor: PRIMARY_COLOR,
      foregroundColor: Colors.white,
    ),
  );
  static  OutlinedButtonThemeData outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: const BorderSide(color: PRIMARY_COLOR),
      textStyle: AppText.TEXT_BUTTON_TEXT,
    ),
  );

  static  IconButtonThemeData iconButtonThemeData = IconButtonThemeData(
    style: IconButton.styleFrom(
      foregroundColor: PRIMARY_COLOR,
    ),
  );
}