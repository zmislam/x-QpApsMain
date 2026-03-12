// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:quantum_possibilities_flutter/app/config/constants/app_assets.dart';

import '../models/text_alignment_model.dart';
import '../models/text_style_model.dart';
import 'package:get/get.dart';

class StoryTextData {
  static const double _fontSize = 20;
  static const Color _fontColor = Colors.white;

  static List<Color> get storyTextBackgroundColorList => [
        const Color(0xff607D8B),
        const Color(0xff2DB9B9),
        const Color(0xffF8D000),
        const Color(0xffA9E400),
        const Color(0xff00A3FF),
        const Color(0xff0019FE),
        const Color(0xff1C5A76),
        const Color(0xffF25268),
        const Color(0xffFF6928),
        const Color(0xffEE0000),
      ];

  static List<Color> get storyTextColorList => [
        const Color(0xff000000),
        const Color(0xff0D47A1),
        const Color(0xff1A237E),
        const Color(0xff006064),
        const Color(0xffB71C1C),
        const Color(0xff2DB9B9),
        const Color(0xffF25268),
        const Color(0xffF57F17),
        const Color(0xffF57F17),
        const Color(0xffBF360C),
      ];

  static List<TextStyleModel> get textTyleList => [
        TextStyleModel(
          title: 'Simple'.tr,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: _fontSize,
            color: _fontColor,
          ),
        ),
        TextStyleModel(
          title: 'Clean'.tr,
          style: const TextStyle(
            fontFamily: 'WorkSans',
            fontSize: _fontSize,
            color: _fontColor,
          ),
        ),
        TextStyleModel(
          title: 'Casual'.tr,
          style: const TextStyle(
            fontFamily: 'CourierPrime',
            fontSize: _fontSize,
            color: _fontColor,
          ),
        ),
        TextStyleModel(
          title: 'Poppins'.tr,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: _fontSize,
            color: _fontColor,
          ),
        ),
        TextStyleModel(
          title: 'Fancy'.tr,
          style: const TextStyle(
            fontFamily: 'CedarvilleCursive',
            fontSize: _fontSize,
            color: _fontColor,
          ),
        ),
        TextStyleModel(
          title: 'Headline'.tr,
          style: const TextStyle(
            fontFamily: 'Oswald',
            fontSize: _fontSize,
            color: _fontColor,
          ),
        ),
      ];

  static List<TextAlignmentModel> get textAlignmentList => [
        TextAlignmentModel(
          imagePath: AppAssets.ALIGN_LEFT_ICON,
          textAlignment: TextAlign.left,
        ),
        TextAlignmentModel(
          imagePath: AppAssets.ALIGN_CENTER_ICON,
          textAlignment: TextAlign.center,
        ),
        TextAlignmentModel(
          imagePath: AppAssets.ALIGN_RIGHT_ICON,
          textAlignment: TextAlign.right,
        ),
      ];
}
