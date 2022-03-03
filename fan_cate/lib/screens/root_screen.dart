import 'package:fan_cate/screens/full_app.dart';
import 'package:fan_cate/screens/splash_screen.dart';
import 'package:flutter/material.dart';

import '../data/user.dart';

class RootPage extends StatelessWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This widget is the one that navigates the whole application in background
    // It checks if the user is signed in (firebase.auth), then it sends him to the home page
    // Else, it takes him to the sign in page
    User user = User.getOne();

    if(user.auth.currentUser == null){
      return const SplashScreen();
    } else {
      return FullApp();
    }

  }

}
