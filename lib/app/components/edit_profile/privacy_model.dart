class PrivacySearchModel {
  String? id;

  String? privacy;

  PrivacySearchModel({
    this.id,
    this.privacy,
  });

  factory PrivacySearchModel.fromJson(Map<String, dynamic> json) {
    return PrivacySearchModel(
      id: json['id'],
      privacy: json['privacy'],
    );
  }

  static List<PrivacySearchModel>? fromJsonList(List list) {
    // if (list == null) return null;
    return list.map((item) => PrivacySearchModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsPublic() {
    return privacy ?? 'public';
  }

  ///this method will prevent the override of toString
  bool userFilterByCreationDate(String filter) {
    return privacy.toString().contains(filter);
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(PrivacySearchModel privacySearchModel) {
    return id == privacySearchModel.id;
  }

  @override
  String toString() => privacy ?? '';
}
