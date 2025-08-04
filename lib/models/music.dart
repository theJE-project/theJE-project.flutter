class Music {
  final String title;
  // 필요한 필드 추가

  Music({required this.title});

  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(title: json['title']);
  }
}
