import 'package:flutter/material.dart';

import 'package:share_plus/share_plus.dart';

class MensagemShowViewModel extends ChangeNotifier {
  MensagemShowViewModel();

  Future<void> shareContent(String tema, String mensagem, Rect? sharePositionOrigin) async {
    await Share.share(
      'Mensagem positiva\n\n$tema\n$mensagem',
      sharePositionOrigin: sharePositionOrigin,
    );
  }
}
