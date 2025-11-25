import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';

class InviteViewModel extends ChangeNotifier {
  void shareInvite(BuildContext context, String text) async {
    await Share.share(
      '$text\nhttps://c5dad.app.link/meditabk',
      sharePositionOrigin: getWidgetBoundingBox(context),
    );
  }
}
