import 'package:fan_cate/data/user.dart' as data;
import 'package:fan_cate/screens/forgot_password_screen.dart';
import 'package:fan_cate/screens/home_screen.dart';
import 'package:fan_cate/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fan_cate/flutx/flutx.dart';
import 'package:fan_cate/src/auth.dart';

class RegisterController extends FxController {
  late TextEditingController usernameTE = TextEditingController();
  late TextEditingController emailTE = TextEditingController();
  late TextEditingController passwordTE = TextEditingController();

  // Using a prefix for the User class since firebase_auth also uas the same class name
  data.User user = data.User.getOne();

  GlobalKey<FormState> formKey = GlobalKey();

  bool loading = false;
  bool showPassword = false;

  RegisterController() {
    save = false;
    usernameTE = TextEditingController(text: '');
    emailTE = TextEditingController(text: '');
    passwordTE = TextEditingController(text: '');
  }

  @override
  String getTag() {
    return "register_controller";
  }

  String? validateUsername(String? username) {
    const int minLength = 4, maxLength = 20;
    if (username == null || username.isEmpty) {
      return "Please enter email";
    }
    if (FxStringValidator.isSpecialCharacterIncluded(username)) {
      return "Please don't use special characters";
    }
    if (!FxStringValidator.validateStringRange(
        username, minLength, maxLength)) {
      return "Username length must between $minLength and $maxLength";
    }
    return null;
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

  Future<void> register() async {
    loading = true;
    update();

    if (formKey.currentState!.validate()) {
      String username = usernameTE.text;
      String email = emailTE.text;
      String password = passwordTE.text;

      try {
        UserCredential result = await user.auth.createUserWithEmailAndPassword(
            email: email, password: password);

        if (result.user != null) {
          showSnackBar("Registration is done!");
          Navigator.of(context).pop();
        } else {
          showSnackBar("Something wrong with the registration");
        }
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case Auth.emailAlreadyInUse:
            showSnackBar("Email address is already in use");
            break;
          case Auth.invalidEmail:
            showSnackBar("Invalid email address");
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
        builder: (context) => HomeScreen(),
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
