import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_cate/data/user.dart';
import 'package:fan_cate/screens/full_app.dart';
import 'package:fan_cate/screens/login_screen.dart';
import 'package:fan_cate/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:fan_cate/flutx/flutx.dart';

class UserController extends FxController {
  bool loading = false;
  firebase_auth.FirebaseAuth auth = firebase_auth.FirebaseAuth.instance;
  firebase_auth.User? user;
  GlobalKey<FormState> formKey = GlobalKey();
  late TextEditingController displayNameTE;

  Map<String, User>? users;

  CollectionReference? usersCollection;
  Stream<QuerySnapshot>? usersStream;

  UserController() {
    save = false;
    initUserData();
  }

  Future<void> initUserData() async {
    loading = true;
    update();

    user = auth.currentUser;
    usersCollection = FirebaseFirestore.instance.collection('users');
    usersStream =
        usersCollection?.where('uid', isEqualTo: user?.uid).snapshots();

    displayNameTE = TextEditingController(text: auth.currentUser?.displayName);

    update();

    loading = false;
    update();
  }

  void reloadCurrUser() {
    user = auth.currentUser;
    update();
  }

  Future<void> updateDisplayName() async {
    loading = true;
    update();

    if (formKey.currentState!.validate()) {
      await user?.updateDisplayName(displayNameTE.text);
      updateUserNameInDB(displayNameTE.text);

      update();
      showSnackBar("Updated successfully");
      goToProfile();
    }

    loading = false;
    update();
  }

  void updateUserNameInDB(String newName) {
    usersCollection!
        .where('uid', isEqualTo: user!.uid)
        .get()
        .then((QuerySnapshot snap) {
      if (snap.docs.isNotEmpty) {
        usersCollection!.doc(snap.docs[0].id).update(
          {
            "name": newName,
          },
        );
      }
    });
  }

  void goToProfile() {
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const FullApp(page: Pages.profile),
        ),
        (route) => false);
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
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  @override
  String getTag() {
    return "user_controller";
  }

  String? validateDisplayName(String? displayName) {
    const int minLength = 4, maxLength = 20;
    if (displayName == null || displayName.isEmpty) {
      return "Please enter email";
    }
    if (FxStringValidator.isSpecialCharacterIncluded(displayName)) {
      return "Please don't use special characters";
    }
    if (!FxStringValidator.validateStringRange(
        displayName, minLength, maxLength)) {
      return "Username length must between $minLength and $maxLength";
    }
    return null;
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
