class LinkPreview {
  final String? title;
  final String? description;
  final String? thumbnail;

  LinkPreview({
    this.title,
    this.description,
    this.thumbnail,
  });

  // Factory constructor to create an instance from a map
  factory LinkPreview.fromMap(Map<String, dynamic>? map) {
    if (map == null) return LinkPreview();

    return LinkPreview(
      title: map['title'] as String?,
      description: map['description'] as String?,
      thumbnail: map['thumbnail'] as String?,
    );
  }

  // Method to convert an instance to a map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'thumbnail': thumbnail,
    };
  }
}
