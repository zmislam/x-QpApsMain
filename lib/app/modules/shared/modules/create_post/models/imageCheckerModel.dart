import 'dart:convert';

class ImageCheckerModel {
  String? message;
  String? data;
  bool? sexual;

  ImageCheckerModel({
    this.message,
    this.data,
    this.sexual,
  });

  ImageCheckerModel copyWith({
    String? message,
    String? data,
    bool? sexual,
  }) =>
      ImageCheckerModel(
        message: message ?? this.message,
        data: data ?? this.data,
        sexual: sexual ?? this.sexual,
      );

  factory ImageCheckerModel.fromRawJson(String str) => ImageCheckerModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ImageCheckerModel.fromJson(Map<String, dynamic> json) => ImageCheckerModel(
    message: json["message"],
    data: json["data"],
    sexual: json["sexual"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data,
    "sexual": sexual,
  };
}
