import 'package:fan_cate/controllers/user_controller.dart';
import 'package:fan_cate/screens/full_app.dart';
import 'package:fan_cate/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import '../flutx/core/state_management/controller_store.dart';

class RootPage extends StatelessWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This widget is the one that navigates the whole application in background
    // It checks if the user is signed in (firebase.auth), then it sends him to the home page
    // Else, it takes him to the sign in page
    UserController userController = FxControllerStore.putOrFind(UserController());


    if(userController.auth.currentUser == null){
      return const SplashScreen();
    } else {
      return FullApp();
    }

  }

}
