import 'package:flutter/material.dart';

void showToast(BuildContext context, String text) {
  final scaffold = ScaffoldMessenger.of(context);

  scaffold.showSnackBar(
    SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(text)],
      ),
      shape: const StadiumBorder(),
      backgroundColor: Colors.lightGreen,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 1000),
      // width: 250,
      // action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      // elevation: 100,
      // animation: Animation,
    ),
  );
}
