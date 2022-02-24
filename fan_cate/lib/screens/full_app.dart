import 'package:fan_cate/screens/home_screen.dart';
import 'package:fan_cate/screens/profile_screen.dart';
import 'package:fan_cate/theme/app_theme.dart';
import 'package:fan_cate/flutx/flutx.dart';
import 'package:flutter/material.dart';

class FullApp extends StatefulWidget {
  @override
  _FullAppState createState() => _FullAppState();
}

class _FullAppState extends State<FullApp> {
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
        body: FxBottomNavigationBar(
          outerPadding: const EdgeInsets.only(bottom: 30, top: 20),
          activeTitleStyle: FxTextStyle.b3(
              color: customTheme.estatePrimary, fontWeight: 800),
          itemList: [
            FxBottomNavigationBarItem(
              page: HomeScreen(),
              icon: FxTwoToneIcon(
                FxTwoToneMdiIcons.home,
                color: customTheme.estatePrimary.withAlpha(240),
                size: 24,
              ),
              activeIcon: Icon(
                Icons.cottage,
                color: customTheme.estatePrimary,
                size: 24,
              ),
              title: "Home",
              activeIconColor: customTheme.estatePrimary,
            ),
            FxBottomNavigationBarItem(
              page: const Center(child:  Text("Chat Room"),), // CookifyShowcaseScreen(),
              icon: FxTwoToneIcon(
                FxTwoToneMdiIcons.chat,
                color: customTheme.estatePrimary.withAlpha(240),
                size: 24,
              ),
              activeIcon: Icon(
                Icons.chat_bubble,
                color: customTheme.estatePrimary.withAlpha(240),
                size: 24,
              ),
              title: "Chat",
              activeIconColor: customTheme.estatePrimary,
              activeTitleColor: customTheme.estatePrimary,
            ),
            FxBottomNavigationBarItem(
              page: const Center(child: Text("Add Post Page")), // CookifyShowcaseScreen(),
              icon: FxTwoToneIcon(
                FxTwoToneMdiIcons.post_add,
                color: customTheme.estatePrimary.withAlpha(240),
                size: 24,
              ),
              activeIcon: Icon(
                Icons.add_box_rounded,
                color: customTheme.estatePrimary,
                size: 24,
              ),
              title: "Add Post",
              activeIconColor: customTheme.estatePrimary,
              activeTitleColor: customTheme.estatePrimary,
            ),
            FxBottomNavigationBarItem(
              page: ProfileScreen(),
              icon: FxTwoToneIcon(
                FxTwoToneMdiIcons.person,
                color: customTheme.estatePrimary.withAlpha(240),
                size: 24,
              ),
              activeIcon: Icon(
                Icons.person,
                color: customTheme.estatePrimary,
                size: 24,
              ),
              title: "Setting",
              activeIconColor: customTheme.estatePrimary,
              activeTitleColor: customTheme.estatePrimary,
            ),
          ],
          activeContainerColor: theme.primaryColor.withAlpha(100),
          fxBottomNavigationBarType: FxBottomNavigationBarType.normal,
          backgroundColor: customTheme.card,
          showLabel: false,
          labelSpacing: 8,
          initialIndex: 0,
          labelDirection: Axis.horizontal,
        ),
      ),
    );
  }
}
