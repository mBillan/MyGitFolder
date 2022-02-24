import 'package:flutter/material.dart';

void showToast(BuildContext context, String text) {
  final scaffold = ScaffoldMessenger.of(context);

  scaffold.showSnackBar(
    SnackBar(margin: const EdgeInsets.only(bottom: 50),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(text)],
      ),
      shape: const StadiumBorder(),
      backgroundColor: Colors.lightGreen,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 1000),
      // padding: const EdgeInsets.all(30),
      // width: 250,
      // action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      // elevation: 100,
      // animation: Animation,
    ),
  );
}
