import 'package:flutter/material.dart';
import '/data/services/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/data/repositories/user_repository.dart';
import '/ui/core/flutter_flow/upload_data.dart';

import '/ui/core/flutter_flow/flutter_flow_util.dart';

class EditProfileViewModel extends ChangeNotifier {
  final UserRepository _userRepository;

  EditProfileViewModel({required UserRepository userRepository}) : _userRepository = userRepository {
    _initialize();
  }

  final formKey = GlobalKey<FormState>();
  late TextEditingController fullNameTextController;
  late FocusNode fullNameFocusNode;

  String _uploadedFileUrl = '';
  String get uploadedFileUrl => _uploadedFileUrl;

  bool _isUploading = false;
  bool get isUploading => _isUploading;

  void _initialize() {
    fullNameTextController = TextEditingController(text: valueOrDefault(currentUserDocument?.fullName, ''));
    fullNameFocusNode = FocusNode();
  }

  @override
  void dispose() {
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

    final updateData = createUsersRecordData(
      fullName: fullNameTextController.text,
      userImageUrl: _uploadedFileUrl.isNotEmpty ? _uploadedFileUrl : null,
    );

    await _userRepository.updateUser(currentUserReference!, updateData);

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
