import 'package:flutter/material.dart';

import '../../constants/color.dart';

class DarkCustomInputDecorationTheme{
  static const OutlineInputBorder ENABLED_BORDER = OutlineInputBorder(borderSide: BorderSide(width: 1, color: ENABLED_BORDER_COLOR));
  static const OutlineInputBorder FOCUSED_BORDER = OutlineInputBorder(borderSide: BorderSide(width: 1, color: FOCUSED_BORDER_COLOR));
  static const OutlineInputBorder ERROR_BORDER = OutlineInputBorder(borderSide: BorderSide(width: 1, color: ERROR_BORDER_COLOR));
  static const OutlineInputBorder FOCUSED_ERROR_BORDER = OutlineInputBorder(borderSide: BorderSide(width: 1, color: FOCUSED_ERROR_BORDER_COLOR));

}