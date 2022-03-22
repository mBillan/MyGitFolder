import 'dart:async';
import 'package:bband/src/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';
import 'duet_maker.dart';
import 'widgets.dart';
import 'app_state.dart';

class Feed extends StatelessWidget {
  Feed({Key? key, required this.title}) : super(key: key);
  final String title;

  // TODO: the selected post should be picked based on an AI model that recommends what post should be shown next to each user
  // int selectedPostIndex = 0;
  bool isPressed = false;
  final _commentsController = TextEditingController();
  final _commentsKey = GlobalKey<FormState>(debugLabel: '_commentsKey');

  Future<void> init() async {}

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Consumer<ApplicationState>(
          builder: (context, appState, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              // for (var message in appState.feedMessages)
              appState.feedMessages
                      .isEmpty //  && appState.selectedPost >= 0 && appState.selectedPost < appState.feedMessages.length
                  ? const Icon(Icons.photo_camera)
                  : Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Scaffold(
                                        appBar: AppBar(
                                          title: const Text("Profile"),
                                        ),
                                        body: Profile(
                                          userId: appState
                                              .feedMessages[
                                                  appState.selectedPost]
                                              .userId,
                                        )),
                                  ));
                            },
                            child: CircleAvatar(
                              child: ClipOval(
                                child: appState.musicians[appState
                                                .feedMessages[
                                                    appState.selectedPost]
                                                .userId] ==
                                            null ||
                                        appState
                                                .musicians[appState
                                                    .feedMessages[
                                                        appState.selectedPost]
                                                    .userId]!
                                                .profile ==
                                            ''
                                    ? const Icon(
                                        Icons.person,
                                        size: 20,
                                      )
                                    : Image.network(appState
                                        .musicians[appState
                                            .feedMessages[appState.selectedPost]
                                            .userId]!
                                        .profile),
                              ),
                              radius: 30,
                            ),
                          ),
                          Expanded(
                            child: Header(appState
                                .feedMessages[appState.selectedPost].name),
                          ),
                          PopupMenuButton(
                              itemBuilder: (context) => [
                                    PopupMenuItem(
                                      child: StyledButton(
                                        child: const IconAndDetail(
                                          Icons.shop_two,
                                          "Duet",
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Duets(
                                                  originalVideo: appState
                                                      .feedMessages[
                                                          appState.selectedPost]
                                                      .multiMedia
                                                      ?.videoController,
                                                  originalImage: appState
                                                      .feedMessages[
                                                          appState.selectedPost]
                                                      .multiMedia
                                                      ?.imageController,
                                                ),
                                              ));
                                        },
                                      ),
                                      value: 1,
                                    ),
                                    const PopupMenuItem(
                                      child: IconAndDetail(
                                        Icons.download_rounded,
                                        "Download",
                                      ),
                                      value: 2,
                                    )
                                  ])
                        ],
                      ),
                      // CircleAvatar(
                      //   key: Key("Post_" + appState.selectedPost.toString()),
                      //   child:
                      ClipRRect(
                        key: UniqueKey(),
                        borderRadius: BorderRadius.circular(20.0), //or 15.0

                        child: appState.feedMessages[appState.selectedPost]
                                    .multiMedia?.imageController !=
                                null
                            ? Image.network(
                                appState.feedMessages[appState.selectedPost]
                                    .multiMedia!.imageController
                                    .toString(),
                                // Show a progressive loading circle
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                              )
                            : appState.feedMessages[appState.selectedPost]
                                        .multiMedia?.videoController !=
                                    null
                                // ? StyledVideoPlayer(
                                //     videoLink: appState
                                //         .feedMessages[appState.selectedPost]
                                //         .videoLink
                                //         .toString())
                                ? DefaultPlayer(
                                    videoLink: appState
                                        .feedMessages[appState.selectedPost]
                                        .multiMedia!
                                        .videoController
                                        .toString())
                                : Container(),
                      ),
                      //   radius: 200,
                      // ),
                      Paragraph(
                          appState.feedMessages[appState.selectedPost].desc),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              IconButton(
                                icon: appState
                                        .feedMessages[appState.selectedPost]
                                        .likes
                                        .contains(FirebaseAuth
                                            .instance.currentUser!.uid)
                                    ?
                                    // The current user liked this post
                                    const Icon(Icons.music_note,
                                        color: Colors.red)
                                    :
                                    // The current user didn't like this post
                                    const Icon(Icons.music_note_outlined,
                                        color: Colors.black),
                                onPressed: () {
                                  bool liked = appState
                                      .feedMessages[appState.selectedPost].likes
                                      .contains(FirebaseAuth
                                          .instance.currentUser!.uid);
                                  if (liked) {
                                    appState.unlikePost(appState
                                        .feedMessages[appState.selectedPost]
                                        .postId);
                                  } else {
                                    appState.likePost(appState
                                        .feedMessages[appState.selectedPost]
                                        .postId);
                                  }
                                },
                              ),
                              Text(appState.feedMessages[appState.selectedPost]
                                  .likes.length
                                  .toString()),
                            ],
                          ),
                          IconButton(onPressed: () {StyledToast("Show/hide comments");}, icon: Icon(Icons.comment_bank_outlined)),
                          IconButton(onPressed: () {StyledToast("Share post");}, icon: Icon(Icons.share)),
                        ],
                      ),
                      const StyledDivider(),

                      // Comments section
                      Expanded(
                          flex: 0,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: appState
                                .feedMessages[appState.selectedPost]
                                .comments
                                .length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  appState.feedMessages[appState.selectedPost]
                                      .comments[index].text,
                                ),
                                trailing: Icon(Icons.linear_scale),
                              );
                            },
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                              width: 150,
                              child: Form(
                                key: _commentsKey,
                                child: TextFormField(
                                  controller: _commentsController,
                                  decoration: const InputDecoration(
                                    hintText: 'enter your comment',
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter your comment address to continue';
                                    }
                                    return null;
                                  },
                                ),
                              )),
                          IconButton(
                            icon: Icon(Icons.add_comment_outlined),
                            onPressed: () async {
                              if (_commentsKey.currentState!.validate()) {
                                StyledToast("Got the following comment " +
                                    _commentsController.value.text);

                                appState
                                    .addComment(
                                        _commentsController.value.text,
                                        appState
                                            .feedMessages[appState.selectedPost]
                                            .postId)
                                    .then(
                                        (value) => _commentsController.clear());
                              }
                            },
                          ),
                        ],
                      ),
                      const StyledDivider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.navigate_before),
                            color: Colors.blueGrey,
                            onPressed: () {
                              appState.loadBeforePost();
                              // selectedPostIndex = (selectedPostIndex + 1)%appState.feedMessages.length;
                              print("Updated the post to " +
                                  appState.selectedPost.toString());
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.refresh),
                            color: Colors.blueGrey,
                            onPressed: () {
                              appState.resetPostIterator();
                              // selectedPostIndex = (selectedPostIndex + 1)%appState.feedMessages.length;
                              print("Updated the post to " +
                                  appState.selectedPost.toString());
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.navigate_next),
                            color: Colors.blueGrey,
                            onPressed: () {
                              appState.loadNextPost();
                              // selectedPostIndex = (selectedPostIndex + 1)%appState.feedMessages.length;
                              print("Updated the post to " +
                                  appState.selectedPost.toString());
                            },
                          )
                        ],
                      ),
                      const StyledDivider(),
                    ]),
              const SizedBox(height: 8),
              // Container(
              //   height: 80,
              //   width: 150,
              //   color: Colors.black12,
              //   // child:   StyledAudioPlayer(audioUrl: 'https://luan.xyz/files/audio/ambient_c_motion.mp3',references: [],),
              //   child: Text("Playing some music"),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
