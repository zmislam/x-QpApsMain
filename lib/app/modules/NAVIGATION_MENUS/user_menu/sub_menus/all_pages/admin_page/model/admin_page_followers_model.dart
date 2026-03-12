class AdminPageFollowersModel {
  AdminPageFollowersModel({
    required this.id,
    required this.pageId,
    required this.userId,
    required this.followUnfollowStatus,
    required this.likeUnlikeStatus,
    required this.dataStatus,
    required this.ipAddress,
    required this.createdBy,
    required this.updateBy,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? id;
  final PageId? pageId;
  final UserId? userId;
  final int? followUnfollowStatus;
  final int? likeUnlikeStatus;
  final dynamic dataStatus;
  final dynamic ipAddress;
  final dynamic createdBy;
  final dynamic updateBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  AdminPageFollowersModel copyWith({
    String? id,
    PageId? pageId,
    UserId? userId,
    int? followUnfollowStatus,
    int? likeUnlikeStatus,
    dynamic dataStatus,
    dynamic ipAddress,
    dynamic createdBy,
    dynamic updateBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return AdminPageFollowersModel(
      id: id ?? this.id,
      pageId: pageId ?? this.pageId,
      userId: userId ?? this.userId,
      followUnfollowStatus: followUnfollowStatus ?? this.followUnfollowStatus,
      likeUnlikeStatus: likeUnlikeStatus ?? this.likeUnlikeStatus,
      dataStatus: dataStatus ?? this.dataStatus,
      ipAddress: ipAddress ?? this.ipAddress,
      createdBy: createdBy ?? this.createdBy,
      updateBy: updateBy ?? this.updateBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  factory AdminPageFollowersModel.fromMap(Map<String, dynamic> json) {
    return AdminPageFollowersModel(
      id: json['_id'],
      pageId: json['page_id'] == null ? null : PageId.fromMap(json['page_id']),
      userId: json['user_id'] == null ? null : UserId.fromMap(json['user_id']),
      followUnfollowStatus: json['follow_unfollow_status'],
      likeUnlikeStatus: json['like_unlike_status'],
      dataStatus: json['data_status'],
      ipAddress: json['ip_address'],
      createdBy: json['created_by'],
      updateBy: json['update_by'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'page_id': pageId?.toJson(),
        'user_id': userId?.toJson(),
        'follow_unfollow_status': followUnfollowStatus,
        'like_unlike_status': likeUnlikeStatus,
        'data_status': dataStatus,
        'ip_address': ipAddress,
        'created_by': createdBy,
        'update_by': updateBy,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
      };

  @override
  String toString() {
    return '$id, $pageId, $userId, $followUnfollowStatus, $likeUnlikeStatus, $dataStatus, $ipAddress, $createdBy, $updateBy, $createdAt, $updatedAt, $v, ';
  }
}

class PageId {
  PageId({
    required this.id,
    required this.pageName,
    required this.category,
    required this.friends,
    required this.location,
    required this.bio,
    required this.website,
    required this.pageNotification,
    required this.mailNotification,
    required this.email,
    required this.address,
    required this.city,
    required this.zipCode,
    required this.profilePic,
    required this.coverPic,
    required this.pageUserName,
    required this.phoneNumber,
    required this.whatsapp,
    required this.instagram,
    required this.serviceArea,
    required this.offer,
    required this.language,
    required this.privacy,
    required this.peopleCanMessage,
    required this.hideNumberReaction,
    required this.inviteFriends,
    required this.userId,
    required this.status,
    required this.ipAddress,
    required this.createdBy,
    required this.updateBy,
    required this.pageRule,
    required this.pageMessage,
    required this.pageReaction,
    required this.whatsappNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? id;
  final String? pageName;
  final List<String> category;
  final List<dynamic> friends;
  final List<String> location;
  final String? bio;
  final String? website;
  final dynamic pageNotification;
  final dynamic mailNotification;
  final String? email;
  final dynamic address;
  final dynamic city;
  final String? zipCode;
  final String? profilePic;
  final String? coverPic;
  final String? pageUserName;
  final String? phoneNumber;
  final dynamic whatsapp;
  final dynamic instagram;
  final dynamic serviceArea;
  final dynamic offer;
  final dynamic language;
  final String? privacy;
  final bool? peopleCanMessage;
  final bool? hideNumberReaction;
  final dynamic inviteFriends;
  final String? userId;
  final dynamic status;
  final dynamic ipAddress;
  final dynamic createdBy;
  final dynamic updateBy;
  final dynamic pageRule;
  final dynamic pageMessage;
  final dynamic pageReaction;
  final String? whatsappNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  PageId copyWith({
    String? id,
    String? pageName,
    List<String>? category,
    List<dynamic>? friends,
    List<String>? location,
    String? bio,
    String? website,
    dynamic pageNotification,
    dynamic mailNotification,
    String? email,
    dynamic address,
    dynamic city,
    String? zipCode,
    String? profilePic,
    String? coverPic,
    String? pageUserName,
    String? phoneNumber,
    dynamic whatsapp,
    dynamic instagram,
    dynamic serviceArea,
    dynamic offer,
    dynamic language,
    String? privacy,
    bool? peopleCanMessage,
    bool? hideNumberReaction,
    dynamic inviteFriends,
    String? userId,
    dynamic status,
    dynamic ipAddress,
    dynamic createdBy,
    dynamic updateBy,
    dynamic pageRule,
    dynamic pageMessage,
    dynamic pageReaction,
    String? whatsappNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return PageId(
      id: id ?? this.id,
      pageName: pageName ?? this.pageName,
      category: category ?? this.category,
      friends: friends ?? this.friends,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      website: website ?? this.website,
      pageNotification: pageNotification ?? this.pageNotification,
      mailNotification: mailNotification ?? this.mailNotification,
      email: email ?? this.email,
      address: address ?? this.address,
      city: city ?? this.city,
      zipCode: zipCode ?? this.zipCode,
      profilePic: profilePic ?? this.profilePic,
      coverPic: coverPic ?? this.coverPic,
      pageUserName: pageUserName ?? this.pageUserName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      whatsapp: whatsapp ?? this.whatsapp,
      instagram: instagram ?? this.instagram,
      serviceArea: serviceArea ?? this.serviceArea,
      offer: offer ?? this.offer,
      language: language ?? this.language,
      privacy: privacy ?? this.privacy,
      peopleCanMessage: peopleCanMessage ?? this.peopleCanMessage,
      hideNumberReaction: hideNumberReaction ?? this.hideNumberReaction,
      inviteFriends: inviteFriends ?? this.inviteFriends,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      ipAddress: ipAddress ?? this.ipAddress,
      createdBy: createdBy ?? this.createdBy,
      updateBy: updateBy ?? this.updateBy,
      pageRule: pageRule ?? this.pageRule,
      pageMessage: pageMessage ?? this.pageMessage,
      pageReaction: pageReaction ?? this.pageReaction,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  factory PageId.fromMap(Map<String, dynamic> json) {
    return PageId(
      id: json['_id'],
      pageName: json['page_name'],
      category: json['category'] == null
          ? []
          : List<String>.from(json['category']!.map((x) => x)),
      friends: json['friends'] == null
          ? []
          : List<dynamic>.from(json['friends']!.map((x) => x)),
      location: json['location'] == null
          ? []
          : List<String>.from(json['location']!.map((x) => x)),
      bio: json['bio'],
      website: json['website'],
      pageNotification: json['pageNotification'],
      mailNotification: json['mailNotification'],
      email: json['email'],
      address: json['address'],
      city: json['city'],
      zipCode: json['zip_code'],
      profilePic: json['profile_pic'],
      coverPic: json['cover_pic'],
      pageUserName: json['page_user_name'],
      phoneNumber: json['phone_number'],
      whatsapp: json['whatsapp'],
      instagram: json['instagram'],
      serviceArea: json['service_area'],
      offer: json['offer'],
      language: json['language'],
      privacy: json['privacy'],
      peopleCanMessage: json['people_can_message'],
      hideNumberReaction: json['hide_number_reaction'],
      inviteFriends: json['invite_friends'],
      userId: json['user_id'],
      status: json['status'],
      ipAddress: json['ip_address'],
      createdBy: json['created_by'],
      updateBy: json['update_by'],
      pageRule: json['page_rule'],
      pageMessage: json['page_message'],
      pageReaction: json['page_reaction'],
      whatsappNumber: json['whatsapp_number'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'page_name': pageName,
        'category': category.map((x) => x).toList(),
        'friends': friends.map((x) => x).toList(),
        'location': location.map((x) => x).toList(),
        'bio': bio,
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
        'update_by': updateBy,
        'page_rule': pageRule,
        'page_message': pageMessage,
        'page_reaction': pageReaction,
        'whatsapp_number': whatsappNumber,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
      };

  @override
  String toString() {
    return '$id, $pageName, $category, $friends, $location, $bio, $website, $pageNotification, $mailNotification, $email, $address, $city, $zipCode, $profilePic, $coverPic, $pageUserName, $phoneNumber, $whatsapp, $instagram, $serviceArea, $offer, $language, $privacy, $peopleCanMessage, $hideNumberReaction, $inviteFriends, $userId, $status, $ipAddress, $createdBy, $updateBy, $pageRule, $pageMessage, $pageReaction, $whatsappNumber, $createdAt, $updatedAt, $v, ';
  }
}

class UserId {
  UserId({
    required this.country,
    required this.websites,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
    required this.profilePic,
    required this.coverPic,
    required this.userStatus,
    required this.gender,
    required this.religion,
    required this.dateOfBirth,
    required this.userBio,
    required this.language,
    required this.passport,
    required this.lastLogin,
    required this.user2FaStatus,
    required this.secondaryEmail,
    required this.recoveryEmail,
    required this.relationStatus,
    required this.homeTown,
    required this.birthPlace,
    required this.bloodGroup,
    required this.resetPasswordToken,
    required this.resetPasswordTokenExpires,
    required this.userRole,
    required this.status,
    required this.ipAddress,
    required this.createdBy,
    required this.updateBy,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.lockProfile,
    required this.emailList,
    required this.phoneList,
    required this.userAbout,
    required this.userNickname,
    required this.presentTown,
    required this.turnOnEarningDashboard,
    required this.dateOfBirthShowType,
    required this.emailPrivacy,
    required this.isProfileVerified,
    required this.inactivationNote,
  });

  final dynamic country;
  final dynamic websites;
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? email;
  final String? phone;
  final String? password;
  final String? profilePic;
  final dynamic coverPic;
  final dynamic userStatus;
  final String? gender;
  final String? religion;
  final DateTime? dateOfBirth;
  final String? userBio;
  final dynamic language;
  final dynamic passport;
  final String? lastLogin;
  final dynamic user2FaStatus;
  final dynamic secondaryEmail;
  final dynamic recoveryEmail;
  final String? relationStatus;
  final String? homeTown;
  final String? birthPlace;
  final dynamic bloodGroup;
  final String? resetPasswordToken;
  final String? resetPasswordTokenExpires;
  final dynamic userRole;
  final String? status;
  final dynamic ipAddress;
  final dynamic createdBy;
  final dynamic updateBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final String? lockProfile;
  final List<String> emailList;
  final List<dynamic> phoneList;
  final String? userAbout;
  final String? userNickname;
  final String? presentTown;
  final bool? turnOnEarningDashboard;
  final String? dateOfBirthShowType;
  final String? emailPrivacy;
  final bool? isProfileVerified;
  final String? inactivationNote;

  UserId copyWith({
    dynamic country,
    dynamic websites,
    String? id,
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? phone,
    String? password,
    String? profilePic,
    dynamic coverPic,
    dynamic userStatus,
    String? gender,
    String? religion,
    DateTime? dateOfBirth,
    String? userBio,
    dynamic language,
    dynamic passport,
    String? lastLogin,
    dynamic user2FaStatus,
    dynamic secondaryEmail,
    dynamic recoveryEmail,
    String? relationStatus,
    String? homeTown,
    String? birthPlace,
    dynamic bloodGroup,
    String? resetPasswordToken,
    String? resetPasswordTokenExpires,
    dynamic userRole,
    String? status,
    dynamic ipAddress,
    dynamic createdBy,
    dynamic updateBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    String? lockProfile,
    List<String>? emailList,
    List<dynamic>? phoneList,
    String? userAbout,
    String? userNickname,
    String? presentTown,
    bool? turnOnEarningDashboard,
    String? dateOfBirthShowType,
    String? emailPrivacy,
    bool? isProfileVerified,
    String? inactivationNote,
  }) {
    return UserId(
      country: country ?? this.country,
      websites: websites ?? this.websites,
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      profilePic: profilePic ?? this.profilePic,
      coverPic: coverPic ?? this.coverPic,
      userStatus: userStatus ?? this.userStatus,
      gender: gender ?? this.gender,
      religion: religion ?? this.religion,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      userBio: userBio ?? this.userBio,
      language: language ?? this.language,
      passport: passport ?? this.passport,
      lastLogin: lastLogin ?? this.lastLogin,
      user2FaStatus: user2FaStatus ?? this.user2FaStatus,
      secondaryEmail: secondaryEmail ?? this.secondaryEmail,
      recoveryEmail: recoveryEmail ?? this.recoveryEmail,
      relationStatus: relationStatus ?? this.relationStatus,
      homeTown: homeTown ?? this.homeTown,
      birthPlace: birthPlace ?? this.birthPlace,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      resetPasswordToken: resetPasswordToken ?? this.resetPasswordToken,
      resetPasswordTokenExpires:
          resetPasswordTokenExpires ?? this.resetPasswordTokenExpires,
      userRole: userRole ?? this.userRole,
      status: status ?? this.status,
      ipAddress: ipAddress ?? this.ipAddress,
      createdBy: createdBy ?? this.createdBy,
      updateBy: updateBy ?? this.updateBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
      lockProfile: lockProfile ?? this.lockProfile,
      emailList: emailList ?? this.emailList,
      phoneList: phoneList ?? this.phoneList,
      userAbout: userAbout ?? this.userAbout,
      userNickname: userNickname ?? this.userNickname,
      presentTown: presentTown ?? this.presentTown,
      turnOnEarningDashboard:
          turnOnEarningDashboard ?? this.turnOnEarningDashboard,
      dateOfBirthShowType: dateOfBirthShowType ?? this.dateOfBirthShowType,
      emailPrivacy: emailPrivacy ?? this.emailPrivacy,
      isProfileVerified: isProfileVerified ?? this.isProfileVerified,
      inactivationNote: inactivationNote ?? this.inactivationNote,
    );
  }

  factory UserId.fromMap(Map<String, dynamic> json) {
    return UserId(
      country: json['country'],
      websites: json['websites'],
      id: json['_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
      profilePic: json['profile_pic'],
      coverPic: json['cover_pic'],
      userStatus: json['user_status'],
      gender: json['gender'],
      religion: json['religion'],
      dateOfBirth: DateTime.tryParse(json['date_of_birth'] ?? ''),
      userBio: json['user_bio'],
      language: json['language'],
      passport: json['passport'],
      lastLogin: json['last_login'],
      user2FaStatus: json['user_2fa_status'],
      secondaryEmail: json['secondary_email'],
      recoveryEmail: json['recovery_email'],
      relationStatus: json['relation_status'],
      homeTown: json['home_town'],
      birthPlace: json['birth_place'],
      bloodGroup: json['blood_group'],
      resetPasswordToken: json['reset_password_token'],
      resetPasswordTokenExpires: json['reset_password_token_expires'],
      userRole: json['user_role'],
      status: json['status'],
      ipAddress: json['ip_address'],
      createdBy: json['created_by'],
      updateBy: json['update_by'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
      v: json['__v'],
      lockProfile: json['lock_profile'],
      emailList: json['email_list'] == null
          ? []
          : List<String>.from(json['email_list']!.map((x) => x)),
      phoneList: json['phone_list'] == null
          ? []
          : List<dynamic>.from(json['phone_list']!.map((x) => x)),
      userAbout: json['user_about'],
      userNickname: json['user_nickname'],
      presentTown: json['present_town'],
      turnOnEarningDashboard: json['turn_on_earning_dashboard'],
      dateOfBirthShowType: json['date_of_birth_show_type'],
      emailPrivacy: json['email_privacy'],
      isProfileVerified: json['isProfileVerified'],
      inactivationNote: json['inactivation_note'],
    );
  }

  Map<String, dynamic> toJson() => {
        'country': country,
        'websites': websites,
        '_id': id,
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'email': email,
        'phone': phone,
        'password': password,
        'profile_pic': profilePic,
        'cover_pic': coverPic,
        'user_status': userStatus,
        'gender': gender,
        'religion': religion,
        'date_of_birth': dateOfBirth?.toIso8601String(),
        'user_bio': userBio,
        'language': language,
        'passport': passport,
        'last_login': lastLogin,
        'user_2fa_status': user2FaStatus,
        'secondary_email': secondaryEmail,
        'recovery_email': recoveryEmail,
        'relation_status': relationStatus,
        'home_town': homeTown,
        'birth_place': birthPlace,
        'blood_group': bloodGroup,
        'reset_password_token': resetPasswordToken,
        'reset_password_token_expires': resetPasswordTokenExpires,
        'user_role': userRole,
        'status': status,
        'ip_address': ipAddress,
        'created_by': createdBy,
        'update_by': updateBy,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
        'lock_profile': lockProfile,
        'email_list': emailList.map((x) => x).toList(),
        'phone_list': phoneList.map((x) => x).toList(),
        'user_about': userAbout,
        'user_nickname': userNickname,
        'present_town': presentTown,
        'turn_on_earning_dashboard': turnOnEarningDashboard,
        'date_of_birth_show_type': dateOfBirthShowType,
        'email_privacy': emailPrivacy,
        'isProfileVerified': isProfileVerified,
        'inactivation_note': inactivationNote,
      };

  @override
  String toString() {
    return '$country, $websites, $id, $firstName, $lastName, $username, $email, $phone, $password, $profilePic, $coverPic, $userStatus, $gender, $religion, $dateOfBirth, $userBio, $language, $passport, $lastLogin, $user2FaStatus, $secondaryEmail, $recoveryEmail, $relationStatus, $homeTown, $birthPlace, $bloodGroup, $resetPasswordToken, $resetPasswordTokenExpires, $userRole, $status, $ipAddress, $createdBy, $updateBy, $createdAt, $updatedAt, $v, $lockProfile, $emailList, $phoneList, $userAbout, $userNickname, $presentTown, $turnOnEarningDashboard, $dateOfBirthShowType, $emailPrivacy, $isProfileVerified, $inactivationNote, ';
  }
}
