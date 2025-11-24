import 'package:flutter/material.dart';
import '/data/repositories/auth_repository.dart';
import '/data/repositories/user_repository.dart';
import '/ui/home/home_page/home_page.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';

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
        // Update user record
        await _userRepository.updateUser(
          UsersRecord.collection.doc(user.uid),
          {
            ...createUsersRecordData(
              fullName: name,
              createdTime: getCurrentTimestamp,
              userImageUrl:
                  'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/medita-bk-web-admin-2vj9u4/assets/i10jga9fdqpj/autorImage.jpg',
            ),
            ...mapToFirestore(
              {
                'userRole': ['User'],
              },
            ),
          },
        );

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
