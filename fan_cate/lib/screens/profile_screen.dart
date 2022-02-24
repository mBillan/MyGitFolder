import 'package:fan_cate/screens/data/user.dart';
import 'package:fan_cate/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fan_cate/flutx/flutx.dart';
import 'splash_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User user;
  late CustomTheme customTheme;
  late ThemeData theme;

  bool notification = true, offlineReading = false;

  @override
  void initState() {
    super.initState();
    user = User.getOne();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: theme.copyWith(
          colorScheme: theme.colorScheme
              .copyWith(secondary: customTheme.cookifyPrimary.withAlpha(40))),
      child: SafeArea(
        child: Scaffold(
          body: ListView(
            padding: FxSpacing.fromLTRB(24, 36, 24, 24),
            children: [
              FxContainer(
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image(
                        image: AssetImage(user.image),
                        height: 100,
                        width: 100,
                      ),
                    ),
                    FxSpacing.width(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FxText.b1(user.name, fontWeight: 700),
                          FxSpacing.width(8),
                          FxText.b2(
                            user.email,
                          ),
                          FxSpacing.height(8),
                          FxButton.outlined(
                              onPressed: () {},
                              splashColor:
                                  customTheme.cookifyPrimary.withAlpha(40),
                              borderColor: customTheme.cookifyPrimary,
                              padding: FxSpacing.xy(16, 4),
                              borderRadiusAll: 32,
                              child: FxText.b3("Edit profile",
                                  color: customTheme.cookifyPrimary))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              FxSpacing.height(24),
              FxContainer(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FxText.t2(
                    "Option",
                    fontWeight: 700,
                  ),
                  FxSpacing.height(8),
                  SwitchListTile(
                    dense: true,
                    contentPadding: FxSpacing.zero,
                    inactiveTrackColor:
                        customTheme.cookifyPrimary.withAlpha(100),
                    activeTrackColor: customTheme.cookifyPrimary.withAlpha(150),
                    activeColor: customTheme.cookifyPrimary,
                    title: FxText.b2(
                      "Notifications",
                      letterSpacing: 0,
                    ),
                    onChanged: (value) {
                      setState(() {
                        notification = value;
                      });
                    },
                    value: notification,
                  ),
                  ListTile(
                    dense: true,
                    contentPadding: FxSpacing.zero,
                    visualDensity: VisualDensity.compact,
                    title: FxText.b2(
                      "Language",
                      letterSpacing: 0,
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  SwitchListTile(
                    dense: true,
                    contentPadding: FxSpacing.zero,
                    inactiveTrackColor:
                        customTheme.cookifyPrimary.withAlpha(100),
                    activeTrackColor: customTheme.cookifyPrimary.withAlpha(150),
                    activeColor: customTheme.cookifyPrimary,
                    title: FxText.b2(
                      "Offline Reading",
                      letterSpacing: 0,
                    ),
                    onChanged: (value) {
                      setState(() {
                        offlineReading = value;
                      });
                    },
                    value: offlineReading,
                  ),
                  Divider(
                    thickness: 0.8,
                  ),
                  FxSpacing.height(8),
                  FxText.t2(
                    "Account",
                    fontWeight: 700,
                  ),
                  FxSpacing.height(8),
                  ListTile(
                    dense: true,
                    contentPadding: FxSpacing.zero,
                    visualDensity: VisualDensity.compact,
                    title: FxText.b2(
                      "Personal Information",
                      letterSpacing: 0,
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  ListTile(
                    dense: true,
                    contentPadding: FxSpacing.zero,
                    visualDensity: VisualDensity.compact,
                    title: FxText.b2(
                      "Country",
                      letterSpacing: 0,
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  ListTile(
                    dense: true,
                    contentPadding: FxSpacing.zero,
                    visualDensity: VisualDensity.compact,
                    title: FxText.b2(
                      "Favorite Recipes",
                      letterSpacing: 0,
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  FxSpacing.height(16),
                  Center(
                      child: FxButton.rounded(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                            builder: (context) => SplashScreen()),
                      );
                    },
                    child: FxText.l1(
                      "LOGOUT",
                      color: customTheme.cookifyOnPrimary,
                    ),
                    elevation: 2,
                    backgroundColor: customTheme.cookifyPrimary,
                  ))
                ],
              )),
              FxSpacing.height(24),
              FxContainer(
                  color: customTheme.cookifyPrimary.withAlpha(40),
                  padding: FxSpacing.xy(16, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FxTwoToneIcon(
                        FxTwoToneMdiIcons.headset_mic,
                        size: 32,
                        color: customTheme.cookifyPrimary,
                      ),
                      FxSpacing.width(12),
                      FxText.b3(
                        "Feel Free to Ask, We Ready to Help",
                        color: customTheme.cookifyPrimary,
                        letterSpacing: 0,
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
