class PageProfileModel {
  PageProfileModel({
    required this.pageDetails,
    required this.pagesMedaiaArr,
    required this.role,
  });

  final PageDetails? pageDetails;
  final List<dynamic> pagesMedaiaArr;
  final String? role;

  PageProfileModel copyWith({
    PageDetails? pageDetails,
    List<dynamic>? pagesMedaiaArr,
    String? role,
  }) {
    return PageProfileModel(
      pageDetails: pageDetails ?? this.pageDetails,
      pagesMedaiaArr: pagesMedaiaArr ?? this.pagesMedaiaArr,
      role: role ?? this.role,
    );
  }

  factory PageProfileModel.fromMap(Map<String, dynamic> json) {
    return PageProfileModel(
      pageDetails: json['pageDetails'] == null
          ? null
          : PageDetails.fromJson(json['pageDetails']),
      pagesMedaiaArr: json['pagesMedaiaArr'] == null
          ? []
          : List<dynamic>.from(json['pagesMedaiaArr']!.map((x) => x)),
      role: json['role'] != null ? json['role'] as String : '',
    );
  }

  Map<String, dynamic> toJson() => {
        'pageDetails': pageDetails?.toJson(),
        'pagesMedaiaArr': pagesMedaiaArr.map((x) => x).toList(),
        'role': role,
      };

  @override
  String toString() {
    return '$pageDetails, $pagesMedaiaArr, $role, ';
  }
}

class PageDetails {
  PageDetails({
    required this.id,
    required this.pageName,
    required this.category,
    required this.location,
    required this.bio,
    required this.description,
    required this.website,
    required this.email,
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
    required this.pageMessage,
    required this.pageReaction,
    required this.whatsappNumber,
    required this.pagesmedia,
    required this.followerCount,
    required this.likedCount,
  });

  final String? id;
  final String? pageName;
  final List<String> category;
  final List<String> location;
  final String? bio;
  final dynamic description;
  final String? website;
  final String? email;
  final dynamic city;
  final String? zipCode;
  final String? profilePic;
  final String? coverPic;
  final String? pageUserName;
  final String? phoneNumber;
  final dynamic serviceArea;
  final dynamic offer;
  final dynamic language;
  final String? privacy;
  final String? userId;
  final dynamic pageMessage;
  final dynamic pageReaction;
  final String? whatsappNumber;
  final List<dynamic> pagesmedia;
  final int? followerCount;
  final int? likedCount;

  PageDetails copyWith({
    String? id,
    String? pageName,
    List<String>? category,
    List<String>? location,
    String? bio,
    dynamic description,
    String? website,
    String? email,
    dynamic city,
    String? zipCode,
    String? profilePic,
    String? coverPic,
    String? pageUserName,
    String? phoneNumber,
    dynamic serviceArea,
    dynamic offer,
    dynamic language,
    String? privacy,
    String? userId,
    dynamic pageMessage,
    dynamic pageReaction,
    String? whatsappNumber,
    List<dynamic>? pagesmedia,
    int? followerCount,
    int? likedCount,
  }) {
    return PageDetails(
      id: id ?? this.id,
      pageName: pageName ?? this.pageName,
      category: category ?? this.category,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      description: description ?? this.description,
      website: website ?? this.website,
      email: email ?? this.email,
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
      pageMessage: pageMessage ?? this.pageMessage,
      pageReaction: pageReaction ?? this.pageReaction,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      pagesmedia: pagesmedia ?? this.pagesmedia,
      followerCount: followerCount ?? this.followerCount,
      likedCount: likedCount ?? this.likedCount,
    );
  }

  factory PageDetails.fromJson(Map<String, dynamic> json) {
    return PageDetails(
      id: json['_id'],
      pageName: json['page_name'],
      category: json['category'] == null
          ? []
          : List<String>.from(json['category']!.map((x) => x)),
      location: json['location'] == null
          ? []
          : List<String>.from(json['location']!.map((x) => x)),
      bio: json['bio'],
      description: json['description'],
      website: json['website'],
      email: json['email'],
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
      pageMessage: json['page_message'],
      pageReaction: json['page_reaction'],
      whatsappNumber: json['whatsapp_number'],
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
        'location': location.map((x) => x).toList(),
        'bio': bio,
        'description': description,
        'website': website,
        'email': email,
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
        'page_message': pageMessage,
        'page_reaction': pageReaction,
        'whatsapp_number': whatsappNumber,
        'pagesmedia': pagesmedia.map((x) => x).toList(),
        'followerCount': followerCount,
        'likedCount': likedCount,
      };

  @override
  String toString() {
    return '$id, $pageName, $category, $location, $bio, $description, $website, $email, $city, $zipCode, $profilePic, $coverPic, $pageUserName, $phoneNumber, $serviceArea, $offer, $language, $privacy, $userId, $pageMessage, $pageReaction, $whatsappNumber, $pagesmedia, $followerCount, $likedCount, ';
  }
}
