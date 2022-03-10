import 'package:fan_cate/controllers/forgot_password_controller.dart';
import 'package:fan_cate/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fan_cate/flutx/flutx.dart';

import '../theme/constant.dart';
import '../widgets/text_form_field/text_form_field.dart';
import 'register_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late ThemeData theme;
  late CustomTheme customTheme;

  late ForgotPasswordController forgotPasswordController;
  late OutlineInputBorder enabledBorderOutline;
  late OutlineInputBorder focusedBorderOutline;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
    forgotPasswordController =
        FxControllerStore.putOrFind(ForgotPasswordController());
    enabledBorderOutline = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(MaterialRadius().small)),
      borderSide: const BorderSide(
        color: Colors.transparent,
      ),
    );
    focusedBorderOutline = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(MaterialRadius().small)),
      borderSide: BorderSide(
        color: customTheme.estatePrimary,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<ForgotPasswordController>(
        controller: forgotPasswordController,
        builder: (controller) {
          return Theme(
            data: theme.copyWith(
                colorScheme: theme.colorScheme.copyWith(
                    secondary: customTheme.estatePrimary.withAlpha(40))),
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
                  Form(
                    key: controller.formKey,
                    child: TextFormFieldStyled(
                      hintText: "Email Address",
                      controller: controller.emailTE,
                      validator: controller.validateEmail,
                      icon: Icons.email_outlined,
                      maxLines: 1,
                    ),
                  ),
                  FxSpacing.height(32),
                  FxButton.block(
                      borderRadiusAll: 8,
                      onPressed: () {
                        controller.forgotPassword();
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
        });
  }
}
