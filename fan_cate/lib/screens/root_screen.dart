import 'package:fan_cate/screens/login_screen.dart';
import 'package:fan_cate/screens/register_screen.dart';
import 'package:fan_cate/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/user.dart';

class RootPage extends StatelessWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This widget is the one that navigates the whole application in background
    // It checks if the user is signed in (firebase.auth), then it sends him to the home page
    // Else, it takes him to the sign in page

    User user = User.getOne();

    // TODO: Check the user's state using firebase.auth
    if(user.name.contains("Marwan")){
      // return FanCateHomeScreen();
      // return FanCateFullApp();
      return SplashScreen();
    } else {
      return LoginScreen();
    }

  }

}

// class LandingPage extends StatelessWidget {
//   const LandingPage({Key key, @required this.databaseBuilder}) : super(key: key);
//   final Database Function(String) databaseBuilder;
//
//   @override
//   Widget build(BuildContext context) {
//     final auth = Provider.of<AuthBase>(context, listen: false);
//     return StreamBuilder<User>(
//       stream: auth.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.active) {
//           final User user = snapshot.data;
//           if (user == null) {
//             return SignInPage.create(context);
//           }
//           return Provider<Database>(
//             create: (_) => databaseBuilder(user.uid),
//             child: HomePage(),
//           );
//         }
//         return Scaffold(
//           body: Center(
//             child: CircularProgressIndicator(),
//           ),
//         );
//       },
//     );
//   }
// }