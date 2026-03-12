// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

class CreateStoryDataModel {
  String? title;
  String? privacy;
  String? music_id;
  final File file;
  CreateStoryDataModel({
    this.title,
    this.privacy,
    this.music_id,
    required this.file,
  });

  CreateStoryDataModel copyWith({
    String? title,
    String? privacy,
    String? music_id,
    File? file,
  }) {
    return CreateStoryDataModel(
      title: title ?? this.title,
      privacy: privacy ?? this.privacy,
      music_id: music_id ?? this.music_id,
      file: file ?? this.file,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'privacy': privacy,
      'music_id': music_id,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'CreateStoryDataModel(title: $title, privacy: $privacy, music_id: $music_id, file: $file)';
  }
}
