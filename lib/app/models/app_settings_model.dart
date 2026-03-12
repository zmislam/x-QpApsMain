import 'dart:convert';

class AppSettingsModel {
  bool reelsSoundEnable;
  AppSettingsModel({
    this.reelsSoundEnable = false,
  });

  AppSettingsModel copyWith({
    bool? reelsSoundEnable,
  }) {
    return AppSettingsModel(
      reelsSoundEnable: reelsSoundEnable ?? this.reelsSoundEnable,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reelsSoundEnable': reelsSoundEnable,
    };
  }

  factory AppSettingsModel.fromMap(Map<String, dynamic> map) {
    return AppSettingsModel(
      reelsSoundEnable: map['reelsSoundEnable'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppSettingsModel.fromJson(String source) =>
      AppSettingsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AppSettingsModel(reelsSoundEnable: $reelsSoundEnable)';

  @override
  bool operator ==(covariant AppSettingsModel other) {
    if (identical(this, other)) return true;

    return other.reelsSoundEnable == reelsSoundEnable;
  }

  @override
  int get hashCode => reelsSoundEnable.hashCode;
}
