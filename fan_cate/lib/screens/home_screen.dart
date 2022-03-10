import 'dart:math';
import 'dart:ui';

import 'package:fan_cate/controllers/post_controller.dart';
import 'package:fan_cate/data/user.dart';
import 'package:fan_cate/loading_effect.dart';
import 'package:fan_cate/screens/donation_screen.dart';
import 'package:fan_cate/screens/social_post_screen.dart';
import 'package:fan_cate/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fan_cate/flutx/flutx.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../data/post.dart';
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
                  Expanded(
                    child: _buildBody(),
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
    if (postController.uiLoading) {
      return Container(
        margin: FxSpacing.top(16),
        child: LoadingEffect.getFavouriteLoadingScreen(
          context,
        ),
      );
    } else {
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
  }

  List<Widget> buildPosts() {
    List<Widget> postsList = [];

    for (Post post in postController.posts!) {
      postsList.add(singlePost(post: post));
    }

    return postsList;
  }

  Widget singlePost({required Post post}) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SocialPostScreen(post: post)));
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
                    child: Container(
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          child: Image(
                            image: AssetImage(post.profileImage),
                            width: 32,
                            height: 32,
                          )),
                    ),
                  ),
                  Container(
                    margin: FxSpacing.left(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FxText.caption(post.name,
                            color: theme.colorScheme.onBackground,
                            fontWeight: 600),
                        FxText.caption(post.status,
                            fontSize: 12,
                            color: theme.colorScheme.onBackground,
                            muted: true,
                            fontWeight: 500),
                      ],
                    ),
                  ),
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
              child: Image(
                image: AssetImage(
                  post.postImage ?? './assets/images/profile/avatar_place.png',
                ),
                height: 240,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
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
                      size: 24),
                  Container(
                    margin: FxSpacing.left(4),
                    child: FxText.caption(post.likes.toString(),
                        letterSpacing: 0,
                        color: theme.colorScheme.onBackground),
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
            buildComments(comments: post.comments),
          ],
        ),
      ),
    );
  }

  Widget buildComments({required List<String>? comments}) {
    List<Widget> commentsWidgets = [];

    // Take only the first 3 comments
    for (String comment in comments!.getRange(0, min(3, comments.length))) {
      commentsWidgets.add(singleComment(comment: comment));
    }

    return Container(
      alignment: AlignmentDirectional.topStart,
      margin: FxSpacing.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: commentsWidgets +
            [
              FxSpacing.height(10),
              FxText.caption(
                "Press for more comments",
                color: theme.colorScheme.onBackground,
                xMuted: true,
              )
            ],
      ),
    );
  }

  Widget singleComment({required String comment, String username = "Mar B"}) {
    return Container(
      margin: FxSpacing.top(4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FxText.b2(username,
              color: theme.colorScheme.onBackground, fontWeight: 700),
          Expanded(
            child: Container(
              margin: FxSpacing.left(8),
              child: FxText.caption(
                // Generator.getDummyText(5, withEmoji: true),
                comment,
                color: theme.colorScheme.onBackground,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
      ),
    );
  }
}
