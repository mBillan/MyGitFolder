import 'dart:math';

import 'package:fan_cate/controllers/post_controller.dart';
import 'package:fan_cate/src/engagement.dart';
import 'package:fan_cate/theme/app_theme.dart';
import 'package:fan_cate/widgets/text_form_field/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:fan_cate/flutx/flutx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../data/post.dart';

class SocialPostScreen extends StatefulWidget {
  const SocialPostScreen(
      {Key? key, required this.postID, required this.postController})
      : super(key: key);
  final String postID;
  final PostController postController;

  @override
  _SocialPostScreenState createState() => _SocialPostScreenState();
}

class _SocialPostScreenState extends State<SocialPostScreen> {
  late CustomTheme customTheme;
  late ThemeData theme;
  late bool viewAllComments;
  late Post post;
  late TextEditingController commentTE;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
    viewAllComments = false;
    post = widget.postController.posts![widget.postID]!;
    commentTE = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
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
                  MdiIcons.heartOutline,
                  size: 20,
                  color: theme.colorScheme.onBackground.withAlpha(200),
                ),
                onTap: () {
                  widget.postController
                      .updateLikes(widget.postID, EngagementType.like);
                  Navigator.pop(context);
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
        // Only show the first 5 comments and hide the others if viewAllComments is false
        Container(
          margin: FxSpacing.fromLTRB(24, 12, 24, 0),
          child: FxText.caption(
              (post.comments == null)
                  ? ""
                  : (viewAllComments)
                      ? "- ${post.comments!.getRange(0, post.comments!.length).join('\n- ')}"
                      : "- ${post.comments!.getRange(0, min(4, post.comments!.length)).join('\n- ')}",
              color: theme.colorScheme.onBackground),
        ),
        Container(
          margin: FxSpacing.fromLTRB(24, 8, 24, 0),
          child: InkWell(
            onTap: () {
              setState(() {
                viewAllComments = !viewAllComments;
              });
            },
            child: FxText.caption(
                (viewAllComments)
                    ? "Collapse comments"
                    : "View all ${post.comments?.length} comments",
                color: theme.colorScheme.onBackground,
                xMuted: true,
                letterSpacing: -0.2),
          ),
        ),
        Container(
          margin: FxSpacing.fromLTRB(24, 16, 24, 0),
          child: Row(
            children: [
              Expanded(
                child: Form(
                  key: widget.postController.formKey,
                  child: Column(
                    children: [
                      TextFormFieldStyled(
                        hintText: "Add comment",
                        controller: commentTE,
                        validator: widget.postController.validateComment,
                        icon: Icons.comment,
                        keyboardType: TextInputType.multiline,
                      ),
                      FxSpacing.height(20),
                      FxButton.block(
                        borderRadiusAll: 8,
                        onPressed: () async {
                          await widget.postController.addComment(
                            context,
                            commentTE.text,
                            widget.postID,
                          );
                          Navigator.pop(context);
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
