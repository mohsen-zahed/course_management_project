class NewsModel {
  final int id;
  final String title;
  final String description;
  final String image;
  final String createAt;
  final String updatedAt;

  const NewsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.createAt,
    required this.updatedAt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['advertisement_id'] ?? -1,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['Image'] != null ? 'https://tam.tawanaacademy.com/public/uploads/imagesad/${json['Image']}' : '',
      createAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
