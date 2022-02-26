import 'package:fan_cate/screens/forgot_password_screen.dart';
import 'package:fan_cate/screens/full_app.dart';
import 'package:fan_cate/screens/register_screen.dart';
import 'package:fan_cate/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fan_cate/flutx/flutx.dart';
import 'package:fan_cate/src/toast.dart';


class DonationScreen extends StatefulWidget {
  @override
  _DonationScreenState createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
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
              FxTwoToneMdiIcons.payment,
              color: customTheme.estatePrimary,
              size: 64,
            ),
            FxSpacing.height(16),
            Center(
              child: FxText.h3("Support us by your donation",
                  color: customTheme.estatePrimary, fontWeight: 800),
            ),
            FxSpacing.height(32),
            FxTextField(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              autoFocusedBorder: true,
              textFieldStyle: FxTextFieldStyle.outlined,
              textFieldType: FxTextFieldType.payment,
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
                  showToast(context, "Processing the payment in the background");
                  setState(() {

                  });
                  // Navigator.of(context, rootNavigator: true).push(
                  //   MaterialPageRoute(builder: (context) => FullApp()),
                  // );
                },
                backgroundColor: customTheme.estatePrimary,
                child: FxText.l1(
                  "Donate",
                  color: customTheme.cookifyOnPrimary,
                ),),
          ],
        ),
      ),
    );
  }
}
