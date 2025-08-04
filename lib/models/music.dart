class Music {
  final String preview; // 미리듣기 URL
  final String title;
  final String albumCover;
  final String albumTitle;
  final String artist;
  final int duration;

  Music({
    required this.preview,
    required this.title,
    required this.albumCover,
    required this.albumTitle,
    required this.artist,
    required this.duration,
  });

  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
      preview: json['preview'] ?? '',
      title: json['titleShort'] ?? '',
      albumCover: json['albumCover'] ?? '',
      albumTitle: json['albumTitle'] ?? '',
      artist: json['artistName'] ?? '',
      duration: json['duration'] ?? 0,
    );
  }
}
