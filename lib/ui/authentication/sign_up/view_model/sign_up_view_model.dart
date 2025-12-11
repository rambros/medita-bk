import 'package:flutter/material.dart';
import 'package:medita_bk/data/models/firebase/user_model.dart';
import 'package:medita_bk/data/repositories/auth_repository.dart';
import 'package:medita_bk/data/repositories/user_repository.dart';
import 'package:medita_bk/ui/home/home_page/home_page.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart';

class SignUpViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  SignUpViewModel(this._authRepository, this._userRepository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> createAccountWithEmail(
    BuildContext context,
    String email,
    String password,
    String name,
  ) async {
    _setLoading(true);
    try {
      GoRouter.of(context).prepareAuthEvent();
      final user = await _authRepository.createAccountWithEmail(context, email, password);

      if (user != null) {
        // Create new user model
        final newUser = UserModel(
          uid: user.uid ?? '', // Should never be null, but adding safety
          email: user.email ?? email, // Use Firebase email or fallback to provided email
          fullName: name,
          displayName: name,
          createdTime: DateTime.now(),
          userImageUrl:
              'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/medita-bk-web-admin-2vj9u4/assets/i10jga9fdqpj/autorImage.jpg',
          userRole: const ['User'],
          loginType: 'email',
        );

        // Create user document in Firestore
        await _userRepository.createUser(newUser);

        if (context.mounted) {
          context.goNamedAuth(HomePage.routeName, context.mounted);
        }
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
