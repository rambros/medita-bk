class Video {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String? description;
  final DateTime? publishedAt;

  Video({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    this.description,
    this.publishedAt,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'] ?? {};
    final resourceId = snippet['resourceId'] ?? {};
    final thumbnails = snippet['thumbnails'] ?? {};
    final highThumbnail = thumbnails['high'] ?? {};
    final defaultThumbnail = thumbnails['default'] ?? {};

    return Video(
      id: resourceId['videoId'] ?? '',
      title: snippet['title'] ?? '',
      thumbnailUrl: highThumbnail['url'] ?? defaultThumbnail['url'] ?? '',
      description: snippet['description'],
      publishedAt: snippet['publishedAt'] != null ? DateTime.tryParse(snippet['publishedAt']) : null,
    );
  }
}

class Channel {
  final String id;
  final String title;
  final String profilePictureUrl;
  final String subscriberCount;
  final String videoCount;

  Channel({
    required this.id,
    required this.title,
    required this.profilePictureUrl,
    required this.subscriberCount,
    required this.videoCount,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'] ?? {};
    final statistics = json['statistics'] ?? {};
    final thumbnails = snippet['thumbnails'] ?? {};
    final defaultThumbnail = thumbnails['default'] ?? {};

    return Channel(
      id: json['id'] ?? '',
      title: snippet['title'] ?? '',
      profilePictureUrl: defaultThumbnail['url'] ?? '',
      subscriberCount: statistics['subscriberCount'] ?? '0',
      videoCount: statistics['videoCount'] ?? '0',
    );
  }
}

class VideoListResponse {
  final List<Video> videos;
  final String? nextPageToken;
  final int totalResults;

  VideoListResponse({
    required this.videos,
    this.nextPageToken,
    required this.totalResults,
  });
}
