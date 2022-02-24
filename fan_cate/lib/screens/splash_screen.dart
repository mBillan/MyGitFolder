import 'package:fan_cate/theme/app_theme.dart';
import 'package:fan_cate/theme/app_notifier.dart';
import 'package:flutter/material.dart';
import 'package:fan_cate/flutx/flutx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'login_screen.dart';
import 'register_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late CustomTheme customTheme;
  late ThemeData theme;

  @override
  void initState() {
    super.initState();

    FxTextStyle.changeFontFamily(GoogleFonts.mali);
    FxTextStyle.changeDefaultFontWeight({
      100: FontWeight.w100,
      200: FontWeight.w200,
      300: FontWeight.w300,
      400: FontWeight.w400,
      500: FontWeight.w500,
      600: FontWeight.w600,
      700: FontWeight.w700,
      800: FontWeight.w800,
      900: FontWeight.w900,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
        builder: (BuildContext context, AppNotifier value, Widget? child) {
          theme = AppTheme.theme;
          customTheme = AppTheme.customTheme;

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theme.copyWith(
                colorScheme: theme.colorScheme
                    .copyWith(secondary: customTheme.estatePrimary.withAlpha(40))),
            home: Scaffold(
              body: Container(
                margin: FxSpacing.fromLTRB(24, 100, 24, 32),
                child: Column(
                  children: [
                    FxText.h3(
                      "Welcome to FanCate",
                      color: customTheme.estatePrimary,
                    ),
                    Expanded(
                      child: Center(
                        child: Image(
                          image: AssetImage(
                              './assets/images/apps/fan_cate/fancate_splash.png'),
                          width: 320,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: FxButton.text(
                              splashColor: customTheme.estatePrimary.withAlpha(40),
                              padding: FxSpacing.y(12),
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true).push(
                                  MaterialPageRoute(
                                      builder: (context) => RegisterScreen()),
                                );
                              },
                              child: FxText.l1(
                                "SIGN UP",
                                color: customTheme.estatePrimary,
                                letterSpacing: 0.5,
                              ),
                            )),
                        Expanded(
                            child: FxButton(
                              elevation: 0,
                              padding: FxSpacing.y(12),
                              borderRadiusAll: 4,
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true).push(
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                );
                              },
                              child: FxText.l1(
                                "LOG IN",
                                color: customTheme.cookifyOnPrimary,
                                letterSpacing: 0.5,
                              ),
                              backgroundColor: customTheme.estatePrimary,
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
