import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_cate/controllers/post_controller.dart';
import 'package:fan_cate/src/engagement.dart';
import 'package:fan_cate/theme/app_theme.dart';
import 'package:fan_cate/widgets/custom/post_comments.dart';
import 'package:fan_cate/widgets/text_form_field/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:fan_cate/flutx/flutx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../data/post.dart';
import '../loading_effect.dart';

class SocialPostScreen extends StatefulWidget {
  const SocialPostScreen({Key? key, required this.postID}) : super(key: key);
  final String postID;

  @override
  _SocialPostScreenState createState() => _SocialPostScreenState();
}

class _SocialPostScreenState extends State<SocialPostScreen> {
  late CustomTheme customTheme;
  late ThemeData theme;
  late bool viewAllComments;
  late Post post;
  late TextEditingController commentTE;
  late PostController postController;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
    viewAllComments = false;

    // Init a new post controller for the single post screen
    // Note: when the single post is updated, both controllers (in the single post screen and the home screen) call reloadPosts
    postController = FxControllerStore.put(PostController());
    commentTE = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<PostController>(
        controller: postController,
        builder: (context) {
          return Scaffold(
            body: StreamBuilder<QuerySnapshot>(
              stream: postController.postsStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text(
                      'Something went wrong while loading data from the DB');
                }

                if (snapshot.connectionState == ConnectionState.waiting ||
                    postController.uiLoading) {
                  return Container(
                    margin: FxSpacing.top(16),
                    child: LoadingEffect.getFavouriteLoadingScreen(
                      context,
                    ),
                  );
                }

                postController.reloadPosts(snapshot.data!.docs);
                post = postController.posts![widget.postID]!;

                return _buildBody();
              },
            ),

            // _buildBody(),
          );
        });
  }

  Widget _buildBody() {
    return ListView(
      padding: FxSpacing.top(FxSpacing.safeAreaTop(context) + 20),
      children: [
        Container(
          margin: FxSpacing.fromLTRB(16, 0, 16, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    child: Image(
                      image: AssetImage(post.profileImage),
                      width: 32,
                      height: 32,
                    )),
              ),
              Container(
                margin: FxSpacing.left(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FxText.caption(post.name,
                        color: theme.colorScheme.onBackground, fontWeight: 600),
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
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          margin: FxSpacing.top(12),
          child: Image(
            image: AssetImage(
                post.postImage ?? './assets/images/profile/avatar_place.png'),
            height: MediaQuery.of(context).size.height * 0.45,
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
          margin: FxSpacing.fromLTRB(24, 12, 24, 0),
          child: Row(
            children: [
              InkWell(
                child: Icon(
                  (postController.didUserLikedPost(widget.postID))
                      ? MdiIcons.heart
                      : MdiIcons.heartOutline,
                  size: 20,
                  color: (postController.didUserLikedPost(widget.postID))
                      ? Colors.redAccent
                      : theme.colorScheme.onBackground.withAlpha(200),
                ),
                onTap: () {
                  EngagementType engagementType =
                      (postController.didUserLikedPost(widget.postID))
                          ? EngagementType.unlike
                          : EngagementType.like;
                  postController.updateLikes(widget.postID, engagementType);
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
                  alignment: Alignment.bottomRight,
                  child: FxText.caption("7,327 views",
                      color: theme.colorScheme.onBackground, fontWeight: 600),
                ),
              )
            ],
          ),
        ),
        PostCommentsSection(postID: widget.postID),
        Container(
          margin: FxSpacing.fromLTRB(24, 16, 24, 0),
          child: Row(
            children: [
              Expanded(
                child: Form(
                  key: postController.formKey,
                  child: Column(
                    children: [
                      TextFormFieldStyled(
                        hintText: "Add comment",
                        controller: commentTE,
                        validator: postController.validateComment,
                        icon: Icons.comment,
                        keyboardType: TextInputType.multiline,
                      ),
                      FxSpacing.height(20),
                      FxButton.block(
                        borderRadiusAll: 8,
                        onPressed: () async {
                          await postController.addComment(
                            context,
                            commentTE.text,
                            widget.postID,
                          );
                        },
                        backgroundColor: customTheme.estatePrimary,
                        child: FxText.l1(
                          "Add",
                          color: customTheme.cookifyOnPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
