import 'dart:developer';

import 'package:fan_cate/controllers/user_controller.dart';
import 'package:fan_cate/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:fan_cate/flutx/flutx.dart';

class ForgotPasswordController extends FxController {
  late TextEditingController emailTE;
  GlobalKey<FormState> formKey = GlobalKey();

  bool loading = false;
  UserController userController = FxControllerStore.putOrFind(UserController());


  @override
  void initState() {
    super.initState();
    emailTE = TextEditingController(text: '');
  }

  String? validateEmail(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter email";
    } else if (FxStringValidator.isEmail(text)) {
      return "Please enter valid email";
    }
    return null;
  }

  Future<void> forgotPassword() async {
    loading = true;
    update();

    if (formKey.currentState!.validate()) {
      String email = emailTE.text;

      try {
        await userController.auth.sendPasswordResetEmail(email: email);
        showSnackBar("Check Email. We sent you reset password link");
        Navigator.pop(context);
      } catch (e) {
        log(e.toString());
      }

      loading = false;
      update();
    }
    loading = false;
    update();
  }

  void goToRegisterScreen() {
    Navigator.of(context, rootNavigator: true).pushReplacement(
      MaterialPageRoute(
        builder: (context) => RegisterScreen(),
      ),
    );
  }

  void showSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  @override
  String getTag() {
    return "forgot_password_controller";
  }
}
