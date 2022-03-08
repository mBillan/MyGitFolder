import 'package:fan_cate/screens/forgot_password_screen.dart';
import 'package:fan_cate/screens/full_app.dart';
import 'package:fan_cate/screens/register_screen.dart';
import 'package:fan_cate/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fan_cate/flutx/flutx.dart';
import 'package:fan_cate/src/toast.dart';

import '../controllers/add_post_controller.dart';
import '../loading_effect.dart';

class AddPostScreen extends StatefulWidget {
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  late CustomTheme customTheme;
  late ThemeData theme;
  late AddPostController addPostController;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
    addPostController = FxControllerStore.putOrFind(AddPostController());
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: theme.copyWith(
          colorScheme: theme.colorScheme
              .copyWith(secondary: customTheme.estatePrimary.withAlpha(40))),
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (addPostController.uiLoading) {
      return Container(
        margin: FxSpacing.top(16),
        child: LoadingEffect.getFavouriteLoadingScreen(
          context,
        ),
      );
    } else {
      return Scaffold(
        body: ListView(
          padding: FxSpacing.fromLTRB(24, 100, 24, 0),
          children: [
            FxTwoToneIcon(
              FxTwoToneMdiIcons.post_add,
              color: customTheme.estatePrimary,
              size: 64,
            ),
            FxSpacing.height(16),
            Center(
              child: FxText.h3("Post Something",
                  color: customTheme.estatePrimary, fontWeight: 800),
            ),
            FxSpacing.height(32),
            // Post field
            FxTextField(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              autoFocusedBorder: true,
              textFieldStyle: FxTextFieldStyle.outlined,
              textFieldType: FxTextFieldType.post,
              filled: true,
              fillColor: customTheme.estatePrimary.withAlpha(40),
              enabledBorderColor: customTheme.estatePrimary,
              focusedBorderColor: customTheme.estatePrimary,
              prefixIconColor: customTheme.estatePrimary,
              labelTextColor: customTheme.estatePrimary,
              cursorColor: customTheme.estatePrimary,
            ),
            FxSpacing.height(24),
            FxButton.block(
              borderRadiusAll: 8,
              onPressed: () {
                showToast(context, "Posting in the background");

                addPostController.addPost(context);
                // setState(() {
                //
                // });
                // Navigator.of(context, rootNavigator: true).push(
                //   MaterialPageRoute(builder: (context) => FullApp()),
                // );
              },
              backgroundColor: customTheme.estatePrimary,
              child: FxText.l1(
                "Post",
                color: customTheme.cookifyOnPrimary,
              ),
            ),
          ],
        ),
      );
    }
  }
}
