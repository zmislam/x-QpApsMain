// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:quantum_possibilities_flutter/app/modules/NAVIGATION_MENUS/home/create_story/sub_menus/add_audio/models/audio_model.dart';
import 'package:quantum_possibilities_flutter/app/modules/NAVIGATION_MENUS/reels/sub_menu/create_reels/model/reels_emoji_model.dart';
import 'package:quantum_possibilities_flutter/app/modules/NAVIGATION_MENUS/reels/sub_menu/create_reels/model/reels_text_model.dart';

class ReelsDataModel {
  ReelsTextModel? reelsTextModel;
  ReelsEmojiModel? reelsEmojiModel;
  AudioModel? audioModel;
  String? video_thumbnail;
  ReelsDataModel({
    this.reelsTextModel,
    this.reelsEmojiModel,
    this.audioModel,
    this.video_thumbnail,
  });

  ReelsDataModel copyWith({
    ReelsTextModel? reelsTextModel,
    ReelsEmojiModel? reelsEmojiModel,
    AudioModel? audioModel,
    String? video_thumbnail,
  }) {
    return ReelsDataModel(
      reelsTextModel: reelsTextModel ?? this.reelsTextModel,
      reelsEmojiModel: reelsEmojiModel ?? this.reelsEmojiModel,
      audioModel: audioModel ?? this.audioModel,
      video_thumbnail: video_thumbnail ?? this.video_thumbnail,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reelsTextModel': reelsTextModel?.toMap(),
      'reelsEmojiModel': reelsEmojiModel?.toMap(),
      'audioModel': audioModel?.toMap(),
      'video_thumbnail': video_thumbnail,
    };
  }

  factory ReelsDataModel.fromMap(Map<String, dynamic> map) {
    return ReelsDataModel(
      reelsTextModel: map['reelsTextModel'] != null ? ReelsTextModel.fromMap(map['reelsTextModel'] as Map<String,dynamic>) : null,
      reelsEmojiModel: map['reelsEmojiModel'] != null ? ReelsEmojiModel.fromMap(map['reelsEmojiModel'] as Map<String,dynamic>) : null,
      audioModel: map['audioModel'] != null ? AudioModel.fromMap(map['audioModel'] as Map<String,dynamic>) : null,
      video_thumbnail: map['video_thumbnail'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReelsDataModel.fromJson(String source) => ReelsDataModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ReelsDataModel(reelsTextModel: $reelsTextModel, reelsEmojiModel: $reelsEmojiModel, audioModel: $audioModel, video_thumbnail: $video_thumbnail)';

  @override
  bool operator ==(covariant ReelsDataModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.reelsTextModel == reelsTextModel &&
      other.reelsEmojiModel == reelsEmojiModel &&
      other.audioModel == audioModel &&
      other.video_thumbnail == video_thumbnail;
  }

  @override
  int get hashCode => reelsTextModel.hashCode ^ reelsEmojiModel.hashCode ^ audioModel.hashCode ^ video_thumbnail.hashCode;
}
