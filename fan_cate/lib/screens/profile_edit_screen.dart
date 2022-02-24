import 'package:fan_cate/screens/forgot_password_screen.dart';
import 'package:fan_cate/src/toast.dart';
import 'package:fan_cate/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fan_cate/flutx/flutx.dart';

import '../data/user.dart';
import 'login_screen.dart';

class ProfileEditScreen extends StatefulWidget {
  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late CustomTheme customTheme;
  late ThemeData theme;
  late User user;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
    user = User.getOne();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: theme.copyWith(
          colorScheme: theme.colorScheme
              .copyWith(secondary: customTheme.estatePrimary.withAlpha(40))),
      child: Scaffold(
        body: ListView(
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
            FxTextField(
              labelText: user.name,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              autoFocusedBorder: true,
              textFieldStyle: FxTextFieldStyle.outlined,
              textFieldType: FxTextFieldType.name,
              filled: true,
              fillColor: customTheme.estatePrimary.withAlpha(40),
              enabledBorderColor: customTheme.estatePrimary,
              focusedBorderColor: customTheme.estatePrimary,
              prefixIconColor: customTheme.estatePrimary,
              labelTextColor: customTheme.estatePrimary,
              cursorColor: customTheme.estatePrimary,
            ),
            FxSpacing.height(24),
            FxTextField(
              labelText: user.email,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              autoFocusedBorder: true,
              textFieldStyle: FxTextFieldStyle.outlined,
              textFieldType: FxTextFieldType.email,
              filled: true,
              fillColor: customTheme.estatePrimary.withAlpha(40),
              enabledBorderColor: customTheme.estatePrimary,
              focusedBorderColor: customTheme.estatePrimary,
              prefixIconColor: customTheme.estatePrimary,
              labelTextColor: customTheme.estatePrimary,
              cursorColor: customTheme.estatePrimary,
            ),
            FxSpacing.height(24),
            FxTextField(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              autoFocusedBorder: true,
              textFieldStyle: FxTextFieldStyle.outlined,
              textFieldType: FxTextFieldType.password,
              filled: true,
              fillColor: customTheme.estatePrimary.withAlpha(40),
              enabledBorderColor: customTheme.estatePrimary,
              focusedBorderColor: customTheme.estatePrimary,
              prefixIconColor: customTheme.estatePrimary,
              labelTextColor: customTheme.estatePrimary,
              cursorColor: customTheme.estatePrimary,
            ),
            FxSpacing.height(16),
            FxButton.block(
                borderRadiusAll: 8,
                onPressed: () {
                  showToast(context, "Updated successfully!");
                  Navigator.of(context, rootNavigator: true).pop();
                },
                backgroundColor: customTheme.estatePrimary,
                child: FxText.l1(
                  "Update",
                  color: customTheme.cookifyOnPrimary,
                )),
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
        ),
      ),
    );
  }
}
