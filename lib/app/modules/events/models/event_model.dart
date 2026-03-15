class EventModel {
  final String? id;
  final String? title;
  final String? description;
  final String? coverImage;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? timezone;
  final bool isRecurring;
  final String? recurrenceRule;
  final String? eventMode;
  final String? venueName;
  final String? venueAddress;
  final String? city;
  final double? latitude;
  final double? longitude;
  final String? meetingUrl;
  final String? privacy;
  final EventOrganizer? organizer;
  final int interestedCount;
  final int goingCount;
  final bool isInterested;
  final bool isGoing;
  final String? dateLabel; // "Happening now" or null
  final String? status;
  final DateTime? createdAt;

  EventModel({
    this.id,
    this.title,
    this.description,
    this.coverImage,
    this.startDate,
    this.endDate,
    this.timezone,
    this.isRecurring = false,
    this.recurrenceRule,
    this.eventMode,
    this.venueName,
    this.venueAddress,
    this.city,
    this.latitude,
    this.longitude,
    this.meetingUrl,
    this.privacy,
    this.organizer,
    this.interestedCount = 0,
    this.goingCount = 0,
    this.isInterested = false,
    this.isGoing = false,
    this.dateLabel,
    this.status,
    this.createdAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['_id']?.toString(),
      title: json['title'],
      description: json['description'],
      coverImage: json['cover_image'],
      startDate: json['start_date'] != null
          ? DateTime.tryParse(json['start_date'].toString())
          : null,
      endDate: json['end_date'] != null
          ? DateTime.tryParse(json['end_date'].toString())
          : null,
      timezone: json['timezone'],
      isRecurring: json['is_recurring'] ?? false,
      recurrenceRule: json['recurrence_rule'],
      eventMode: json['event_mode'],
      venueName: json['venue_name'],
      venueAddress: json['venue_address'],
      city: json['city'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      meetingUrl: json['meeting_url'],
      privacy: json['privacy'],
      organizer: json['organizer_id'] is Map
          ? EventOrganizer.fromJson(json['organizer_id'])
          : null,
      interestedCount: json['interested_count'] ?? 0,
      goingCount: json['going_count'] ?? 0,
      isInterested: json['is_interested'] ?? false,
      isGoing: json['is_going'] ?? false,
      dateLabel: json['date_label'],
      status: json['status'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'cover_image': coverImage,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'timezone': timezone,
      'is_recurring': isRecurring,
      'recurrence_rule': recurrenceRule,
      'event_mode': eventMode,
      'venue_name': venueName,
      'venue_address': venueAddress,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'meeting_url': meetingUrl,
      'privacy': privacy,
      'interested_count': interestedCount,
      'going_count': goingCount,
    };
  }

  EventModel copyWith({
    bool? isInterested,
    bool? isGoing,
    int? interestedCount,
    int? goingCount,
  }) {
    return EventModel(
      id: id,
      title: title,
      description: description,
      coverImage: coverImage,
      startDate: startDate,
      endDate: endDate,
      timezone: timezone,
      isRecurring: isRecurring,
      recurrenceRule: recurrenceRule,
      eventMode: eventMode,
      venueName: venueName,
      venueAddress: venueAddress,
      city: city,
      latitude: latitude,
      longitude: longitude,
      meetingUrl: meetingUrl,
      privacy: privacy,
      organizer: organizer,
      interestedCount: interestedCount ?? this.interestedCount,
      goingCount: goingCount ?? this.goingCount,
      isInterested: isInterested ?? this.isInterested,
      isGoing: isGoing ?? this.isGoing,
      dateLabel: dateLabel,
      status: status,
      createdAt: createdAt,
    );
  }

  /// Formatted date string for display (e.g., "Tue, 31 Mar-6 Apr")
  String get formattedDateRange {
    if (startDate == null) return '';
    final months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final sd = startDate!;
    final dayName = days[sd.weekday - 1];
    final start = '$dayName, ${sd.day} ${months[sd.month]}';

    if (endDate != null) {
      final ed = endDate!;
      if (sd.month == ed.month && sd.year == ed.year) {
        return '$start-${ed.day} ${months[ed.month]}';
      }
      return '$start-${ed.day} ${months[ed.month]}';
    }

    // Include time if no end date
    final hour = sd.hour.toString().padLeft(2, '0');
    final minute = sd.minute.toString().padLeft(2, '0');
    return '$start at $hour:$minute';
  }

  /// Display for venue
  String get venueDisplay {
    final parts = <String>[];
    if (venueName != null && venueName!.isNotEmpty) parts.add(venueName!);
    if (city != null && city!.isNotEmpty) parts.add(city!);
    return parts.join(' · ');
  }

  /// Stats display
  String get statsDisplay {
    final parts = <String>[];
    if (interestedCount > 0) {
      parts.add(_formatCount(interestedCount, 'interested'));
    }
    if (goingCount > 0) {
      parts.add(_formatCount(goingCount, 'going'));
    }
    return parts.join(' · ');
  }

  String _formatCount(int count, String label) {
    if (count >= 1000) {
      final k = (count / 1000).toStringAsFixed(count % 1000 == 0 ? 0 : 1);
      return '${k}K $label';
    }
    return '$count $label';
  }
}

class EventOrganizer {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? profilePic;

  EventOrganizer({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.profilePic,
  });

  factory EventOrganizer.fromJson(Map<String, dynamic> json) {
    return EventOrganizer(
      id: json['_id']?.toString(),
      firstName: json['first_name'],
      lastName: json['last_name'],
      username: json['username'],
      profilePic: json['profile_pic'],
    );
  }

  String get fullName =>
      '${firstName ?? ''} ${lastName ?? ''}'.trim();
}
