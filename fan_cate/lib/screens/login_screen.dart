import 'package:fan_cate/screens/forgot_password_screen.dart';
import 'package:fan_cate/screens/register_screen.dart';
import 'package:fan_cate/theme/app_theme.dart';
import 'package:fan_cate/theme/constant.dart';
import 'package:fan_cate/widgets/text_form_field/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:fan_cate/flutx/flutx.dart';

import '../controllers/login_controller.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late CustomTheme customTheme;
  late ThemeData theme;

  late LoginController loginController;
  late OutlineInputBorder enabledBorderOutline;
  late OutlineInputBorder focusedBorderOutline;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
    loginController = FxControllerStore.putOrFind(LoginController());
    enabledBorderOutline = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(MaterialRadius().small)),
      borderSide: const BorderSide(
        color: Colors.transparent,
      ),
    );
    focusedBorderOutline = OutlineInputBorder(
      borderRadius:
      BorderRadius.all(Radius.circular(MaterialRadius().small)),
      borderSide: BorderSide(
        color:
        customTheme.estatePrimary,
      ),
    );
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<LoginController>(
        controller: loginController,
        builder: (controller) {
          return Theme(
            data: theme.copyWith(
                colorScheme: theme.colorScheme.copyWith(
                    secondary: customTheme.estatePrimary.withAlpha(40))),
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
                  Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        TextFormFieldStyled(
                            hintText: "Email Address",
                            controller: controller.emailTE,
                            validator: controller.validateEmail,
                            icon: Icons.email_outlined),
                        FxSpacing.height(24),
                        TextFormFieldStyled(
                            hintText: "Password",
                            controller: controller.passwordTE,
                            validator: controller.validatePassword,
                            icon: Icons.lock_outline,
                          obscureText: true,
                        ),
                      ],
                    ),
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
                        controller.login();
                      },
                      backgroundColor: customTheme.estatePrimary,
                      child: FxText.l1(
                        "Log In",
                        color: customTheme.estateOnPrimary,
                      )),
                  FxSpacing.height(16),
                  // Don't have an account
                  FxButton.text(
                      onPressed: () {
                        setState(() {

                        });
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
        });
  }
}
