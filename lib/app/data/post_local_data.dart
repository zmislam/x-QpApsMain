import 'package:flutter/material.dart';

import '../config/constants/app_assets.dart';
import '../models/post_media_layout_model.dart';
import 'package:get/get.dart';


final Map<String, String> privacyOptions = {
  'Public':'public',
  'Friends':'friends',
  'Only Me':'only_me',
};

final Map<String, Map<String, dynamic>> privacyOptionsWithIcon = {
  'public': {'label': 'Public', 'icon': Icons.public},
  'friends': {'label': 'Friends', 'icon': Icons.people},
  'only_me': {'label': 'Only Me', 'icon': Icons.lock},
};

const List<String> privacyList = [
  'Public',
  'Friends',
  'Only Me',
];
const List<String> groupPrivacyList = ['Public', 'Private'];
const List<String> reelsPrivacyList = [
  'Public',
  'Friends',
  'Only Me',
];

const List<String> onOffList = ['Off', 'On'];
const List<String> groupAdminList = ['Admin', 'Moderator', 'Member'];

class PostLocalData {
  PostLocalData._privateConstructor();

  static final PostLocalData _instance = PostLocalData._privateConstructor();

  factory PostLocalData() {
    return _instance;
  }

  static List<PostMediaLayoutModel> get getMediaLayoutTypeList => [
        PostMediaLayoutModel(
          title: 'none',
          iconPath: AppAssets.MEDIA_NO_LAYOUT_ICON,
        ),
        PostMediaLayoutModel(
          title: 'classic',
          iconPath: AppAssets.MEDIA_CLASSIC_LAYOUT_ICON,
        ),
        PostMediaLayoutModel(
          title: 'columns',
          iconPath: AppAssets.MEDIA_COLUMNS_LAYOUT_ICON,
        ),
        PostMediaLayoutModel(
          title: 'banner',
          iconPath: AppAssets.MEDIA_BANNER_LAYOUT_ICON,
        ),
        PostMediaLayoutModel(
          title: 'frame',
          iconPath: AppAssets.MEDIA_FRAME_LAYOUT_ICON,
        ),
      ];
}
