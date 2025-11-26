import '/data/models/firebase/category_model.dart';
import '/data/services/firebase/firestore_service.dart';

/// Repository for categories (themes) used in meditation filters
class CategoryRepository {
  CategoryRepository({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  final FirestoreService _firestoreService;
  static const String _collection = 'category';

  Stream<List<CategoryModel>> getCategoriesStream() {
    return _firestoreService.streamCollection(
      collectionPath: _collection,
      fromSnapshot: CategoryModel.fromFirestore,
      queryBuilder: (query) => query.orderBy('nome'),
    );
  }

  Future<List<CategoryModel>> getCategoriesOnce() {
    return _firestoreService.getCollection(
      collectionPath: _collection,
      fromSnapshot: CategoryModel.fromFirestore,
      queryBuilder: (query) => query.orderBy('nome'),
    );
  }
}
