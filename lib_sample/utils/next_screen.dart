import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NextScreen {
  static void normal(context, page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  static void iOS(context, page) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => page));
  }

  static void closeOthers(context, page) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => page), (route) => false);
  }

  static void replace(context, page) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
  }

  static void popup(context, page) {
    Navigator.push(
      context,
      MaterialPageRoute(fullscreenDialog: true, builder: (context) => page),
    );
  }

  static void replaceAnimation(context, page) {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) =>
          page,
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) =>
          FadeTransition(
        opacity: animation,
        child: child,
      ),
    ));
  }

  static void closeOthersAnimation(context, page) {
    Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        ),
        ((route) => false));
  }

  static void openBottomSheet(context, page, {double maxHeight = 0.95, bool isDismissable = true}) {
    showModalBottomSheet(
      enableDrag: isDismissable,
      isScrollControlled: true,
      isDismissible: isDismissable,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.50,
        maxHeight: MediaQuery.of(context).size.height * maxHeight,
      ),
      context: context,
      builder: (context) => page,
    );
  }
}
