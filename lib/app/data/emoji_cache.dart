import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../config/constants/local_storage_key.dart';
import '../models/sticker_emoji_model.dart';

class EmojiCache {
  static final EmojiCache _instance = EmojiCache._privateConstructor();

  factory EmojiCache() {
    return _instance;
  }

  EmojiCache._privateConstructor() {
    _getStorage = GetStorage();
  }

  late final GetStorage _getStorage;

  void saveRecentEmojiSticker({
    required List<StickerEmojiModel> currentList,
    required StickerEmojiModel stickerEmojiModel,
  }) {
    currentList.add(stickerEmojiModel);
    if (currentList.length > 40) {
      currentList.removeLast();
    }

    List<String> jsonList = currentList.map((model) => model.toJson()).toList();
    _getStorage.write(LocalStorageKey.RECENT_EMOJI_DATA_KEY, jsonList);
    debugPrint('emoji sticker list saved!');
  }

  List<StickerEmojiModel> getEmojiStickerList() {
    List<dynamic>? jsonList =
        _getStorage.read<List<dynamic>>(LocalStorageKey.RECENT_EMOJI_DATA_KEY);
    if (jsonList != null) {
      List<StickerEmojiModel> models =
          jsonList.map((json) => StickerEmojiModel.fromJson(json)).toList();
      debugPrint('Retrieved chat list: $models');
      return models;
    } else {
      debugPrint('No chat found!');
      return [];
    }
  }
}
