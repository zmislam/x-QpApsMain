class PairingModel {
  final String topic;
  final int expiry;
  final PeerAppMetaData? peerAppMetaData;
  final String relayProtocol;
  final String? relayData;
  final String uri;
  final bool isActive;
  final List<String> registeredMethods;

  PairingModel({
    required this.topic,
    required this.expiry,
    this.peerAppMetaData,
    required this.relayProtocol,
    this.relayData,
    required this.uri,
    required this.isActive,
    required this.registeredMethods,
  });

  factory PairingModel.fromMap(Map<String, dynamic> map) {
    return PairingModel(
      topic: map['topic'],
      expiry: map['expiry'],
      peerAppMetaData: map['peerAppMetaData'] != null ? PeerAppMetaData.fromMap(Map<String, dynamic>.from(map['peerAppMetaData'])) : null,
      relayProtocol: map['relayProtocol'],
      relayData: map['relayData'],
      uri: map['uri'],
      isActive: map['isActive'],
      registeredMethods: List<String>.from(map['registeredMethods']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'topic': topic,
      'expiry': expiry,
      'peerAppMetaData': peerAppMetaData?.toMap(),
      'relayProtocol': relayProtocol,
      'relayData': relayData,
      'uri': uri,
      'isActive': isActive,
      'registeredMethods': registeredMethods,
    };
  }
}

class PeerAppMetaData {
  final String name;
  final String description;
  final String url;
  final List<String> icons;

  PeerAppMetaData({
    required this.name,
    required this.description,
    required this.url,
    required this.icons,
  });

  factory PeerAppMetaData.fromMap(Map<String, dynamic> map) {
    return PeerAppMetaData(
      name: map['name'],
      description: map['description'],
      url: map['url'],
      icons: List<String>.from(map['icons']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'url': url,
      'icons': icons,
    };
  }
}
