import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

void openSnackbar(context, message) {
  final snackbar = SnackBar(
    duration: const Duration(seconds: 1),
    content: Container(
      alignment: Alignment.centerLeft,
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    ),
    action: SnackBarAction(
      label: 'ok'.tr(),
      onPressed: () {},
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}

void openSnackbarSuccess(context, snackMessage) {
  final snackbar = SnackBar(
    backgroundColor: const Color.fromARGB(255, 94, 186, 97),
    duration: const Duration(seconds: 1),
    content: Container(
      alignment: Alignment.centerLeft,
      child: Text(
        snackMessage,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}

void openSnackbarFailure(context, snackMessage) {
  final snackbar = SnackBar(
    duration: const Duration(seconds: 2),
    backgroundColor: Colors.redAccent,
    content: Container(
      alignment: Alignment.centerLeft,
      child: Text(
        snackMessage,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white
        ),
      ),
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}
