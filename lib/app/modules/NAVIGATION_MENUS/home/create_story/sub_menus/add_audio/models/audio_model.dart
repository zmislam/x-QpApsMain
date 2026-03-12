class AudioModel {
  String? id;
  String? audio_file;
  String? thumbnail;
  String? artist_name;
  String? title;
  num? duration;
  bool? isFavorite;
  String? album_name;
  String? createdAt;
  String? updatedAt;
  int? v;
  AudioModel({
    this.id,
    this.audio_file,
    this.thumbnail,
    this.artist_name,
    this.title,
    this.duration,
    this.album_name,
    this.createdAt,
    this.updatedAt,
    this.isFavorite,
    this.v,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'audio_file': audio_file,
      'thumbnail': thumbnail,
      'artist_name': artist_name,
      'title': title,
      'duration': duration,
      'album_name': album_name,
      'isFavorite': album_name,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }

  factory AudioModel.fromMap(Map<String, dynamic> map) {
    return AudioModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      //isFavorite: map['isFavorite'] != null ? map['isFavorite'] as bool : null,
      audio_file:
          map['audio_file'] != null ? map['audio_file'] as String : null,
      thumbnail: map['thumbnail'] != null ? map['thumbnail'] as String : null,
      artist_name:
          map['artist_name'] != null ? map['artist_name'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      duration: map['duration'] != null ? map['duration'] as num : null,
      album_name:
          map['album_name'] != null ? map['album_name'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      v: map['__v'] != null ? map['__v'] as int : null,
    );
  }

  @override
  String toString() {
    return 'AudioModel(id: $id, audio_file: $audio_file, thumbnail: $thumbnail, artist_name: $artist_name, title: $title, duration: $duration, album_name: $album_name, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }
}
