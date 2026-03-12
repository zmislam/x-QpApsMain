class PageInfo {
  String? id;
  String? pageName;
  List<String>? category;
  List<String>? friends;
  List<String>? location;
  String? bio;
  String? description;
  String? website;
  String? pageNotification;
  String? mailNotification;
  String? email;
  String? address;
  String? city;
  String? zipCode;
  String? profilePic;
  String? coverPic;
  String? pageUserName;
  String? phoneNumber;
  String? whatsapp;
  String? instagram;
  String? serviceArea;
  String? offer;
  String? language;
  String? privacy;
  bool? peopleCanMessage;
  bool? hideNumberReaction;
  String? inviteFriends;
  String? userId;
  String? status;
  String? ipAddress;
  String? createdBy;
  String? updatedBy;
  String? pageRule;
  String? pageMessage;
  String? pageReaction;
  String? whatsappNumber;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  PageInfo({
    this.id,
    this.pageName,
    this.category,
    this.friends,
    this.location,
    this.bio,
    this.description,
    this.website,
    this.pageNotification,
    this.mailNotification,
    this.email,
    this.address,
    this.city,
    this.zipCode,
    this.profilePic,
    this.coverPic,
    this.pageUserName,
    this.phoneNumber,
    this.whatsapp,
    this.instagram,
    this.serviceArea,
    this.offer,
    this.language,
    this.privacy,
    this.peopleCanMessage,
    this.hideNumberReaction,
    this.inviteFriends,
    this.userId,
    this.status,
    this.ipAddress,
    this.createdBy,
    this.updatedBy,
    this.pageRule,
    this.pageMessage,
    this.pageReaction,
    this.whatsappNumber,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  // fromJson method
  factory PageInfo.fromJson(Map<String, dynamic>? json) {
    if (json == null) return PageInfo();

    return PageInfo(
      id: json['_id'] as String?,
      pageName: json['page_name'] as String?,
      category: json['category'] != null ? List<String>.from(json['category']) : null,
      friends: json['friends'] != null ? List<String>.from(json['friends']) : null,
      location: json['location'] != null ? List<String>.from(json['location']) : null,
      bio: json['bio'] as String?,
      description: json['description'] as String?,
      website: json['website'] as String?,
      pageNotification: json['pageNotification'] as String?,
      mailNotification: json['mailNotification'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      zipCode: json['zip_code'] as String?,
      profilePic: json['profile_pic'] as String?,
      coverPic: json['cover_pic'] as String?,
      pageUserName: json['page_user_name'] as String?,
      phoneNumber: json['phone_number'] as String?,
      whatsapp: json['whatsapp'] as String?,
      instagram: json['instagram'] as String?,
      serviceArea: json['service_area'] as String?,
      offer: json['offer'] as String?,
      language: json['language'] as String?,
      privacy: json['privacy'] as String?,
      peopleCanMessage: json['people_can_message'] as bool?,
      hideNumberReaction: json['hide_number_reaction'] as bool?,
      inviteFriends: json['invite_friends'] as String?,
      userId: json['user_id'] as String?,
      status: json['status'] as String?,
      ipAddress: json['ip_address'] as String?,
      createdBy: json['created_by'] as String?,
      updatedBy: json['update_by'] as String?,
      pageRule: json['page_rule'] as String?,
      pageMessage: json['page_message'] as String?,
      pageReaction: json['page_reaction'] as String?,
      whatsappNumber: json['whatsapp_number'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      v: json['__v'] as int?,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'page_name': pageName,
      'category': category,
      'friends': friends,
      'location': location,
      'bio': bio,
      'description': description,
      'website': website,
      'pageNotification': pageNotification,
      'mailNotification': mailNotification,
      'email': email,
      'address': address,
      'city': city,
      'zip_code': zipCode,
      'profile_pic': profilePic,
      'cover_pic': coverPic,
      'page_user_name': pageUserName,
      'phone_number': phoneNumber,
      'whatsapp': whatsapp,
      'instagram': instagram,
      'service_area': serviceArea,
      'offer': offer,
      'language': language,
      'privacy': privacy,
      'people_can_message': peopleCanMessage,
      'hide_number_reaction': hideNumberReaction,
      'invite_friends': inviteFriends,
      'user_id': userId,
      'status': status,
      'ip_address': ipAddress,
      'created_by': createdBy,
      'update_by': updatedBy,
      'page_rule': pageRule,
      'page_message': pageMessage,
      'page_reaction': pageReaction,
      'whatsapp_number': whatsappNumber,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}
