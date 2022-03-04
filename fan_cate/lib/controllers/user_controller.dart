import 'package:fan_cate/screens/login_screen.dart';
import 'package:fan_cate/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fan_cate/flutx/flutx.dart';

class UserController extends FxController {
  bool loading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  UserController() {
    save = false;
    initUserData();
  }

  Future<void> initUserData() async {
    loading = true;
    update();

    user = auth.currentUser;
    update();

    loading = false;
    update();
  }

  void goToLogin() {
    Navigator.of(context, rootNavigator: true).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  void goToRegister() {
    Navigator.of(context, rootNavigator: true).pushReplacement(
      MaterialPageRoute(
        builder: (context) => RegisterScreen(),
      ),
    );
  }

  void logout() async {
    await auth.signOut();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen()));
  }

  @override
  String getTag() {
    return "user_controller";
  }
}
