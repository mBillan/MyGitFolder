import 'dart:math';

import 'package:fan_cate/theme/app_theme.dart';
import 'package:fan_cate/utils/generator.dart';
import 'package:flutter/material.dart';
import 'package:fan_cate/flutx/flutx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../data/post.dart';

class SocialPostScreen extends StatefulWidget {
  const SocialPostScreen({Key? key, required this.post}) : super(key: key);
  final Post post;

  @override
  _SocialPostScreenState createState() => _SocialPostScreenState();
}

class _SocialPostScreenState extends State<SocialPostScreen> {
  late CustomTheme customTheme;
  late ThemeData theme;
  late bool viewAllComments;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
    viewAllComments = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
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
                      image: AssetImage(widget.post.profileImage),
                      width: 32,
                      height: 32,
                    )),
              ),
              Container(
                margin: FxSpacing.left(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FxText.caption(widget.post.name,
                        color: theme.colorScheme.onBackground, fontWeight: 600),
                    FxText.caption(widget.post.status,
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
                    "${widget.post.time.toString()} min",
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
            image: AssetImage(widget.post.postImage),
            height: MediaQuery.of(context).size.height * 0.45,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          margin: FxSpacing.fromLTRB(24, 12, 24, 0),
          child: Row(
            children: [
              Container(
                child: Icon(
                  MdiIcons.heartOutline,
                  size: 20,
                  color: theme.colorScheme.onBackground.withAlpha(200),
                ),
              ),
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
              (widget.post.comments == null)
                  ? ""
                  : (viewAllComments) ?  "- ${widget.post.comments!.getRange(0, widget.post.comments!.length).join('\n- ')}"
                  :"- ${widget.post.comments!.getRange(0, min(4, widget.post.comments!.length)).join('\n- ')}",
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
                    : "View all ${widget.post.comments?.length} comments",
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
                child: TextFormField(
                  style: FxTextStyle.b2(
                      color: theme.colorScheme.onBackground,
                      fontWeight: 500,
                      fontSize: 12),
                  decoration: InputDecoration(
                      fillColor: customTheme.card,
                      hintStyle: FxTextStyle.caption(
                          color: theme.colorScheme.onBackground,
                          fontWeight: 500,
                          muted: true,
                          letterSpacing: 0,
                          fontSize: 12),
                      filled: true,
                      hintText: "Comment me",
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      isDense: true,
                      contentPadding: FxSpacing.all(12)),
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              Container(
                margin: FxSpacing.left(16),
                child: FxText.caption("Post",
                    color: theme.colorScheme.primary.withAlpha(200),
                    fontWeight: 500),
              )
            ],
          ),
        ),
      ],
    ));
  }
}
