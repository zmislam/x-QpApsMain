import 'package:flutter/material.dart';

import '../../constants/color.dart';
import '../text_theme.dart';
import 'input_decoration_theme.dart';

class InputTheme {

  static InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    floatingLabelStyle: const TextStyle(color: PRIMARY_COLOR),

    // -------------------------- TEXT STYLE --------------------------
    hintStyle: AppText.LABEL,
    labelStyle: AppText.LABEL,
    errorStyle: AppText.ERROR_STYLE,
    prefixStyle: AppText.LABEL,
    suffixStyle: AppText.LABEL,
    counterStyle: AppText.FORM_COUNTER_STYLE,

    // -------------------------- COLOR --------------------------
    focusColor: PRIMARY_COLOR,
    prefixIconColor: WidgetStateColor.resolveWith((states) {
      if(states.contains(WidgetState.focused)) return PRIMARY_COLOR;
      // if(states.contains(WidgetState.error)) return ERROR_BORDER_COLOR;  // Activate Error Color If you need
      return Colors.black45;
    },),
    suffixIconColor: WidgetStateColor.resolveWith((states) {
      if(states.contains(WidgetState.focused)) return PRIMARY_COLOR;
      // if(states.contains(WidgetState.error)) return ERROR_BORDER_COLOR;  // Activate Error Color If you need
      return Colors.black45;
    },),
    iconColor: WidgetStateColor.resolveWith((states) {
      if(states.contains(WidgetState.focused)) return PRIMARY_COLOR;
      // if(states.contains(WidgetState.error)) return ERROR_BORDER_COLOR;  // Activate Error Color If you need
      return Colors.black45;
    },),


    // -------------------------- BORDER --------------------------
    enabledBorder: CustomInputDecorationTheme.ENABLED_BORDER,
    focusedBorder: CustomInputDecorationTheme.FOCUSED_BORDER,
    errorBorder: CustomInputDecorationTheme.ERROR_BORDER,
    focusedErrorBorder: CustomInputDecorationTheme.FOCUSED_ERROR_BORDER,
  );
}
