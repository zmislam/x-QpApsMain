// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:image_picker/image_picker.dart';

import 'package:quantum_possibilities_flutter/app/modules/NAVIGATION_MENUS/reels/sub_menu/create_reels/model/create_reels_model.dart';

class ReelsRequestDataModel {
  final ReelsDataModel? reelsDataModel;
   XFile? file;
  final String? reels_privacy;
  final double? startTime;
  final double? endTime;
  final String? user_id;

  ReelsRequestDataModel(
    this.reelsDataModel,
    this.file,
    this.reels_privacy,
    this.startTime,
    this.endTime,
    this.user_id,
  );

  ReelsRequestDataModel copyWith({
    ReelsDataModel? reelsDataModel,
    XFile? file,
    String? reels_privacy,
    double? startTime,
    double? endTime,
    String? user_id,
  }) {
    return ReelsRequestDataModel(
      reelsDataModel ?? this.reelsDataModel,
      file ?? this.file,
      reels_privacy ?? this.reels_privacy,
      startTime ?? this.startTime,
      endTime ?? this.endTime,
      user_id ?? this.user_id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reelsDataModel': reelsDataModel?.toMap(),
      // 'file': file?.toMap(),
      'reels_privacy': reels_privacy,
      'startTime': startTime,
      'endTime': endTime,
      'user_id': user_id,
    };
  }

  // factory ReelsRequestDataModel.fromMap(Map<String, dynamic> map) {
  //   return ReelsRequestDataModel(
  //     map['reelsDataModel'] != null ? ReelsDataModel.fromMap(map['reelsDataModel'] as Map<String,dynamic>) : null,
  //     map['file'] != null ? XFile.fromMap(map['file'] as Map<String,dynamic>) : null,
  //     map['reels_privacy'] != null ? map['reels_privacy'] as String : null,
  //     map['startTime'] != null ? map['startTime'] as double : null,
  //     map['endTime'] != null ? map['endTime'] as double : null,
  //     map['user_id'] != null ? map['user_id'] as String : null,
  //   );
  // }

  String toJson() => json.encode(toMap());

  // factory ReelsRequestDataModel.fromJson(String source) => ReelsRequestDataModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReelsRequestDataModel(reelsDataModel: $reelsDataModel, file: $file, reels_privacy: $reels_privacy, startTime: $startTime, endTime: $endTime, user_id: $user_id)';
  }

  @override
  bool operator ==(covariant ReelsRequestDataModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.reelsDataModel == reelsDataModel &&
      other.file == file &&
      other.reels_privacy == reels_privacy &&
      other.startTime == startTime &&
      other.endTime == endTime &&
      other.user_id == user_id;
  }

  @override
  int get hashCode {
    return reelsDataModel.hashCode ^
      file.hashCode ^
      reels_privacy.hashCode ^
      startTime.hashCode ^
      endTime.hashCode ^
      user_id.hashCode;
  }
}
