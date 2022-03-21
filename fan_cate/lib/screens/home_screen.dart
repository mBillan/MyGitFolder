import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_cate/controllers/comment_controller.dart';
import 'package:fan_cate/controllers/post_controller.dart';
import 'package:fan_cate/data/user.dart';
import 'package:fan_cate/loading_effect.dart';
import 'package:fan_cate/screens/social_post_screen.dart';
import 'package:fan_cate/theme/app_theme.dart';
import 'package:fan_cate/widgets/custom/image_clip.dart';
import 'package:fan_cate/widgets/custom/post_comments.dart';
import 'package:flutter/material.dart';
import 'package:fan_cate/flutx/flutx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../data/comment.dart';
import '../data/post.dart';
import '../src/engagement.dart';
import '../utils/generator.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User user;

  late CustomTheme customTheme;
  late ThemeData theme;

  late PostController postController;

  @override
  void initState() {
    super.initState();
    user = User.getOne();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;

    postController = FxControllerStore.putOrFind(PostController());
  }

  final List<String> _simpleChoice = [
    "Report",
    "Turn on notification",
    "Copy Link",
    "Share to ...",
    "Unfollow",
    "Mute"
  ];

  @override
  Widget build(BuildContext context) {
    return FxBuilder<PostController>(
      controller: postController,
      builder: (estateHomeController) => Theme(
        data: theme.copyWith(
            colorScheme: theme.colorScheme
                .copyWith(secondary: customTheme.estatePrimary.withAlpha(40))),
        child: SafeArea(
          child: Scaffold(
            body: Container(
              padding: FxSpacing.top(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: FxSpacing.x(16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FxText.h3("${user.name},",
                              color: customTheme.estatePrimary,
                              fontWeight: 800),
                          FxSpacing.height(16),
                          FxText.b2("Latest Update!",
                              color: theme.colorScheme.onBackground,
                              letterSpacing: 0,
                              xMuted: true,
                              fontWeight: 700),
                          FxSpacing.height(10),
                          Container(
                            margin: FxSpacing.top(8),
                            child: const Divider(
                              height: 0,
                            ),
                          ),
                        ]),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: postController.postsStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text(
                            'Something went wrong while loading data from the DB');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          margin: FxSpacing.top(16),
                          child: LoadingEffect.getFavouriteLoadingScreen(
                            context,
                          ),
                        );
                      }

                      postController.reloadPosts(snapshot.data!.docs);

                      return Expanded(
                        child: _buildBody(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          FxSpacing.height(20),
          Column(
            children: buildPosts(),
          ),
        ],
      ),
    );
  }

  List<Widget> buildPosts() {
    List<Widget> postsList = [];

    for (String postID in postController.posts!.keys) {
      postsList.add(singlePost(postID: postID));
    }

    return postsList;
  }

  Widget singlePost({required String postID}) {
    Post post = postController.posts![postID]!;

    // TODO: find a way to get the username by uid (Note, tried to do that but got stuck with the async events)
    String publisherName = post.name;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SocialPostScreen(
              postID: postID,
            ),
          ),
        );
      },
      child: Container(
        margin: FxSpacing.fromLTRB(0, 12, 0, 16),
        child: Column(
          children: [
            Container(
              margin: FxSpacing.fromLTRB(16, 0, 16, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => SocialProfileScreen(post)));
                    },
                    child: ImageClipRectStyled(
                      image: post.profileImage,
                      imageHeight: 40,
                      imageWidth: 40,
                      icon: Icons.person,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  Container(
                    margin: FxSpacing.left(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FxText.caption(publisherName,
                            color: theme.colorScheme.onBackground,
                            fontWeight: 600),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    child: Container(
                        alignment: Alignment.bottomRight,
                        child: FxText.caption(
                          post.time,
                          color: theme.colorScheme.onBackground,
                        )),
                  )
                ],
              ),
            ),
            Container(
              margin: FxSpacing.top(12),
              child:
              // TODO: Update this image to user the styled image
              Image(
                image: AssetImage(
                  post.postImage ?? './assets/images/profile/avatar_place.png',
                ),
                height: 240,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              // padding: FxSpacing.all(10),
              margin: FxSpacing.fromLTRB(10, 0, 16, 5),

              child: FxText.caption(
                post.status,
                fontSize: 13,
                color: theme.colorScheme.onBackground,
                muted: true,
                fontWeight: 500,
              ),
            ),
            Container(
              margin: FxSpacing.fromLTRB(16, 0, 16, 0),
              child: Row(
                children: [
                  Generator.buildOverlaysProfile(
                    images: [
                      './assets/images/profile/avatar_3.jpg',
                      './assets/images/profile/avatar_5.jpg',
                      './assets/images/profile/avatar_2.jpg',
                    ],
                    enabledOverlayBorder: true,
                    overlayBorderColor: customTheme.card,
                    overlayBorderThickness: 1.7,
                    leftFraction: 0.72,
                    size: 24,
                  ),
                  InkWell(
                    child: Icon(
                      (postController.didUserLikedPost(postID))
                          ? MdiIcons.heart
                          : MdiIcons.heartOutline,
                      size: 20,
                      color: (postController.didUserLikedPost(postID))
                          ? Colors.redAccent
                          : theme.colorScheme.onBackground.withAlpha(200),
                    ),
                    onTap: () {
                      EngagementType engagementType =
                          (postController.didUserLikedPost(postID))
                              ? EngagementType.unlike
                              : EngagementType.like;
                      postController.updateLikes(postID, engagementType);
                    },
                  ),
                  FxText.caption(post.likes.toString(),
                      letterSpacing: 0, color: theme.colorScheme.onBackground),
                  Container(
                    margin: FxSpacing.left(16),
                    child: Icon(MdiIcons.commentOutline,
                        size: 20,
                        color: theme.colorScheme.onBackground.withAlpha(200)),
                  ),
                  Container(
                    margin: FxSpacing.left(16),
                    child: Icon(
                      MdiIcons.shareOutline,
                      size: 20,
                      color: theme.colorScheme.onBackground.withAlpha(200),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: PopupMenuButton(
                        itemBuilder: (BuildContext context) {
                          return _simpleChoice.map((String choice) {
                            return PopupMenuItem(
                              value: choice,
                              height: 36,
                              child: FxText.b2(choice,
                                  color: theme.colorScheme.onBackground),
                            );
                          }).toList();
                        },
                        icon: Icon(
                          MdiIcons.dotsVertical,
                          color: theme.colorScheme.onBackground,
                          size: 20,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            PostCommentsSection(postID: postID),
          ],
        ),
      ),
    );
  }
}
