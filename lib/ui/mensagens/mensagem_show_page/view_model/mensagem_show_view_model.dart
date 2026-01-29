import 'package:flutter/material.dart';

import 'package:share_plus/share_plus.dart';

class MensagemShowViewModel extends ChangeNotifier {
  MensagemShowViewModel();

  double _fontSize = 16.0;
  double get fontSize => _fontSize;

  bool _showBackground = true;
  bool get showBackground => _showBackground;

  void setFontSize(double value) {
    _fontSize = value;
    notifyListeners();
  }

  void toggleBackground(bool value) {
    _showBackground = value;
    notifyListeners();
  }

  Future<void> shareContent(String tema, String mensagem, Rect? sharePositionOrigin) async {
    await Share.share(
      'Mensagem positiva\n\n$tema\n$mensagem',
      sharePositionOrigin: sharePositionOrigin,
    );
  }
}
