import 'package:medita_bk/data/repositories/user_repository.dart';
import 'package:medita_bk/data/repositories/auth_repository.dart';
import 'package:medita_bk/data/models/firebase/user_model.dart';
import 'package:medita_bk/data/services/auth/base_auth_user_provider.dart' as auth_provider;

/// Serviço centralizado para garantir a existência do documento do usuário no Firestore
class UserDocumentService {
  final UserRepository _userRepository;
  final AuthRepository _authRepository;

  /// Cache do UserModel em memória para evitar chamadas ao Firestore na mesma sessão
  static final Map<String, UserModel> _cachedUsers = {};

  UserDocumentService({
    required UserRepository userRepository,
    required AuthRepository authRepository,
  })  : _userRepository = userRepository,
        _authRepository = authRepository;

  /// Garante que o usuário tem documento no Firestore
  ///
  /// Retorna do cache em memória se disponível (sem chamada ao Firestore).
  /// [forceCheck] - Se true, ignora o cache e força nova verificação no Firestore.
  Future<UserModel?> ensureUserDocument({bool forceCheck = false}) async {
    try {
      final userId = _authRepository.currentUserUid;
      if (userId.isEmpty) return null;

      // Retorna do cache sem chamada ao Firestore
      if (!forceCheck && _cachedUsers.containsKey(userId)) {
        return _cachedUsers[userId];
      }

      // Busca documento do usuário no Firestore
      final existingUser = await _userRepository.getUserById(userId);

      if (existingUser != null) {
        _cachedUsers[userId] = existingUser;
        return existingUser;
      }

      // Documento não existe — cria com dados do Firebase Auth
      final email = _authRepository.currentUserEmail;
      if (email.isEmpty) return null;

      final displayName = auth_provider.currentUser?.displayName ?? '';
      final photoUrl = auth_provider.currentUser?.photoUrl ??
          'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/medita-bk-web-admin-2vj9u4/assets/i10jga9fdqpj/autorImage.jpg';

      final newUser = UserModel(
        uid: userId,
        email: email,
        fullName: displayName,
        displayName: displayName,
        userImageUrl: photoUrl,
        createdTime: DateTime.now(),
        userRole: const ['User'],
        loginType: _detectLoginType(email),
      );

      await _userRepository.createUser(newUser);
      _cachedUsers[userId] = newUser;

      return newUser;
    } catch (e) {
      rethrow;
    }
  }

  String _detectLoginType(String email) {
    if (email.isEmpty) return 'anonymous';
    if (email.contains('@gmail.com') || email.contains('@googlemail.com')) return 'google';
    if (email.contains('@icloud.com') || email.contains('@me.com') || email.contains('@mac.com')) return 'apple';
    return 'email';
  }

  /// Limpa o cache de todos os usuários (ex: após logout)
  static void clearCache() {
    _cachedUsers.clear();
  }

  /// Limpa cache de um usuário específico
  static void clearUserCache(String userId) {
    _cachedUsers.remove(userId);
  }
}
