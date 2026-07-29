/// Modelo de Publicación de Novedades.
class NewsModel {
  final String id;
  final String title;
  final String description;
  final String date;
  final String? imageUrl;

  const NewsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.imageUrl,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        date: json['date'] as String,
        imageUrl: json['imageUrl'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'date': date,
        'imageUrl': imageUrl,
      };
}
