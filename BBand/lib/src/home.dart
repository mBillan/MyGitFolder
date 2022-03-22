import 'package:flutter/material.dart';
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'authentication.dart';
import "app_state.dart";
import 'widgets.dart';
import 'feed.dart';
import 'profile.dart';
import 'upload_data.dart';
import 'videos.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIcon = 0;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          leading: const Icon(Icons.emoji_people),
          centerTitle: true,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: IconButton(
                onPressed: () {
                  StyledToast("Adding new post");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Data(
                          profileImage: null,
                        ),
                      ));
                },
                icon: Icon(Icons.add_box_outlined),
              ),
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () {
            // TODO: call the ApplicationState().loadNewPost(); somehow
            setState(() {});

            return Future.delayed(const Duration(seconds: 1));
          },
          child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Consumer<ApplicationState>(
                builder: (context, appState, _) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (appState.loginState !=
                        ApplicationLoginState.loggedIn) ...[
                      Authentication(
                        email: appState.email,
                        loginState: appState.loginState,
                        startLoginFlow: appState.startLoginFlow,
                        verifyEmail: appState.verifyEmail,
                        signInWithEmailAndPassword:
                            appState.signInWithEmailAndPassword,
                        cancelRegistration: appState.cancelRegistration,
                        registerAccount: appState.registerAccount,
                        signOut: appState.signOut,
                      )
                    ],
                    // The three dots "..." mean that this list can be empty
                    if (appState.loginState ==
                        ApplicationLoginState.loggedIn) ...[
                      Center(
                          child: IndexedStack(
                        index: _selectedIcon,
                        children: [
                          Feed(title: ''),
                          //
                          Profile(
                              userId: FirebaseAuth.instance.currentUser!.uid),
                        ],
                        sizing: StackFit.expand,
                      )),
                    ] else ...[
                      const Header(
                          "Please sign in/up to see the beauty of this app")
                    ],
                    const StyledDivider(),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black12,
          // elevation: 0,
          iconSize: 20,
          // mouseCursor: SystemMouseCursors.grab,
          // selectedFontSize: 20,
          selectedIconTheme: IconThemeData(color: Colors.blue),
          selectedItemColor: Colors.blue,
          // selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          // unselectedIconTheme: IconThemeData(color: Colors.deepOrangeAccent,),
          unselectedItemColor: Colors.black54,

          showSelectedLabels: false,
          showUnselectedLabels: false,

          // type: BottomNavigationBarType.shifting,

          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',

              // icon: IconButton(icon: Icon(Icons.home_rounded), onPressed: () {print("haha");} ),
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.add),
            //   label: 'Create',
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIcon,
          onTap: _onIconTapped,
        ));
  }

  void _onIconTapped(int index) {
    // Mark the selected icon
    print("Icon $index was selected");
    setState(() {
      _selectedIcon = index;
    });
  }
}
