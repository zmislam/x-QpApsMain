class InvitesPageModel {
  InvitesPageModel({
    this.id,
    this.pageId,
    this.userId,
    this.acceptInvitation,
    this.dataStatus,
    this.ipAddress,
    this.createdBy,
    this.updateBy,
    this.v,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final PageId? pageId;
  final CreatedBy? userId;
  final dynamic acceptInvitation;
  final dynamic dataStatus;
  final dynamic ipAddress;
  final CreatedBy? createdBy;
  final dynamic updateBy;
  final int? v;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  InvitesPageModel copyWith({
    String? id,
    PageId? pageId,
    CreatedBy? userId,
    dynamic acceptInvitation,
    dynamic dataStatus,
    dynamic ipAddress,
    CreatedBy? createdBy,
    dynamic updateBy,
    int? v,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InvitesPageModel(
      id: id ?? this.id,
      pageId: pageId ?? this.pageId,
      userId: userId ?? this.userId,
      acceptInvitation: acceptInvitation ?? this.acceptInvitation,
      dataStatus: dataStatus ?? this.dataStatus,
      ipAddress: ipAddress ?? this.ipAddress,
      createdBy: createdBy ?? this.createdBy,
      updateBy: updateBy ?? this.updateBy,
      v: v ?? this.v,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory InvitesPageModel.fromMap(Map<String, dynamic> json) {
    return InvitesPageModel(
      id: json['_id'],
      pageId: json['page_id'] == null ? null : PageId.fromJson(json['page_id']),
      userId:
          json['user_id'] == null ? null : CreatedBy.fromJson(json['user_id']),
      acceptInvitation: json['accept_invitation'],
      dataStatus: json['data_status'],
      ipAddress: json['ip_address'],
      createdBy: json['created_by'] == null
          ? null
          : CreatedBy.fromJson(json['created_by']),
      updateBy: json['update_by'],
      v: json['__v'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
    );
  }

  @override
  String toString() {
    return '$id, $pageId, $userId, $acceptInvitation, $dataStatus, $ipAddress, $createdBy, $updateBy, $v, $createdAt, $updatedAt, ';
  }
}

class CreatedBy {
  CreatedBy({
    required this.emailPrivacy,
    required this.dateOfBirthShowType,
    required this.isProfileVerified,
    required this.turnOnEarningDashboard,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.emailList,
    required this.phone,
    required this.phoneList,
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
    required this.websites,
    required this.userNickname,
    required this.userAbout,
    required this.presentTown,
    required this.resetPasswordTokenExpires,
    required this.userRole,
    required this.lockProfile,
    required this.status,
    required this.ipAddress,
    required this.createdBy,
    required this.updateBy,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? emailPrivacy;
  final String? dateOfBirthShowType;
  final bool? isProfileVerified;
  final bool? turnOnEarningDashboard;
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? email;
  final List<String> emailList;
  final String? phone;
  final List<dynamic> phoneList;
  final String? password;
  final String? profilePic;
  final String? coverPic;
  final dynamic userStatus;
  final String? gender;
  final String? religion;
  final DateTime? dateOfBirth;
  final String? userBio;
  final List<dynamic> language;
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
  final dynamic websites;
  final String? userNickname;
  final String? userAbout;
  final String? presentTown;
  final String? resetPasswordTokenExpires;
  final dynamic userRole;
  final String? lockProfile;
  final dynamic status;
  final dynamic ipAddress;
  final dynamic createdBy;
  final dynamic updateBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  CreatedBy copyWith({
    String? emailPrivacy,
    String? dateOfBirthShowType,
    bool? isProfileVerified,
    bool? turnOnEarningDashboard,
    String? id,
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    List<String>? emailList,
    String? phone,
    List<dynamic>? phoneList,
    String? password,
    String? profilePic,
    String? coverPic,
    dynamic userStatus,
    String? gender,
    String? religion,
    DateTime? dateOfBirth,
    String? userBio,
    List<dynamic>? language,
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
    dynamic websites,
    String? userNickname,
    String? userAbout,
    String? presentTown,
    String? resetPasswordTokenExpires,
    dynamic userRole,
    String? lockProfile,
    dynamic status,
    dynamic ipAddress,
    dynamic createdBy,
    dynamic updateBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return CreatedBy(
      emailPrivacy: emailPrivacy ?? this.emailPrivacy,
      dateOfBirthShowType: dateOfBirthShowType ?? this.dateOfBirthShowType,
      isProfileVerified: isProfileVerified ?? this.isProfileVerified,
      turnOnEarningDashboard:
          turnOnEarningDashboard ?? this.turnOnEarningDashboard,
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      email: email ?? this.email,
      emailList: emailList ?? this.emailList,
      phone: phone ?? this.phone,
      phoneList: phoneList ?? this.phoneList,
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
      websites: websites ?? this.websites,
      userNickname: userNickname ?? this.userNickname,
      userAbout: userAbout ?? this.userAbout,
      presentTown: presentTown ?? this.presentTown,
      resetPasswordTokenExpires:
          resetPasswordTokenExpires ?? this.resetPasswordTokenExpires,
      userRole: userRole ?? this.userRole,
      lockProfile: lockProfile ?? this.lockProfile,
      status: status ?? this.status,
      ipAddress: ipAddress ?? this.ipAddress,
      createdBy: createdBy ?? this.createdBy,
      updateBy: updateBy ?? this.updateBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      emailPrivacy: json['email_privacy'],
      dateOfBirthShowType: json['date_of_birth_show_type'],
      isProfileVerified: json['isProfileVerified'],
      turnOnEarningDashboard: json['turn_on_earning_dashboard'],
      id: json['_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      username: json['username'],
      email: json['email'],
      emailList: json['email_list'] == null
          ? []
          : List<String>.from(json['email_list']!.map((x) => x)),
      phone: json['phone'],
      phoneList: json['phone_list'] == null
          ? []
          : List<dynamic>.from(json['phone_list']!.map((x) => x)),
      password: json['password'],
      profilePic: json['profile_pic'],
      coverPic: json['cover_pic'],
      userStatus: json['user_status'],
      gender: json['gender'],
      religion: json['religion'],
      dateOfBirth: DateTime.tryParse(json['date_of_birth'] ?? ''),
      userBio: json['user_bio'],
      language: json['language'] == null
          ? []
          : List<dynamic>.from(json['language']!.map((x) => x)),
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
      websites: json['websites'],
      userNickname: json['user_nickname'],
      userAbout: json['user_about'],
      presentTown: json['present_town'],
      resetPasswordTokenExpires: json['reset_password_token_expires'],
      userRole: json['user_role'],
      lockProfile: json['lock_profile'],
      status: json['status'],
      ipAddress: json['ip_address'],
      createdBy: json['created_by'],
      updateBy: json['update_by'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
      v: json['__v'],
    );
  }

  @override
  String toString() {
    return '$emailPrivacy, $dateOfBirthShowType, $isProfileVerified, $turnOnEarningDashboard, $id, $firstName, $lastName, $username, $email, $emailList, $phone, $phoneList, $password, $profilePic, $coverPic, $userStatus, $gender, $religion, $dateOfBirth, $userBio, $language, $passport, $lastLogin, $user2FaStatus, $secondaryEmail, $recoveryEmail, $relationStatus, $homeTown, $birthPlace, $bloodGroup, $resetPasswordToken, $websites, $userNickname, $userAbout, $presentTown, $resetPasswordTokenExpires, $userRole, $lockProfile, $status, $ipAddress, $createdBy, $updateBy, $createdAt, $updatedAt, $v, ';
  }
}

class PageId {
  PageId({
    required this.whatsappNumber,
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
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final dynamic whatsappNumber;
  final String? id;
  final String? pageName;
  final List<String> category;
  final List<dynamic> friends;
  final List<dynamic> location;
  final String? bio;
  final dynamic website;
  final dynamic pageNotification;
  final dynamic mailNotification;
  final dynamic email;
  final dynamic address;
  final dynamic city;
  final String? zipCode;
  final String? profilePic;
  final String? coverPic;
  final String? pageUserName;
  final dynamic phoneNumber;
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
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  PageId copyWith({
    dynamic whatsappNumber,
    String? id,
    String? pageName,
    List<String>? category,
    List<dynamic>? friends,
    List<dynamic>? location,
    String? bio,
    dynamic website,
    dynamic pageNotification,
    dynamic mailNotification,
    dynamic email,
    dynamic address,
    dynamic city,
    String? zipCode,
    String? profilePic,
    String? coverPic,
    String? pageUserName,
    dynamic phoneNumber,
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
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return PageId(
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  factory PageId.fromJson(Map<String, dynamic> json) {
    return PageId(
      whatsappNumber: json['whatsapp_number'],
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
          : List<dynamic>.from(json['location']!.map((x) => x)),
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
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
      v: json['__v'],
    );
  }

  @override
  String toString() {
    return '$whatsappNumber, $id, $pageName, $category, $friends, $location, $bio, $website, $pageNotification, $mailNotification, $email, $address, $city, $zipCode, $profilePic, $coverPic, $pageUserName, $phoneNumber, $whatsapp, $instagram, $serviceArea, $offer, $language, $privacy, $peopleCanMessage, $hideNumberReaction, $inviteFriends, $userId, $status, $ipAddress, $createdBy, $updateBy, $pageRule, $pageMessage, $pageReaction, $createdAt, $updatedAt, $v, ';
  }
}
