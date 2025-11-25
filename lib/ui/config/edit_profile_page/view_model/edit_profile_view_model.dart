import 'dart:async';

import 'package:flutter/material.dart';

import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/data/repositories/auth_repository.dart';
import '/data/repositories/user_repository.dart';
import '/ui/core/flutter_flow/upload_data.dart';

class EditProfileViewModel extends ChangeNotifier {
  EditProfileViewModel({
    required UserRepository userRepository,
    required AuthRepository authRepository,
  })  : _userRepository = userRepository,
        _authRepository = authRepository;

  final UserRepository _userRepository;
  final AuthRepository _authRepository;

  final formKey = GlobalKey<FormState>();
  final TextEditingController fullNameTextController = TextEditingController();
  final FocusNode fullNameFocusNode = FocusNode();

  StreamSubscription<UsersRecord?>? _userSub;
  UsersRecord? _user;
  bool _initializedControllers = false;

  String _uploadedFileUrl = '';
  String get uploadedFileUrl => _uploadedFileUrl;

  bool _isUploading = false;
  bool get isUploading => _isUploading;

  String get displayName => _user?.fullName ?? '';
  String get email => _authRepository.currentUserEmail;
  String get photoUrl => _user?.userImageUrl ?? '';

  /// Chooses which photo to show (uploaded > existing > fallback).
  String get photoToDisplay {
    if (_uploadedFileUrl.isNotEmpty) return _uploadedFileUrl;
    if (photoUrl.isNotEmpty) return photoUrl;
    return 'https://firebasestorage.googleapis.com/v0/b/meditabk2020.appspot.com/o/app_images%2Fstar_small.png?alt=media&token=e2375a94-b069-4c88-979f-7a3d82f14a68';
  }

  void init() {
    // Seed with current user so the UI shows data immediately.
    _user = _authRepository.currentUser;
    if (!_initializedControllers) {
      fullNameTextController.text = _user?.fullName ?? '';
      _initializedControllers = true;
    }
    notifyListeners();

    _userSub ??= _authRepository.authUserStream().listen((u) {
      _user = u;
      if (!_initializedControllers) {
        fullNameTextController.text = u?.fullName ?? '';
        _initializedControllers = true;
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _userSub?.cancel();
    fullNameTextController.dispose();
    fullNameFocusNode.dispose();
    super.dispose();
  }

  Future<void> uploadImage(BuildContext context) async {
    final selectedMedia = await selectMediaWithSourceBottomSheet(
      context: context,
      maxWidth: 150.00,
      maxHeight: 150.00,
      imageQuality: 80,
      allowPhoto: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      textColor: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
      pickerFontFamily: 'Outfit',
    );

    if (selectedMedia != null && selectedMedia.every((m) => validateFileFormat(m.storagePath, context))) {
      _isUploading = true;
      notifyListeners();

      try {
        showUploadMessage(
          context,
          'Uploading file...',
          showLoading: true,
        );

        final downloadUrls = (await Future.wait(
          selectedMedia.map(
            (m) async => await uploadData(m.storagePath, m.bytes),
          ),
        ))
            .where((u) => u != null)
            .map((u) => u!)
            .toList();

        if (downloadUrls.isNotEmpty) {
          _uploadedFileUrl = downloadUrls.first;
          showUploadMessage(context, 'Success!');
        } else {
          showUploadMessage(context, 'Failed to upload data');
        }
      } finally {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        _isUploading = false;
        notifyListeners();
      }
    }
  }

  Future<void> saveChanges(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final userRef = _user?.reference;
    if (userRef == null) return;

    final updateData = createUsersRecordData(
      fullName: fullNameTextController.text,
      userImageUrl: _uploadedFileUrl.isNotEmpty ? _uploadedFileUrl : null,
    );

    await _userRepository.updateUser(userRef, updateData);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Alterações feitas com sucesso',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          duration: const Duration(milliseconds: 4000),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
      Navigator.of(context).pop();
    }
  }
}
