import 'package:fan_cate/screens/forgot_password_screen.dart';
import 'package:fan_cate/screens/full_app.dart';
import 'package:fan_cate/screens/register_screen.dart';
import 'package:fan_cate/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fan_cate/flutx/flutx.dart';
import 'package:fan_cate/src/toast.dart';

import '../controllers/add_post_controller.dart';
import '../loading_effect.dart';
import '../widgets/text_form_field/text_form_field.dart';

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
    return FxBuilder<AddPostController>(
        controller: addPostController,
        builder: (controller) {
          return Theme(
            data: theme.copyWith(
                colorScheme: theme.colorScheme.copyWith(
                    secondary: customTheme.estatePrimary.withAlpha(40))),
            child: _buildBody(),
          );
        });
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
            Form(
              key: addPostController.formKey,
              child: Column(
                children: [
                  TextFormFieldStyled(
                    hintText: "Post",
                    controller: addPostController.statusTE,
                    validator: addPostController.validateStatus,
                    icon: Icons.post_add,
                    keyboardType: TextInputType.multiline,
                  ),
                ],
              ),
            ),
            FxSpacing.height(24),
            FxButton.block(
              borderRadiusAll: 8,
              onPressed: () {
                addPostController.addPost(context);
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
