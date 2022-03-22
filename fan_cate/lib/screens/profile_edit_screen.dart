import 'package:fan_cate/data/user.dart';
import 'package:fan_cate/theme/app_theme.dart';
import 'package:fan_cate/widgets/material/images/image_clip.dart';
import 'package:flutter/material.dart';
import 'package:fan_cate/flutx/flutx.dart';
import '../controllers/user_controller.dart';
import '../loading_effect.dart';
import '../widgets/text_form_field/text_form_field.dart';

class ProfileEditScreen extends StatefulWidget {
  final UserController userController;
  final User user;

  const ProfileEditScreen(
      {Key? key, required this.userController, required this.user})
      : super(key: key);

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late CustomTheme customTheme;
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: theme.copyWith(
          colorScheme: theme.colorScheme
              .copyWith(secondary: customTheme.estatePrimary.withAlpha(40))),
      child: Scaffold(
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (widget.userController.loading) {
      return Container(
          margin: FxSpacing.top(16),
          child: LoadingEffect.getSearchLoadingScreen(
            context,
          ));
    } else {
      return ListView(
        padding: FxSpacing.fromLTRB(24, 100, 24, 0),
        children: [
          FxTwoToneIcon(
            FxTwoToneMdiIcons.update,
            color: customTheme.estatePrimary,
            size: 64,
          ),
          FxSpacing.height(16),
          FxText.h3(
            "Update your info",
            color: customTheme.estatePrimary,
            fontWeight: 800,
            textAlign: TextAlign.center,
          ),
          FxSpacing.height(32),
          Form(
            key: widget.userController.formKey,
            child: Column(
              children: [
                ImageClipRectStyled(
                  image: widget.user.image,
                  icon: Icons.person,
                  borderRadius: BorderRadius.circular(100),
                  imageWidth: 150,
                  imageHeight: 150,
                  onTap: () {
                    print("Opening the image picker");
                  },
                ),
                FxSpacing.height(24),
                TextFormFieldStyled(
                  hintText: "Username",
                  controller: widget.userController.displayNameTE,
                  validator: widget.userController.validateDisplayName,
                  icon: Icons.person_outline,
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                ),
                FxSpacing.height(24),
              ],
            ),
          ),
          FxSpacing.height(16),
          FxButton.block(
            borderRadiusAll: 8,
            onPressed: widget.userController.updateDisplayName,
            backgroundColor: customTheme.estatePrimary,
            child: FxText.l1(
              "Update",
              color: customTheme.cookifyOnPrimary,
            ),
          ),
          FxSpacing.height(16),
          FxButton.text(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              splashColor: customTheme.estatePrimary.withAlpha(40),
              child: FxText.l2("Cancel",
                  decoration: TextDecoration.underline,
                  color: customTheme.estatePrimary)),
          FxSpacing.height(16),
        ],
      );
    }
  }
}
