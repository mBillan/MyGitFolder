import 'package:fan_cate/data/user.dart';
import 'package:fan_cate/screens/login_screen.dart';
import 'package:fan_cate/screens/profile_edit_screen.dart';
import 'package:fan_cate/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fan_cate/flutx/flutx.dart';

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
              .copyWith(secondary: customTheme.estatePrimary.withAlpha(40))),
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
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true).push(
                                  MaterialPageRoute(
                                      builder: (context) => ProfileEditScreen()),
                                );
                              },
                              splashColor:
                                  customTheme.estatePrimary.withAlpha(40),
                              borderColor: customTheme.estatePrimary,
                              padding: FxSpacing.xy(16, 4),
                              borderRadiusAll: 32,
                              child: FxText.b3("Edit profile",
                                  color: customTheme.estatePrimary))
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
                        "Liked",
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
                        "History",
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
                          user.auth.signOut();
                          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                            ),
                            ModalRoute.withName(''),
                          );
                        },
                        child: FxText.l1(
                          "LOGOUT",
                          color: customTheme.cookifyOnPrimary,
                        ),
                        elevation: 2,
                        backgroundColor: customTheme.estatePrimary,
                      ),
                    )
                  ],
                ),
              ),
              FxSpacing.height(24),
              FxContainer(
                  color: customTheme.estatePrimary.withAlpha(40),
                  padding: FxSpacing.xy(16, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FxTwoToneIcon(
                        FxTwoToneMdiIcons.headset_mic,
                        size: 32,
                        color: customTheme.estatePrimary,
                      ),
                      FxSpacing.width(12),
                      FxText.b3(
                        "Feel Free to Ask, We're ready to Help",
                        color: customTheme.estatePrimary,
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
