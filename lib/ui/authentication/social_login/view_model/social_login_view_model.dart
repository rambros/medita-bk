import 'package:flutter/material.dart';
import 'package:medita_bk/data/repositories/auth_repository.dart';
import 'package:medita_bk/data/repositories/user_repository.dart';
import 'package:medita_bk/data/models/firebase/user_model.dart';
import 'package:medita_bk/data/services/auth/base_auth_user_provider.dart';
import 'package:medita_bk/routing/nav.dart';
import 'package:medita_bk/ui/home/home_page/home_page.dart';

class SocialLoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  SocialLoginViewModel({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> signInWithGoogle(BuildContext context) async {
    _setLoading(true);
    try {
      GoRouter.of(context).prepareAuthEvent();
      final user = await _authRepository.signInWithGoogle(context);
      if (user != null) {
        // Garante que documento existe no Firestore
        await _ensureUserDocument(user, 'google');

        if (context.mounted) {
          context.goNamedAuth(HomePage.routeName, context.mounted);
        }
      }
    } catch (e) {
      _errorMessage = 'Erro ao criar seu perfil. Tente novamente.';
      debugPrint('Erro no login Google: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInWithApple(BuildContext context) async {
    _setLoading(true);
    try {
      GoRouter.of(context).prepareAuthEvent();
      final user = await _authRepository.signInWithApple(context);
      if (user != null) {
        // Garante que documento existe no Firestore
        await _ensureUserDocument(user, 'apple');

        if (context.mounted) {
          context.goNamedAuth(HomePage.routeName, context.mounted);
        }
      }
    } catch (e) {
      _errorMessage = 'Erro ao criar seu perfil. Tente novamente.';
      debugPrint('Erro no login Apple: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Garante que o usuário tem documento no Firestore
  /// Se não existir, cria com dados do Firebase Auth
  Future<void> _ensureUserDocument(BaseAuthUser authUser, String loginType) async {
    final uid = authUser.uid ?? '';
    if (uid.isEmpty) {
      throw Exception('UID do usuário está vazio');
    }

    try {
      // Verifica se documento já existe
      final existingUser = await _userRepository.getUserById(uid);

      if (existingUser == null) {
        // Documento não existe, criar novo
        final newUser = UserModel(
          uid: uid,
          email: authUser.email ?? '',
          fullName: authUser.displayName ?? '',
          displayName: authUser.displayName ?? '',
          userImageUrl: authUser.photoUrl ?? 'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/medita-bk-web-admin-2vj9u4/assets/i10jga9fdqpj/autorImage.jpg',
          createdTime: DateTime.now(),
          userRole: const ['User'],
          loginType: loginType,
        );

        await _userRepository.createUser(newUser);
        debugPrint('✅ Documento de usuário criado no Firestore: $uid ($loginType)');
      } else {
        debugPrint('ℹ️ Documento de usuário já existe: $uid');
      }
    } catch (e) {
      debugPrint('❌ Erro ao criar documento de usuário: $e');
      rethrow;
    }
  }
}
