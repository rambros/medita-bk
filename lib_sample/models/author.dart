class Author {
  final String id, name;
  final String? imageUrl;

  Author({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory Author.fromMap(Map<String, dynamic> map) {
    return Author(
      id: map['id'],
      name: map['name'],
      imageUrl: map['image_url'],
      
    );
  }

  static Map<String, dynamic> getMap(Author d) {
    return {
      'id': d.id,
      'name': d.name,
      'image_url': d.imageUrl,
    };
  }
}