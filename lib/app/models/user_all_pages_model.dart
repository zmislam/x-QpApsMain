class UserAllPagesModel {
  final String? message;
  final int? status;
  final int? totalCount;
  final List<PageProfileInfo>? myPages;


  UserAllPagesModel({
    this.message,
    this.status,
    this.totalCount,
    this.myPages,
  });

  // fromJson method to map JSON to UserAllPagesModel
  factory UserAllPagesModel.fromJson(Map<String, dynamic> json) {
    return UserAllPagesModel(
      message: json['message'] as String?,
      status: json['status'] as int?,
      totalCount: json['totalCount'] as int?,
      myPages: json['myPages'] != null
          ? List<PageProfileInfo>.from(
              json['myPages']?.map((x) => PageProfileInfo.fromJson(x)),
            )
          : null,
    );
  }

  // toJson method to map UserAllPagesModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'totalCount': totalCount,
      'myPages': myPages?.map((x) => x.toJson()).toList(),
    };
  }
}

class PageProfileInfo {
  final String? id;
  final String? pageName;
  final List<String>? category;
  final String? bio;
  final String? website;
  final String? email;
  final String? address;
  final String? city;
  final String? zipCode;
  final String? profilePic;
  final String? coverPic;
  final String? pageUserName;
  final String? phoneNumber;
  final String? serviceArea;
  final String? offer;
  final String? language;
  final String? privacy;
  final String? userId;
  final String? pageRule;
  final String? pageMessage;
  final String? pageReaction;
  final List<dynamic>? pagesMedia;
  final int? followerCount;
  final int? likedCount;
   bool isSelected = false;

  PageProfileInfo({
    this.id,
    this.pageName,
    this.category,
    this.bio,
    this.website,
    this.email,
    this.address,
    this.city,
    this.zipCode,
    this.profilePic,
    this.coverPic,
    this.pageUserName,
    this.phoneNumber,
    this.serviceArea,
    this.offer,
    this.language,
    this.privacy,
    this.userId,
    this.pageRule,
    this.pageMessage,
    this.pageReaction,
    this.pagesMedia,
    this.followerCount,
    this.likedCount,
  });

  // fromJson method to map JSON to PageProfileInfo
  factory PageProfileInfo.fromJson(Map<String, dynamic> json) {
    return PageProfileInfo(
      id: json['_id'] as String?,
      pageName: json['page_name'] as String?,
      category: json['category'] != null
          ? List<String>.from(json['category'])
          : null,
      bio: json['bio'] as String?,
      website: json['website'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      zipCode: json['zip_code'] as String?,
      profilePic: json['profile_pic'] as String?,
      coverPic: json['cover_pic'] as String?,
      pageUserName: json['page_user_name'] as String?,
      phoneNumber: json['phone_number'] as String?,
      serviceArea: json['service_area'] as String?,
      offer: json['offer'] as String?,
      language: json['language'] as String?,
      privacy: json['privacy'] as String?,
      userId: json['user_id'] as String?,
      pageRule: json['page_rule'] as String?,
      pageMessage: json['page_message'] as String?,
      pageReaction: json['page_reaction'] as String?,
      pagesMedia: json['pagesmedia'] as List<dynamic>?,
      followerCount: json['followerCount'] as int?,
      likedCount: json['likedCount'] as int?,
    );
  }

  // toJson method to map PageProfileInfo to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'page_name': pageName,
      'category': category,
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
      'pagesmedia': pagesMedia,
      'followerCount': followerCount,
      'likedCount': likedCount,
    };
  }
}
