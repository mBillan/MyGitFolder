import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_cate/controllers/comment_controller.dart';
import 'package:fan_cate/data/comment.dart';
import 'package:fan_cate/flutx/core/state_management/builder.dart';
import 'package:fan_cate/flutx/core/state_management/controller_store.dart';
import 'package:fan_cate/flutx/utils/spacing.dart';
import 'package:fan_cate/flutx/widgets/text/text.dart';
import 'package:fan_cate/loading_effect.dart';
import 'package:fan_cate/theme/app_theme.dart';
import 'package:flutter/material.dart';

class PostCommentsSection extends StatefulWidget {
  final String postID;

  const PostCommentsSection({
    Key? key,
    required this.postID,
  }) : super(key: key);

  @override
  _PostCommentsSectionState createState() => _PostCommentsSectionState();
}

class _PostCommentsSectionState extends State<PostCommentsSection> {
  late ThemeData theme;
  late bool viewAllComments;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    viewAllComments = false;
  }

  @override
  Widget build(BuildContext context) {
    return buildPostComments(postID: widget.postID);
  }

  Widget buildPostComments({required String postID}) {
    // convert comments to be commentsID
    List<Widget> commentsWidgets = [];

    return FxBuilder<CommentController>(
        controller: FxControllerStore.put(CommentController(postID)),
        builder: (commentController) {
          return StreamBuilder<QuerySnapshot>(
            stream: commentController.commentsStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text(
                  'Something went wrong while loading data from the DB',
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  margin: FxSpacing.top(16),
                  child: LoadingEffect.getFavouriteLoadingScreen(
                    context,
                  ),
                );
              }

              commentController.reloadComments(snapshot.data!.docs);
              // Show maximum 5 comments if viewAllComments is off. Otherwise show all comments
              int maxComments = (viewAllComments)
                  ? commentController.comments?.length ?? 0
                  : min(3, commentController.comments?.length ?? 0);

              Iterable<String> commentIDs = commentController.comments?.keys
                      .toList()
                      .getRange(0, maxComments) ??
                  [];

              // Convert each comment into a widget
              for (String commentID in commentIDs) {
                commentsWidgets.add(singleComment(
                    comment: commentController.comments?[commentID]));
              }

              return Container(
                alignment: AlignmentDirectional.topStart,
                margin: FxSpacing.fromLTRB(16, 0, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: commentsWidgets +
                      [
                        FxSpacing.height(10),
                        InkWell(
                          onTap: () {
                            setState(() {
                              viewAllComments = !viewAllComments;
                            });
                          },
                          child: FxText.caption(
                            (viewAllComments)
                                ? "Collapse comments"
                                : "View all ${commentController.comments?.length} comments",
                            color: theme.colorScheme.onBackground,
                            xMuted: true,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                ),
              );
            },
          );
        });
  }

  Widget singleComment({required Comment? comment}) {
    if (comment == null) {
      return Container();
    }

    return Container(
      margin: FxSpacing.top(4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // TODO: Add the name of the commenter
          // FxText.b2(username,
          //     color: theme.colorScheme.onBackground, fontWeight: 700),
          Expanded(
            child: Container(
              child: FxText.caption(
                "- ${comment.text}",
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
