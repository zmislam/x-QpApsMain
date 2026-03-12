class ManagePageModel {
  ManagePageModel({
    required this.id,
    required this.pageName,
    required this.category,
    required this.bio,
    required this.website,
    required this.email,
    required this.address,
    required this.city,
    required this.zipCode,
    required this.profilePic,
    required this.coverPic,
    required this.pageUserName,
    required this.phoneNumber,
    required this.serviceArea,
    required this.offer,
    required this.language,
    required this.privacy,
    required this.userId,
    required this.pageRule,
    required this.pageMessage,
    required this.pageReaction,
    required this.pagesmedia,
    required this.followerCount,
    required this.likedCount,
  });

  final String? id;
  final String? pageName;
  final List<String> category;
  final String? bio;
  final dynamic website;
  final dynamic email;
  final dynamic address;
  final dynamic city;
  final String? zipCode;
  final String? profilePic;
  final String? coverPic;
  final String? pageUserName;
  final dynamic phoneNumber;
  final dynamic serviceArea;
  final dynamic offer;
  final dynamic language;
  final String? privacy;
  final String? userId;
  final dynamic pageRule;
  final dynamic pageMessage;
  final dynamic pageReaction;
  final List<dynamic> pagesmedia;
  final int? followerCount;
  final int? likedCount;

  ManagePageModel copyWith({
    String? id,
    String? pageName,
    List<String>? category,
    String? bio,
    dynamic website,
    dynamic email,
    dynamic address,
    dynamic city,
    String? zipCode,
    String? profilePic,
    String? coverPic,
    String? pageUserName,
    dynamic phoneNumber,
    dynamic serviceArea,
    dynamic offer,
    dynamic language,
    String? privacy,
    String? userId,
    dynamic pageRule,
    dynamic pageMessage,
    dynamic pageReaction,
    List<dynamic>? pagesmedia,
    int? followerCount,
    int? likedCount,
  }) {
    return ManagePageModel(
      id: id ?? this.id,
      pageName: pageName ?? this.pageName,
      category: category ?? this.category,
      bio: bio ?? this.bio,
      website: website ?? this.website,
      email: email ?? this.email,
      address: address ?? this.address,
      city: city ?? this.city,
      zipCode: zipCode ?? this.zipCode,
      profilePic: profilePic ?? this.profilePic,
      coverPic: coverPic ?? this.coverPic,
      pageUserName: pageUserName ?? this.pageUserName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      serviceArea: serviceArea ?? this.serviceArea,
      offer: offer ?? this.offer,
      language: language ?? this.language,
      privacy: privacy ?? this.privacy,
      userId: userId ?? this.userId,
      pageRule: pageRule ?? this.pageRule,
      pageMessage: pageMessage ?? this.pageMessage,
      pageReaction: pageReaction ?? this.pageReaction,
      pagesmedia: pagesmedia ?? this.pagesmedia,
      followerCount: followerCount ?? this.followerCount,
      likedCount: likedCount ?? this.likedCount,
    );
  }

  factory ManagePageModel.fromMap(Map<String, dynamic> json) {
    return ManagePageModel(
      id: json['_id'],
      pageName: json['page_name'],
      category: json['category'] == null
          ? []
          : List<String>.from(json['category']!.map((x) => x)),
      bio: json['bio'],
      website: json['website'],
      email: json['email'],
      address: json['address'],
      city: json['city'],
      zipCode: json['zip_code'],
      profilePic: json['profile_pic'],
      coverPic: json['cover_pic'],
      pageUserName: json['page_user_name'],
      phoneNumber: json['phone_number'],
      serviceArea: json['service_area'],
      offer: json['offer'],
      language: json['language'],
      privacy: json['privacy'],
      userId: json['user_id'],
      pageRule: json['page_rule'],
      pageMessage: json['page_message'],
      pageReaction: json['page_reaction'],
      pagesmedia: json['pagesmedia'] == null
          ? []
          : List<dynamic>.from(json['pagesmedia']!.map((x) => x)),
      followerCount: json['followerCount'],
      likedCount: json['likedCount'],
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'page_name': pageName,
        'category': category.map((x) => x).toList(),
        'bio': bio,
        'website': website,
        'email': email,
        'address': address,
        'city': city,
        'zip_code': zipCode,
        'profile_pic': profilePic,
        'cover_pic': coverPic,
        'page_user_name': pageUserName,
        'phone_number': phoneNumber,
        'service_area': serviceArea,
        'offer': offer,
        'language': language,
        'privacy': privacy,
        'user_id': userId,
        'page_rule': pageRule,
        'page_message': pageMessage,
        'page_reaction': pageReaction,
        'pagesmedia': pagesmedia.map((x) => x).toList(),
        'followerCount': followerCount,
        'likedCount': likedCount,
      };

  @override
  String toString() {
    return '$id, $pageName, $category, $bio, $website, $email, $address, $city, $zipCode, $profilePic, $coverPic, $pageUserName, $phoneNumber, $serviceArea, $offer, $language, $privacy, $userId, $pageRule, $pageMessage, $pageReaction, $pagesmedia, $followerCount, $likedCount, ';
  }
}
