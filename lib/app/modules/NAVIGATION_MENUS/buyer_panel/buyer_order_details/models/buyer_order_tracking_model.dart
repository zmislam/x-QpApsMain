
class OrderTrackingDetails {
  final String? message;
  final List<OrderTrackingData>? data;

  OrderTrackingDetails({this.message, this.data});

  factory OrderTrackingDetails.fromMap(Map<String, dynamic> json) {
    return OrderTrackingDetails(
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => OrderTrackingData.fromMap(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'data': data?.map((item) => item.toMap()).toList(),
    };
  }
}

class OrderTrackingData {
  final String? checkpointTime;
  final String? city;
  final Coordinate? coordinate;
  final String? countryIso3;
  final String? countryName;
  final String? createdAt;
  final List<Event>? events;
  final String? location;
  final String? message;
  final String? rawTag;
  final String? slug;
  final String? state;
  final String? subtag;
  final String? subtagMessage;
  final String? tag;
  final String? zip;

  OrderTrackingData({
    this.checkpointTime,
    this.city,
    this.coordinate,
    this.countryIso3,
    this.countryName,
    this.createdAt,
    this.events,
    this.location,
    this.message,
    this.rawTag,
    this.slug,
    this.state,
    this.subtag,
    this.subtagMessage,
    this.tag,
    this.zip,
  });

  factory OrderTrackingData.fromMap(Map<String, dynamic> json) {
    return OrderTrackingData(
      checkpointTime: json['checkpoint_time'] as String?,
      city: json['city'] as String?,
      coordinate: json['coordinate'] != null
          ? Coordinate.fromMap(json['coordinate'] as Map<String, dynamic>)
          : null,
      countryIso3: json['country_iso3'] as String?,
      countryName: json['country_name'] as String?,
      createdAt: json['created_at'] as String?,
      events: (json['events'] as List<dynamic>?)
          ?.map((item) => Event.fromMap(item as Map<String, dynamic>))
          .toList(),
      location: json['location'] as String?,
      message: json['message'] as String?,
      rawTag: json['raw_tag'] as String?,
      slug: json['slug'] as String?,
      state: json['state'] as String?,
      subtag: json['subtag'] as String?,
      subtagMessage: json['subtag_message'] as String?,
      tag: json['tag'] as String?,
      zip: json['zip'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'checkpoint_time': checkpointTime,
      'city': city,
      'coordinate': coordinate?.toMap(),
      'country_iso3': countryIso3,
      'country_name': countryName,
      'created_at': createdAt,
      'events': events?.map((item) => item.toMap()).toList(),
      'location': location,
      'message': message,
      'raw_tag': rawTag,
      'slug': slug,
      'state': state,
      'subtag': subtag,
      'subtag_message': subtagMessage,
      'tag': tag,
      'zip': zip,
    };
  }
}

class Coordinate {
  final double? latitude;
  final double? longitude;

  Coordinate({this.latitude, this.longitude});

  factory Coordinate.fromMap(Map<String, dynamic> json) {
    return Coordinate(
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class Event {
  final String? code;
  final String? reason;

  Event({this.code, this.reason});

  factory Event.fromMap(Map<String, dynamic> json) {
    return Event(
      code: json['code'] as String?,
      reason: json['reason'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'reason': reason,
    };
  }
}
