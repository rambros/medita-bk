import '/ui/core/flutter_flow/flutter_flow_util.dart';
import '/core/utils/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

export '/ui/core/actions/custom/show_picker_number_format_value.dart' show showPickerNumberFormatValue;

Future checkInternetAccess(BuildContext context) async {
  bool? hasIntenetAccess;
  bool? hasIntenetAccess2;

  hasIntenetAccess = await NetworkUtils.hasInternetAccess();
  FFAppState().hasInternetAccess = hasIntenetAccess;
  while (FFAppState().hasInternetAccess == false) {
    await showDialog(
      context: context,
      builder: (alertDialogContext) {
        return WebViewAware(
          child: AlertDialog(
            title: const Text('Sem acesso à internet'),
            content: const Text(
                'Parece que você está offline. Conecte-se à internet para continuar sua jornada com o MeditaBK.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(alertDialogContext),
                child: const Text('Ok'),
              ),
            ],
          ),
        );
      },
    );
    hasIntenetAccess2 = await NetworkUtils.hasInternetAccess();
    FFAppState().hasInternetAccess = hasIntenetAccess2;
  }
}
