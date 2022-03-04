import 'package:fan_cate/controllers/user_controller.dart';
import 'package:fan_cate/screens/forgot_password_screen.dart';
import 'package:fan_cate/screens/full_app.dart';
import 'package:fan_cate/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fan_cate/flutx/flutx.dart';
import 'package:fan_cate/src/auth.dart';

class LoginController extends FxController {
  late TextEditingController emailTE = TextEditingController();
  late TextEditingController passwordTE = TextEditingController();

  UserController userController = FxControllerStore.putOrFind(UserController());

  GlobalKey<FormState> formKey = GlobalKey();

  bool loading = false;
  bool showPassword = false;

  LoginController() {
    save = false;
    emailTE = TextEditingController(text: 'marwan.billan@outlook.com');
    passwordTE = TextEditingController(text: '123123123');
  }

  @override
  String getTag() {
    return "login_controller";
  }

  String? validateEmail(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter email";
    } else if (FxStringValidator.isEmail(text)) {
      return "Please enter valid email";
    }
    return null;
  }

  String? validatePassword(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter password";
    } else if (!FxStringValidator.validateStringRange(
      text,
    )) {
      return "Password length must between 8 and 20";
    }
    return null;
  }

  Future<void> login() async {
    loading = true;
    update();

    if (formKey.currentState!.validate()) {
      String email = emailTE.text;
      String password = passwordTE.text;

      try {
        UserCredential result = await userController.auth.signInWithEmailAndPassword(
            email: email, password: password);

        if (result.user != null) {
          showSnackBar("Login is done!");
          goToHomeScreen();
        } else {
          showSnackBar("Something wrong with the login");
        }
      } on FirebaseAuthException catch (error) {
        switch (error.code){
          case Auth.invalidEmail:
            showSnackBar("Invalid email address");
            break;
          case Auth.userNotFound:
            showSnackBar("User is not registered");
            break;
          case Auth.weakPassword:
            showSnackBar("Password is weak");
            break;
          case Auth.wrongPassword:
            showSnackBar("Password is wrong");
            break;
          default:
            showSnackBar(error.code.toString());
        }
      }
      loading = false;
      update();
    }
    loading = false;
    update();
  }

  void goToHomeScreen() {
    Navigator.of(context, rootNavigator: true).pushReplacement(
      MaterialPageRoute(
        builder: (context) => FullApp(),
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

  // void goToGoogleAuth() {
  //   Navigator.of(context, rootNavigator: true).pushReplacement(
  //     MaterialPageRoute(
  //       builder: (context) => GoogleAuthScreen(),
  //     ),
  //   );
  // }

  void goToForgotPassword() {
    Navigator.of(context, rootNavigator: true).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ForgotPasswordScreen(),
      ),
    );
  }

  void showSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }
}
