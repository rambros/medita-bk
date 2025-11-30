import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lms_app/configs/features_config.dart';
import 'package:lms_app/services/firebase_service.dart';
import 'package:lms_app/utils/snackbars.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';

class SocialLogins extends StatefulWidget {
  const SocialLogins({super.key, required this.afterSignIn});
  final VoidCallback afterSignIn;

  @override
  State<SocialLogins> createState() => _SocialLoginsState();
}

class _SocialLoginsState extends State<SocialLogins> {
  final googleCtlr = RoundedLoadingButtonController();
  final fbController = RoundedLoadingButtonController();
  final appleController = RoundedLoadingButtonController();

  UserModel _userModel(UserCredential userCredential) {
    final UserModel user = UserModel(
      id: userCredential.user!.uid,
      email: userCredential.user?.email ?? 'No Email',
      name: userCredential.user!.displayName ?? 'No Name',
      createdAt: DateTime.now().toUtc(),
      imageUrl: userCredential.user?.photoURL,
      platform: Platform.isAndroid ? 'Android' : 'iOS',
    );
    return user;
  }

  _validateData(UserCredential userCredential) async {
    bool userExists = await FirebaseService().isUserExists(userCredential.user!.uid);
    if (!userExists) {
      await FirebaseService().saveUserData(_userModel(userCredential)).then((value) async {
        await FirebaseService().updateUserStats();
        widget.afterSignIn();
      });
    } else {
      widget.afterSignIn();
    }
  }

  _handleGoogleSignIn() async {
    googleCtlr.start();
    UserCredential? userCredential = await AuthService().signInWithGoogle().onError((error, stackTrace) {
      googleCtlr.reset();
      return null;
    });
    if (userCredential != null && userCredential.user != null) {
      _validateData(userCredential);
    } else {
      googleCtlr.reset();
    }
  }

  _handleFacebookSignIn() async {
    fbController.start();
    UserCredential? userCredential = await AuthService().signInWithFacebook().onError((error, stackTrace) {
      fbController.reset();
      return null;
    });
    if (userCredential != null && userCredential.user != null) {
      _validateData(userCredential);
    } else {
      fbController.reset();
      if (!mounted) return;
      openSnackbarFailure(context, 'Error on Facebbok Login. Please try again!');
    }
  }

  _handleAppleSignIn() async {
    appleController.start();
    UserCredential? userCredential = await AuthService().signInWithApple().onError((error, stackTrace) {
      appleController.reset();
      return null;
    });
    if (userCredential != null && userCredential.user != null) {
      _validateData(userCredential);
    } else {
      appleController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        RoundedLoadingButton(
          controller: googleCtlr,
          animateOnTap: false,
          color: Colors.blueAccent,
          elevation: 0,
          borderRadius: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(FontAwesomeIcons.google, color: Colors.white),
              const SizedBox(width: 15),
              Text(
                'Sign In With Google',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
              )
            ],
          ),
          onPressed: () => _handleGoogleSignIn(),
        ),
        Visibility(
          visible: isFacebookLoginEnabled,
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: RoundedLoadingButton(
              controller: fbController,
              animateOnTap: false,
              color: Colors.indigo,
              elevation: 0,
              borderRadius: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(FontAwesomeIcons.facebook, color: Colors.white),
                  const SizedBox(width: 15),
                  Text(
                    'Sign In With Facebook',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                  )
                ],
              ),
              onPressed: () => _handleFacebookSignIn(),
            ),
          ),
        ),
        Visibility(
          visible: Platform.isIOS,
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: RoundedLoadingButton(
                controller: appleController,
                animateOnTap: false,
                color: Colors.grey.shade800,
                elevation: 0,
                borderRadius: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(FontAwesomeIcons.apple, color: Colors.white),
                    const SizedBox(width: 15),
                    Text(
                      'Sign In With Apple',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                    )
                  ],
                ),
                onPressed: () => _handleAppleSignIn()),
          ),
        ),
      ],
    );
  }
}
