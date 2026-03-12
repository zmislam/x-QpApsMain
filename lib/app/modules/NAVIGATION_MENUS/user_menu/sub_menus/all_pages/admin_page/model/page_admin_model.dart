class PageAdminModel {
  PageAdminModel({
    this.id,
    this.pageId,
    this.userId,
    this.userRole,
    this.ipAddress,
    this.createdBy,
    this.updateBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String? id;
  PageId? pageId;
  String? userId;
  String? userRole;
  dynamic ipAddress;
  String? createdBy;
  dynamic updateBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  PageAdminModel copyWith({
    String? id,
    PageId? pageId,
    String? userId,
    String? userRole,
    dynamic ipAddress,
    String? createdBy,
    dynamic updateBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return PageAdminModel(
      id: id ?? this.id,
      pageId: pageId ?? this.pageId,
      userId: userId ?? this.userId,
      userRole: userRole ?? this.userRole,
      ipAddress: ipAddress ?? this.ipAddress,
      createdBy: createdBy ?? this.createdBy,
      updateBy: updateBy ?? this.updateBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  factory PageAdminModel.fromMap(Map<String, dynamic> json) {
    return PageAdminModel(
      id: json['_id'],
      pageId: json['page_id'] == null ? null : PageId.fromMap(json['page_id']),
      userId: json['user_id'],
      userRole: json['user_role'],
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
        'user_id': userId,
        'user_role': userRole,
        'ip_address': ipAddress,
        'created_by': createdBy,
        'update_by': updateBy,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
      };

  @override
  String toString() {
    return '$id, $pageId, $userId, $userRole, $ipAddress, $createdBy, $updateBy, $createdAt, $updatedAt, $v, ';
  }
}

class PageId {
  PageId({
    required this.id,
    required this.pageName,
    required this.userId,
  });

  final String? id;
  final String? pageName;
  final String? userId;

  PageId copyWith({
    String? id,
    String? pageName,
    String? userId,
  }) {
    return PageId(
      id: id ?? this.id,
      pageName: pageName ?? this.pageName,
      userId: userId ?? this.userId,
    );
  }

  factory PageId.fromMap(Map<String, dynamic> json) {
    return PageId(
      id: json['_id'],
      pageName: json['page_name'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'page_name': pageName,
        'user_id': userId,
      };

  @override
  String toString() {
    return '$id, $pageName, $userId, ';
  }
}
