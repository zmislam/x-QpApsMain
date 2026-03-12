class RefundMessageResponse {
  int? status;
  List<RefundChatResult>? results;

  RefundMessageResponse({this.status, this.results});

  factory RefundMessageResponse.fromMap(Map<String, dynamic> map) {
    return RefundMessageResponse(
      status: map['status'] as int?,
      results: (map['results'] as List<dynamic>?)
          ?.map((result) => RefundChatResult.fromMap(result as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'results': results?.map((result) => result.toMap()).toList(),
    };
  }
}

class RefundChatResult {
  String? id;
  String? refundId;
  String? sendBy;
  String? adminId;
  String? message;
  List<String>? images;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  RefundMessageSender? sender;
  RefundChatAdmin? admin;

  RefundChatResult({
    this.id,
    this.refundId,
    this.sendBy,
    this.adminId,
    this.message,
    this.images,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.sender,
    this.admin,
  });

  factory RefundChatResult.fromMap(Map<String, dynamic> map) {
    return RefundChatResult(
      id: map['_id'] as String?,
      refundId: map['refund_id'] as String?,
      sendBy: map['send_by'] as String?,
      adminId: map['admin_id'] as String?,
      message: map['message'] as String?,
      images: (map['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      v: map['__v'] as int?,
      sender: map['sender'] != null ? RefundMessageSender.fromMap(map['sender']) : null,
      admin: map['admin'] != null ? RefundChatAdmin.fromMap(map['admin']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'refund_id': refundId,
      'send_by': sendBy,
      'admin_id': adminId,
      'message': message,
      'images': images,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
      'sender': sender?.toMap(),
      'admin': admin?.toMap(),
    };
  }
}

class RefundMessageSender {
  String? id;
  String? firstName;
  String? lastName;

  RefundMessageSender({this.id, this.firstName, this.lastName});

  factory RefundMessageSender.fromMap(Map<String, dynamic> map) {
    return RefundMessageSender(
      id: map['_id'] as String?,
      firstName: map['first_name'] as String?,
      lastName: map['last_name'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'first_name': firstName,
      'last_name': lastName,
    };
  }
}

class RefundChatAdmin {
  String? id;
  String? name;

  RefundChatAdmin({this.id, this.name});

  factory RefundChatAdmin.fromMap(Map<String, dynamic> map) {
    return RefundChatAdmin(
      id: map['_id'] as String?,
      name: map['name'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
    };
  }
}
