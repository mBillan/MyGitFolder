import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'authentication.dart';
import 'widgets.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'upload_data.dart';

class Profile extends StatefulWidget {
  const Profile({required this.userId});

  final String userId;

  _ProfileState createState() => _ProfileState(this.userId);
}

class _ProfileState extends State<Profile> {
  // with AutomaticKeepAliveClientMixin<Profile> {
  _ProfileState(String userId);

  // const Profile({required this.userId});
  // final String userId;

  @override
  Widget build(BuildContext context) {
    // TODO: update with the real current profile id by adding it as a required param
    String profileId = widget.userId;

    // TODO take the current profile image from the firebase storage
    String? imageLink;
    File? _image;

    return Column(
      children: [
        Consumer<ApplicationState>(
          builder: (context, appState, _) => appState.musicians.isEmpty
              ? const Icon(Icons.downloading)
              : appState.musicians[profileId] == null
                  ? const Center(
                      child: Text(
                      "Something went wrong, the user doesn't exist!",
                    ))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (FirebaseAuth
                                              .instance.currentUser!.uid ==
                                          profileId) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Data(
                                                profileImage: appState
                                                    .musicians[profileId]
                                                    ?.profile,
                                              ),
                                            ));
                                      }
                                    },
                                    child: CircleAvatar(
                                      child: ClipOval(
                                        child: appState.musicians[profileId] !=
                                                    null &&
                                                appState.musicians[profileId]!
                                                        .profile !=
                                                    ''
                                            ? Image.network(appState
                                                .musicians[profileId]!.profile)
                                            : const Icon(
                                                Icons.person,
                                                size: 30,
                                              ),
                                      ),
                                      radius: 30,
                                    ),
                                  ),
                                  Text(
                                    appState.musicians[profileId]!.name,
                                    textScaleFactor: 1.3,
                                  ),
                                ],
                              ),
                              GestureDetector(
                                  child: Column(children: [
                                    Text("Following"),
                                    Text(appState
                                        .musicians[profileId]!.following.length
                                        .toString()),
                                  ]),
                                  onTap: () {
                                    StyledToast(
                                        "Show the people who follow this user");
                                  }),
                              GestureDetector(
                                  child: Column(children: [
                                    Text("Followers"),
                                    Text(appState
                                        .musicians[profileId]!.followers.length
                                        .toString()),
                                  ]),
                                  onTap: () {
                                    StyledToast(
                                        "Show the people whom this user follow");
                                  }),
                              FirebaseAuth.instance.currentUser!.uid ==
                                      profileId
                                  ? Column(children: [
                                      StyledButton(
                                          child: const Text("Edit profile"),
                                          onPressed: () {
                                            StyledToast("Editing profile");
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Data(
                                                  profileImage: appState
                                                      .musicians[profileId]
                                                      ?.profile,
                                                ),
                                              ),
                                            );
                                          }),
                                      if (appState.loginState ==
                                          ApplicationLoginState.loggedIn)
                                        Authentication(
                                          email: appState.email,
                                          loginState: appState.loginState,
                                          startLoginFlow:
                                              appState.startLoginFlow,
                                          verifyEmail: appState.verifyEmail,
                                          signInWithEmailAndPassword: appState
                                              .signInWithEmailAndPassword,
                                          cancelRegistration:
                                              appState.cancelRegistration,
                                          registerAccount:
                                              appState.registerAccount,
                                          signOut: appState.signOut,
                                        ),

                                    ])
                                  : StyledButton(
                                      child:
                                          // check if the currUser follows the user in the currProfile
                                          appState.musicians[profileId]!
                                                  .followers
                                                  .contains(FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid)
                                              ?
                                              // The current user liked this post
                                              const Text("unfollow")
                                              :
                                              // The current user didn't like this post
                                              const Text("follow"),
                                      onPressed: () {
                                        bool followed = appState
                                            .musicians[profileId]!.followers
                                            .contains(FirebaseAuth
                                                .instance.currentUser!.uid);
                                        if (followed) {
                                          appState.unFollowUser(
                                              profileId,
                                              FirebaseAuth
                                                  .instance.currentUser!.uid);
                                        } else {
                                          appState.followUser(
                                              profileId,
                                              FirebaseAuth
                                                  .instance.currentUser!.uid);
                                        }
                                      }),
                            ]),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(width:5),
                            Text(
                              appState.musicians[profileId]!.bio,
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 16,
                        ), //just for spacing

                        const StyledDivider(),

                        // Show all the post of the user
                        for (var message in appState.feedMessages)
                          if (message.userId == profileId)
                            Column(children: [
                              GestureDetector(
                                onTap: () {
                                  File image = File(message
                                      .multiMedia!.imageController
                                      .toString());

                                  // TODO: open a new page where the user can view this content and collab with the artist
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) => Data(profileImage: image ,),
                                  //     )
                                  // );
                                  StyledToast(
                                      "Pressed " + message.desc + " image");
                                },
                                child: Row(children:[ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(20.0), //or 15.0
                                  child: Container(
                                    height: 150.0,
                                    width: 150.0,
                                    color: const Color(0xff979797),
                                    child:
                                        message.multiMedia?.imageController !=
                                                null
                                            ? Image.network(message
                                                .multiMedia!.imageController
                                                .toString())
                                            : const Icon(Icons.hourglass_empty,
                                                color: Colors.white, size: 40),
                                  ),
                                ),
                                Text(message.desc),
                                ]
                                ),
                              ),
                              const StyledDivider(),
                            ]),
                        const SizedBox(height: 8),
                      ],
                    ),
        ),
      ],
    );
  }
}
