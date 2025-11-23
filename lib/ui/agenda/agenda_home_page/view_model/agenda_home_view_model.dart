import 'package:flutter/material.dart';

class AgendaHomeViewModel extends ChangeNotifier {
  // Currently, AgendaHomePage is mainly for navigation and static content.
  // We keep the ViewModel for consistency and future expansion.

  final bool _isLoading = false;
  bool get isLoading => _isLoading;
}
