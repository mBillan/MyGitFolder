import 'package:fan_cate/screens/forgot_password_screen.dart';
import 'package:fan_cate/screens/full_app.dart';
import 'package:fan_cate/screens/register_screen.dart';
import 'package:fan_cate/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fan_cate/flutx/flutx.dart';
import 'package:fan_cate/src/toast.dart';

// import 'forgot_password_screen.dart';
// import 'full_app.dart';
// import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late CustomTheme customTheme;
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
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
              FxTwoToneMdiIcons.person,
              color: customTheme.estatePrimary,
              size: 64,
            ),
            FxSpacing.height(16),
            Center(
              child: FxText.h3("Log In",
                  color: customTheme.estatePrimary, fontWeight: 800),
            ),
            FxSpacing.height(32),
            // Email
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
            FxSpacing.height(24),
            // Password
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
            // Forgot password
            Align(
              alignment: Alignment.centerRight,
              child: FxButton.text(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen()),
                    );
                  },
                  padding: FxSpacing.zero,
                  splashColor: customTheme.estatePrimary.withAlpha(40),
                  child: FxText.l2("Forgot Password?",
                      color: customTheme.estatePrimary)),
            ),
            FxSpacing.height(16),
            // Login button
            FxButton.block(
                borderRadiusAll: 8,
                onPressed: () {
                  showToast(context, "Signing in in the background");
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(builder: (context) => FullApp()),
                  );
                },
                backgroundColor: customTheme.estatePrimary,
                child: FxText.l1(
                  "Log In",
                  color: customTheme.cookifyOnPrimary,
                )),
            FxSpacing.height(16),
            // Don't have an account
            FxButton.text(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                        builder: (context) => RegisterScreen()),
                  );
                },
                splashColor: customTheme.estatePrimary.withAlpha(40),
                child: FxText.l2("I don\'t have an account",
                    decoration: TextDecoration.underline,
                    color: customTheme.estatePrimary))
          ],
        ),
      ),
    );
  }
}
