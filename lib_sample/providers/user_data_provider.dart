import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

final userDataProvider = StateNotifierProvider<UserData, UserModel?>((ref) {
  return UserData();
});

class UserData extends StateNotifier<UserModel?> {
  UserData() : super(null);

  Future getData() async {
    state = await FirebaseService().getUserData();
    debugPrint('Got User Data');
  }
}