class NewsModel {
  final int id;
  final String title;
  final String description;
  final String image;
  final String date;
  final bool featured;

  const NewsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.date,
    required this.featured,
  });

  factory NewsModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return NewsModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description:
      json['description'] ?? '',
      image: json['image'] ?? '',
      date: json['date'] ?? '',
      featured:
      json['featured'] ?? false,
    );
  }
}