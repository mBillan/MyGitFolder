import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_cate/controllers/user_controller.dart';
import 'package:fan_cate/screens/forgot_password_screen.dart';
import 'package:fan_cate/screens/home_screen.dart';
import 'package:fan_cate/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fan_cate/flutx/flutx.dart';
import 'package:fan_cate/src/auth.dart';
import 'package:fan_cate/src/styledDateTime.dart';

class RegisterController extends FxController {
  late TextEditingController usernameTE = TextEditingController();
  late TextEditingController emailTE = TextEditingController();
  late TextEditingController passwordTE = TextEditingController();

  UserController userController = FxControllerStore.putOrFind(UserController());
  CollectionReference? usersCollection;

  GlobalKey<FormState> formKey = GlobalKey();

  bool loading = false;
  bool showPassword = false;

  RegisterController() {
    save = false;
    usernameTE = TextEditingController(text: '');
    emailTE = TextEditingController(text: '');
    passwordTE = TextEditingController(text: '');
    usersCollection = FirebaseFirestore.instance.collection('users');
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
        UserCredential result =
            await userController.auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (result.user != null) {
          // Update the name in the DB (the result object is not affected)
          await result.user!.updateDisplayName(username);

          await addUserToFirebase(result.user!, username);

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

  Future<void> addUserToFirebase(User user, String username) async {
    // Add the user record to the Firebase Database 'Users' collection
    await usersCollection?.add({
      'uid': user.uid,
      'name': username,
      'email': user.email,
      'profileURL': user.photoURL,
      'timeAdded': currTimeStyled(),
    });
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
