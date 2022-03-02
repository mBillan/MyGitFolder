import 'package:fan_cate/screens/login_screen.dart';
import 'package:fan_cate/src/toast.dart';
import 'package:fan_cate/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fan_cate/flutx/flutx.dart';

// import 'full_app.dart';
import 'register_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  late ThemeData theme;
  late CustomTheme customTheme;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: theme.copyWith(
          colorScheme: theme.colorScheme
              .copyWith(secondary: customTheme.estatePrimary.withAlpha(40))),
      child: Scaffold(
        body: ListView(
          padding: FxSpacing.fromLTRB(24, 200, 24, 0),
          children: [
            FxTwoToneIcon(
              FxTwoToneMdiIcons.person,
              color: customTheme.estatePrimary,
              size: 64,
            ),
            FxSpacing.height(16),
            FxText.h3(
              "Forgot Password",
              color: customTheme.estatePrimary,
              fontWeight: 800,
              textAlign: TextAlign.center,
            ),
            FxSpacing.height(32),
            FxTextField(
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
            FxSpacing.height(32),
            FxButton.block(
                borderRadiusAll: 8,
                onPressed: () {
                  showToast(context, "Check your email to reset your password");
                  Navigator.of(context, rootNavigator: true).pop();
                },
                backgroundColor: customTheme.estatePrimary,
                child: FxText.l1(
                  "Forgot Password",
                  color: customTheme.cookifyOnPrimary,
                )),
            FxSpacing.height(16),
            FxButton.text(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                        builder: (context) => RegisterScreen()),
                  );
                },
                splashColor: customTheme.estatePrimary.withAlpha(40),
                child: FxText.b3("I don\'t have an account",
                    decoration: TextDecoration.underline,
                    color: customTheme.estatePrimary))
          ],
        ),
      ),
    );
  }
}
