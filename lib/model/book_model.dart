class Book {
  final String id;
  final String title;
  final String author;
  final String coverUrl;
  final String pdfUrl;
  final String description;
  final String category;
  String? localPath;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.pdfUrl,
    required this.description,
    required this.category,
    this.localPath,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      coverUrl: json['coverUrl'] ?? '',
      pdfUrl: json['pdfUrl'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
    );
  }
}
