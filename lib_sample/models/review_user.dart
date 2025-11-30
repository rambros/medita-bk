// Sub model of Review

class ReviewUser {
  final String id, name;
  final String? imageUrl;

  ReviewUser({required this.id, required this.name, this.imageUrl});

  factory ReviewUser.fromFirebase(Map<String, dynamic> d) {
    return ReviewUser(
      id: d['id'],
      name: d['name'],
      imageUrl: d['image_url'],
    );
  }

  static Map<String, dynamic> getMap(ReviewUser d) {
    return {'id': d.id, 'name': d.name, 'image_url': d.imageUrl};
  }
}