import 'package:fan_cate/screens/forgot_password_screen.dart';
import 'package:fan_cate/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fan_cate/flutx/flutx.dart';
import '../controllers/register_controller.dart';
import '../theme/constant.dart';
import '../widgets/text_form_field/text_form_field.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late CustomTheme customTheme;
  late ThemeData theme;

  late RegisterController registerController;
  late OutlineInputBorder enabledBorderOutline;
  late OutlineInputBorder focusedBorderOutline;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
    registerController = FxControllerStore.putOrFind(RegisterController());
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
    return FxBuilder<RegisterController>(
        controller: registerController,
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
                  FxText.h3(
                    "Create an Account",
                    color: customTheme.estatePrimary,
                    fontWeight: 800,
                    textAlign: TextAlign.center,
                  ),
                  FxSpacing.height(32),
                  Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        TextFormFieldStyled(
                          hintText: "Username",
                          controller: controller.usernameTE,
                          validator: controller.validateUsername,
                          icon: Icons.person_outline,
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                        ),
                        FxSpacing.height(24),
                        TextFormFieldStyled(
                          hintText: "Email Address",
                          controller: controller.emailTE,
                          validator: controller.validateEmail,
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          maxLines: 1,
                        ),
                        FxSpacing.height(24),
                        TextFormFieldStyled(
                          hintText: "Password",
                          controller: controller.passwordTE,
                          validator: controller.validatePassword,
                          icon: Icons.lock_outline,
                          obscureText: true,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  FxSpacing.height(16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FxButton.text(
                        padding: FxSpacing.zero,
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen()),
                          );
                        },
                        splashColor: customTheme.estatePrimary.withAlpha(40),
                        child: FxText.b3("Forgot Password?",
                            color: customTheme.estatePrimary)),
                  ),
                  FxSpacing.height(16),
                  FxButton.block(
                    borderRadiusAll: 8,
                    onPressed: registerController.register,
                    backgroundColor: customTheme.estatePrimary,
                    child: FxText.l1(
                      "Create an Account",
                      color: customTheme.cookifyOnPrimary,
                    ),
                  ),
                  FxSpacing.height(16),
                  FxButton.text(
                      onPressed: () {
                        // Pop because we don't want to create a loop of widgets
                        // between the login and register screens
                        Navigator.of(context).pop();
                      },
                      splashColor: customTheme.estatePrimary.withAlpha(40),
                      child: FxText.l2("I already have an account",
                          decoration: TextDecoration.underline,
                          color: customTheme.estatePrimary)),
                  FxSpacing.height(16),
                ],
              ),
            ),
          );
        });
  }
}
