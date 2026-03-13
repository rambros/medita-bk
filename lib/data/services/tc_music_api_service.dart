import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medita_bk/domain/models/traffic_control/index.dart';

/// Service para acessar músicas do Traffic Control no Firestore
class TcMusicApiService {
  final FirebaseFirestore _firestore;

  TcMusicApiService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Nome da collection no Firestore
  static const String collectionName = 'traffic_control_musics';

  /// Referência à collection de músicas
  CollectionReference get _musicsCollection =>
      _firestore.collection(collectionName);

  /// Obtém todas as músicas ativas
  Future<List<TcMusicEntity>> getActiveMusics() async {
    try {
      final snapshot = await _musicsCollection
          .where('isActive', isEqualTo: true)
          .orderBy('title')
          .get();

      return snapshot.docs
          .map((doc) => TcMusicEntity.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('TcMusicApi: Erro ao buscar músicas ativas: $e');
      rethrow;
    }
  }

  /// Stream de músicas ativas (para atualizações em tempo real)
  Stream<List<TcMusicEntity>> streamActiveMusics() {
    return _musicsCollection
        .where('isActive', isEqualTo: true)
        .orderBy('title')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TcMusicEntity.fromFirestore(doc))
            .toList());
  }

  /// Obtém músicas por categoria
  Future<List<TcMusicEntity>> getMusicsByCategory(String category) async {
    try {
      final snapshot = await _musicsCollection
          .where('isActive', isEqualTo: true)
          .where('category', isEqualTo: category)
          .orderBy('title')
          .get();

      return snapshot.docs
          .map((doc) => TcMusicEntity.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('TcMusicApi: Erro ao buscar músicas por categoria: $e');
      rethrow;
    }
  }

  /// Obtém uma música específica pelo ID
  Future<TcMusicEntity?> getMusicById(String musicId) async {
    try {
      final doc = await _musicsCollection.doc(musicId).get();

      if (!doc.exists) {
        return null;
      }

      return TcMusicEntity.fromFirestore(doc);
    } catch (e) {
      print('TcMusicApi: Erro ao buscar música por ID: $e');
      rethrow;
    }
  }

  /// Busca músicas por título (case-insensitive)
  ///
  /// Nota: Firestore não suporta busca case-insensitive nativamente,
  /// então fazemos a filtragem no cliente.
  Future<List<TcMusicEntity>> searchMusicsByTitle(String query) async {
    try {
      final allMusics = await getActiveMusics();

      final lowerQuery = query.toLowerCase();

      return allMusics.where((music) {
        return music.title.toLowerCase().contains(lowerQuery);
      }).toList();
    } catch (e) {
      print('TcMusicApi: Erro ao buscar músicas por título: $e');
      rethrow;
    }
  }

  /// Obtém todas as categorias disponíveis
  Future<List<String>> getCategories() async {
    try {
      final musics = await getActiveMusics();

      final categories = musics
          .map((m) => m.category)
          .whereType<String>()
          .toSet()
          .toList()
        ..sort();

      return categories;
    } catch (e) {
      print('TcMusicApi: Erro ao buscar categorias: $e');
      rethrow;
    }
  }

  /// Conta quantas músicas ativas existem
  Future<int> countActiveMusics() async {
    try {
      final snapshot = await _musicsCollection
          .where('isActive', isEqualTo: true)
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      print('TcMusicApi: Erro ao contar músicas: $e');
      return 0;
    }
  }

  /// Verifica se existe pelo menos uma música ativa
  Future<bool> hasActiveMusics() async {
    final count = await countActiveMusics();
    return count > 0;
  }

  // ==================== MÉTODOS ADMIN ====================
  // Estes métodos serão usados apenas no painel admin web

  /// Cria uma nova música (admin)
  Future<String> createMusic(TcMusicEntity music) async {
    try {
      final docRef = await _musicsCollection.add(music.toFirestore());
      print('TcMusicApi: Música criada com ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('TcMusicApi: Erro ao criar música: $e');
      rethrow;
    }
  }

  /// Atualiza uma música existente (admin)
  Future<void> updateMusic(TcMusicEntity music) async {
    try {
      await _musicsCollection.doc(music.id).update(music.toFirestore());
      print('TcMusicApi: Música atualizada: ${music.id}');
    } catch (e) {
      print('TcMusicApi: Erro ao atualizar música: $e');
      rethrow;
    }
  }

  /// Deleta uma música (admin)
  Future<void> deleteMusic(String musicId) async {
    try {
      await _musicsCollection.doc(musicId).delete();
      print('TcMusicApi: Música deletada: $musicId');
    } catch (e) {
      print('TcMusicApi: Erro ao deletar música: $e');
      rethrow;
    }
  }

  /// Obtém todas as músicas (incluindo inativas) - admin
  Future<List<TcMusicEntity>> getAllMusics() async {
    try {
      final snapshot = await _musicsCollection.orderBy('title').get();

      return snapshot.docs
          .map((doc) => TcMusicEntity.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('TcMusicApi: Erro ao buscar todas as músicas: $e');
      rethrow;
    }
  }
}
