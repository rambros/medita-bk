
import 'package:medita_b_k/core/structs/index.dart';
import 'package:medita_b_k/data/repositories/playlist_repository.dart';
import 'package:medita_b_k/ui/core/flutter_flow/custom_functions.dart' as functions;
import 'package:medita_b_k/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class PlaylistSavePageViewModel extends ChangeNotifier {
  PlaylistSavePageViewModel({
    required PlaylistRepository repository,
    required this.userId,
  }) : _repository = repository;

  final PlaylistRepository _repository;
  final String userId;

  /// Local state fields for this page.

  String? imageUrl;

  /// State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for title widget.
  FocusNode? titleFocusNode;
  TextEditingController? titleTextController;
  String? Function(BuildContext, String?)? titleTextControllerValidator;
  String? _titleTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Informação obrigatória';
    }

    if (val.length < 5) {
      return 'Requires at least 5 characters.';
    }
    if (val.length > 50) {
      return 'Maximum 50 characters allowed, currently ${val.length}.';
    }

    return null;
  }

  // State field(s) for Description widget.
  FocusNode? descriptionFocusNode;
  TextEditingController? descriptionTextController;
  String? Function(BuildContext, String?)? descriptionTextControllerValidator;
  // Stores action output result for [Bottom Sheet - selectImagesPlaylist] action in imageBorder widget.
  String? imageSelected;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  String? errorMessage;

  void init(BuildContext context) {
    titleTextControllerValidator = _titleTextControllerValidator;
  }

  Future<void> savePlaylist(List<AudioModelStruct> audios) async {
    _setSaving(true);
    errorMessage = null;

    try {
      final playlist = PlaylistModelStruct(
        title: titleTextController?.text ?? '',
        description: descriptionTextController?.text ?? '',
        imageUrl: imageUrl,
        duration: functions.getDurationPlaylist(audios),
        audios: audios,
        id: getCurrentTimestamp.secondsSinceEpoch.toString(),
      );

      await _repository.addPlaylist(userId, playlist);
    } catch (e) {
      errorMessage = 'Erro ao salvar playlist: $e';
      rethrow;
    } finally {
      _setSaving(false);
    }
  }

  void _setSaving(bool value) {
    _isSaving = value;
    notifyListeners();
  }

  @override
  void dispose() {
    titleFocusNode?.dispose();
    titleTextController?.dispose();

    descriptionFocusNode?.dispose();
    descriptionTextController?.dispose();
    super.dispose();
  }
}
