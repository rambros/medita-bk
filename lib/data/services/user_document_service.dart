import 'package:flutter/material.dart';
import 'package:medita_bk/data/repositories/user_repository.dart';
import 'package:medita_bk/data/repositories/auth_repository.dart';
import 'package:medita_bk/data/models/firebase/user_model.dart';
import 'package:medita_bk/data/services/auth/base_auth_user_provider.dart';

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
      final authUser = _authRepository.currentUser;
      final userId = _authRepository.currentUserUid;

      if (userId.isEmpty) {
        debugPrint('⚠️ UserDocumentService: Nenhum usuário autenticado');
        return null;
      }

      // Verifica cache (evita verificações redundantes)
      if (!forceCheck && _verifiedUsers.containsKey(userId)) {
        debugPrint('✅ UserDocumentService: Usuário $userId já verificado (cache)');
        return await _userRepository.getUserById(userId);
      }

      // Busca documento do usuário no Firestore
      final existingUser = await _userRepository.getUserById(userId);

      if (existingUser != null) {
        // Documento existe, adiciona ao cache
        _verifiedUsers[userId] = true;
        debugPrint('✅ UserDocumentService: Documento do usuário $userId já existe');
        return existingUser;
      }

      // Documento não existe, precisa criar
      debugPrint('⚠️ UserDocumentService: Documento do usuário $userId não encontrado');

      // Obtém dados do Firebase Auth
      final firebaseUser = _authRepository.currentUser;
      if (firebaseUser == null) {
        debugPrint('❌ UserDocumentService: Não foi possível obter dados do Firebase Auth');
        return null;
      }

      // Cria novo documento com dados do Firebase Auth
      final newUser = UserModel(
        uid: userId,
        email: firebaseUser.email ?? '',
        fullName: firebaseUser.displayName ?? '',
        displayName: firebaseUser.displayName ?? '',
        userImageUrl: firebaseUser.photoUrl ??
          'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/medita-bk-web-admin-2vj9u4/assets/i10jga9fdqpj/autorImage.jpg',
        createdTime: DateTime.now(),
        userRole: const ['User'],
        loginType: _detectLoginType(firebaseUser),
      );

      await _userRepository.createUser(newUser);
      _verifiedUsers[userId] = true;

      debugPrint('✅ UserDocumentService: Documento criado para usuário $userId (${newUser.loginType})');

      return newUser;
    } catch (e) {
      debugPrint('❌ UserDocumentService: Erro ao garantir documento do usuário: $e');
      rethrow;
    }
  }

  /// Detecta o tipo de login baseado no email do usuário
  String _detectLoginType(BaseAuthUser authUser) {
    final email = authUser.email ?? '';

    // Se tem providerData, usa para detectar o provider
    // Caso contrário, detecta pelo formato do email
    if (email.isEmpty) {
      return 'anonymous';
    }

    // Email providers comuns
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
    debugPrint('🗑️ UserDocumentService: Cache limpo');
  }

  /// Limpa cache de um usuário específico
  static void clearUserCache(String userId) {
    _verifiedUsers.remove(userId);
    debugPrint('🗑️ UserDocumentService: Cache do usuário $userId limpo');
  }
}
