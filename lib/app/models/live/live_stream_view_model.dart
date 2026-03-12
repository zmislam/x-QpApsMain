// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class LiveStreamViewModel {
  String? postId;
  String? reelsId;
  List<String>? viewers;
  LiveStreamViewModel({
    this.postId,
    this.reelsId,
    this.viewers,
  });

  LiveStreamViewModel copyWith({
    String? postId,
    String? reelsId,
    List<String>? viewers,
  }) {
    return LiveStreamViewModel(
      postId: postId ?? this.postId,
      reelsId: reelsId ?? this.reelsId,
      viewers: viewers ?? this.viewers,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'post_id': postId,
      'reels_id': reelsId,
      'viewers': viewers,
    };
  }

  factory LiveStreamViewModel.fromMap(Map<String, dynamic> map) {
    return LiveStreamViewModel(
      postId: map['post_id'] != null ? map['post_id'] as String : null,
      reelsId: map['reels_id'] != null ? map['reels_id'] as String : null,
      viewers: map['viewers'] != null
          ? (map['viewers'] as List).map((e) => e.toString()).toList()
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LiveStreamViewModel.fromJson(String source) =>
      LiveStreamViewModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'LiveStreamViewModel(postId: $postId, reelsId: $reelsId, viewers: $viewers)';

  @override
  bool operator ==(covariant LiveStreamViewModel other) {
    if (identical(this, other)) return true;

    return other.postId == postId &&
        other.reelsId == reelsId &&
        listEquals(other.viewers, viewers);
  }

  @override
  int get hashCode => postId.hashCode ^ reelsId.hashCode ^ viewers.hashCode;
}
