import 'package:flutter/material.dart';
import '../../constants/color.dart';
import '../text_theme.dart';

class DarkGenericWidgetTheme {
  static BadgeThemeData badgeThemeData = const BadgeThemeData(
    backgroundColor: PRIMARY_COLOR,
    textStyle: AppText.LABEL,
    textColor: Colors.white,
    // padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5)
  );

  static CardThemeData cardTheme = const CardThemeData(
    color: DARK_BACKGROUND_COLOR_LIGHT,
    elevation: 0,
  );

  static ListTileThemeData listTileThemeData = const ListTileThemeData(tileColor: DARK_SURFACE_COLOR, textColor: Colors.white, iconColor: Colors.white);

  static DividerThemeData dividerThemeData = const DividerThemeData(
    color: DARK_PRIMARY_GREY_DIVIDER_COLOR,
    thickness: 1,
  );

  static IconThemeData iconThemeData = const IconThemeData(color: Colors.white, size: 18);

  static SwitchThemeData switchThemeData = SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith<Color?>(
      (states) {
        if (states.contains(WidgetState.selected)) return PRIMARY_COLOR;
        return null;
      },
    ),

    trackColor: WidgetStateProperty.resolveWith<Color?>(
      (states) {
        if (states.contains(WidgetState.selected)) return BACKGROUND_COLOR;
        return BACKGROUND_COLOR;
      },
    ),

    trackOutlineWidth: WidgetStateProperty.resolveWith<double?>(
      (states) {
        if (states.contains(WidgetState.selected)) return 2;
        return 1;
      },
    ),
    trackOutlineColor: const WidgetStatePropertyAll(PRIMARY_COLOR),

    // User this if you want to make the border color different based on selection State
    // trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((states) {
    //   if(states.contains(WidgetState.selected)) return PRIMARY_COLOR;
    //   return PRIMARY_GREY_DIVIDER_COLOR;
    // },),
  );

  static ProgressIndicatorThemeData progressIndicatorThemeData = const ProgressIndicatorThemeData(
    color: PRIMARY_COLOR,
    linearMinHeight: 4,
    circularTrackColor: Colors.transparent,
    linearTrackColor: PRIMARY_GREY_DIVIDER_COLOR,
    refreshBackgroundColor: BACKGROUND_COLOR,
  );

  static RadioThemeData radioThemeData = RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith<Color?>(
      (states) {
        if (states.contains(WidgetState.selected)) return PRIMARY_COLOR;
        return PRIMARY_GREY_DIVIDER_COLOR;
      },
    ),
  );

  static DatePickerThemeData datePickerThemeData = DatePickerThemeData(
    // backgroundColor: Colors.white,
    elevation: 5,
    shadowColor: Colors.black54,

    // Header (Top Bar)
    headerBackgroundColor: PRIMARY_COLOR,
    headerForegroundColor: Colors.white,
    headerHelpStyle: AppText.HEAD_LINE_4_ON_PRIMARY,

    // Year Selection
    yearStyle: const TextStyle(color: PRIMARY_COLOR, fontSize: 16),

    // Date Selection
    dayStyle: const TextStyle(color: Colors.black, fontSize: 16),
    dayBackgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) return PRIMARY_COLOR;
      return null;
    }),
    dayForegroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) return Colors.white;
      return null;
    }),

    todayBorder: const BorderSide(
      color: PRIMARY_COLOR,
      width: 2,
    ),
    todayForegroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) return Colors.white;
      // if(states.contains(WidgetState.))
      return PRIMARY_COLOR;
    }),
    todayBackgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) return PRIMARY_COLOR;
      return Colors.white;
    }),

    // Action Buttons
    confirmButtonStyle: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(PRIMARY_COLOR),
      foregroundColor: WidgetStateProperty.all(Colors.white),
    ),
    cancelButtonStyle: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(Colors.grey.shade200),
      foregroundColor: WidgetStateProperty.all(Colors.black),
    ),
  );
}
