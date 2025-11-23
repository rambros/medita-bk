// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:url_launcher/url_launcher.dart';

class HtmlDisplayWidget extends StatefulWidget {
  const HtmlDisplayWidget({
    super.key,
    this.width,
    this.height,
    this.description,
  });

  final double? width;
  final double? height;
  final String? description;

  @override
  _HtmlWidgetState createState() => _HtmlWidgetState();
}

class _HtmlWidgetState extends State<HtmlDisplayWidget> {
  Future<bool> launchLink(String url) async {
    final url0 = Uri.parse(url);
    return await launchUrl(url0);
  }

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      widget.description!,
      onTapUrl: (url) async => launchLink(url),
    );
  }
}
