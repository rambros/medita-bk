import 'package:medita_bk/data/repositories/user_repository.dart';
import 'package:medita_bk/data/repositories/auth_repository.dart';
import 'package:medita_bk/data/models/firebase/user_model.dart';
import 'package:medita_bk/data/services/auth/base_auth_user_provider.dart' as auth_provider;

/// Serviço centralizado para garantir a existência do documento do usuário no Firestore
///
/// Este serviço resolve o problema de usuários autenticados (Firebase Auth)
/// mas sem documento correspondente no Firestore (collection 'users').
///
/// Casos de uso:
/// - Usuário fez login social mas a criação do documento falhou
/// - Documento foi deletado manualmente mas a autenticação permaneceu
/// - Sincronização entre Firebase Auth e Firestore
class UserDocumentService {
  final UserRepository _userRepository;
  final AuthRepository _authRepository;

  /// Cache para evitar verificações redundantes na mesma sessão
  static final Map<String, bool> _verifiedUsers = {};

  UserDocumentService({
    required UserRepository userRepository,
    required AuthRepository authRepository,
  })  : _userRepository = userRepository,
        _authRepository = authRepository;

  /// Garante que o usuário tem documento no Firestore
  ///
  /// Se o documento não existir, cria automaticamente com dados do Firebase Auth
  /// Retorna o UserModel (existente ou recém-criado) ou null se não houver usuário autenticado
  ///
  /// [forceCheck] - Se true, ignora o cache e força nova verificação
  Future<UserModel?> ensureUserDocument({bool forceCheck = false}) async {
    try {
      // Verifica se há usuário autenticado
      final userId = _authRepository.currentUserUid;

      if (userId.isEmpty) {
        return null;
      }

      // Verifica cache (evita verificações redundantes)
      if (!forceCheck && _verifiedUsers.containsKey(userId)) {
        return await _userRepository.getUserById(userId);
      }

      // Busca documento do usuário no Firestore
      final existingUser = await _userRepository.getUserById(userId);

      if (existingUser != null) {
        // Documento existe, adiciona ao cache
        _verifiedUsers[userId] = true;
        return existingUser;
      }

      // Obtém dados do Firebase Auth via AuthRepository
      final email = _authRepository.currentUserEmail;
      if (email.isEmpty) {
        return null;
      }

      // Coleta dados disponíveis do Firebase Auth
      final displayName = auth_provider.currentUser?.displayName ?? '';
      final photoUrl = auth_provider.currentUser?.photoUrl ??
          'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/medita-bk-web-admin-2vj9u4/assets/i10jga9fdqpj/autorImage.jpg';

      // Cria novo documento com dados do Firebase Auth
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
      _verifiedUsers[userId] = true;

      return newUser;
    } catch (e) {
      rethrow;
    }
  }

  /// Detecta o tipo de login baseado no email do usuário
  /// Nota: Detecção heurística baseada no domínio do email
  String _detectLoginType(String email) {
    // Se não tem email, assume login anônimo
    if (email.isEmpty) {
      return 'anonymous';
    }

    // Detecta providers sociais pelo domínio do email
    if (email.contains('@gmail.com') || email.contains('@googlemail.com')) {
      return 'google';
    }

    if (email.contains('@icloud.com') || email.contains('@me.com') || email.contains('@mac.com')) {
      return 'apple';
    }

    // Default para email/password
    return 'email';
  }

  /// Limpa o cache de verificação
  /// Útil para forçar nova verificação após logout ou troca de usuário
  static void clearCache() {
    _verifiedUsers.clear();
  }

  /// Limpa cache de um usuário específico
  static void clearUserCache(String userId) {
    _verifiedUsers.remove(userId);
  }
}
