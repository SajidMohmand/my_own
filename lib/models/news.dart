class News {
  final String title;
  final String subtitle;
  final DateTime dateTime;
  final String url;
  final String? imageUrl;

  News({
    required this.title,
    required this.subtitle,
    required this.dateTime,
    required this.url,
    this.imageUrl,
  });
  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['title'] ?? '',
      subtitle: json['description'] ?? '',
      dateTime: DateTime.tryParse(json['publishedAt'] ?? '') ?? DateTime.now(),
      url: json['url'] ?? '',
      imageUrl: json['urlToImage'],
    );
  }
}
