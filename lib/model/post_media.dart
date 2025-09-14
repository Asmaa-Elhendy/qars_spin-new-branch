class PostMedia {
  final String code;
  final String desc;
  final int count;
  final List<MediaItem> data;

  PostMedia({
    required this.code,
    required this.desc,
    required this.count,
    required this.data,
  });

  factory PostMedia.fromJson(Map<String, dynamic> json) {
    var dataList = json['Data'] as List?;
    List<MediaItem> mediaItems = dataList?.map((i) => MediaItem.fromJson(i)).toList() ?? [];

    return PostMedia(
      code: json['Code'] ?? '',
      desc: json['Desc'] ?? '',
      count: json['Count'] ?? 0,
      data: mediaItems,
    );
  }
}

class MediaItem {
  final int mediaId;
  final String mediaFileName;
  final String mediaUrl;
  final int displayOrder;

  MediaItem({
    required this.mediaId,
    required this.mediaFileName,
    required this.mediaUrl,
    required this.displayOrder,
  });

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      mediaId: json['Media_ID'] ?? 0,
      mediaFileName: json['Media_FileName'] ?? '',
      mediaUrl: json['Media_URL'] ?? '',
      displayOrder: json['Display_Order'] ?? 0,
    );
  }
}
