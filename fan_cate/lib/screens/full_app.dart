import 'package:fan_cate/screens/add_post.dart';
import 'package:fan_cate/screens/chat_screen.dart';
import 'package:fan_cate/screens/home_screen.dart';
import 'package:fan_cate/screens/profile_screen.dart';
import 'package:fan_cate/theme/app_theme.dart';
import 'package:fan_cate/flutx/flutx.dart';
import 'package:flutter/material.dart';

enum Pages{
  home,
  chat,
  addPost,
  profile
}

class FullApp extends StatefulWidget {
  const FullApp({Key? key, this.page}) : super(key: key);
  final Pages? page;

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
              page: ChatScreen(), // CookifyShowcaseScreen(),
              icon: FxTwoToneIcon(
                FxTwoToneMdiIcons.chat,
                color: customTheme.estatePrimary.withAlpha(240),
                size: 24,
              ),
              activeIcon: Icon(
                Icons.chat,
                color: customTheme.estatePrimary.withAlpha(240),
                size: 24,
              ),
              title: "Chat",
              activeIconColor: customTheme.estatePrimary,
              activeTitleColor: customTheme.estatePrimary,
            ),
            FxBottomNavigationBarItem(
              page: AddPostScreen(),
              icon: FxTwoToneIcon(
                FxTwoToneMdiIcons.add_box,
                color: customTheme.estatePrimary.withAlpha(240),
                size: 24,
              ),
              activeIcon: Icon(
                Icons.add_box,
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
          initialIndex: widget.page?.index ?? 0,
          labelDirection: Axis.horizontal,
        ),
      ),
    );
  }
}
