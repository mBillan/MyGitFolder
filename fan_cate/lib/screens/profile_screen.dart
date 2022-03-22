import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_cate/data/user.dart';
import 'package:fan_cate/screens/profile_edit_screen.dart';
import 'package:fan_cate/theme/app_theme.dart';
import 'package:fan_cate/widgets/material/images/image_clip.dart';
import 'package:flutter/material.dart';
import 'package:fan_cate/flutx/flutx.dart';
import '../controllers/user_controller.dart';
import '../loading_effect.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserController userController;

  late CustomTheme customTheme;
  late ThemeData theme;

  bool notification = true, offlineReading = false;

  @override
  void initState() {
    super.initState();
    // Note: putOrFind searches for a previously defined controller from the same type and might use it.
    // put, always generates a new one
    userController = FxControllerStore.put(UserController());
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<UserController>(
        key: widget.key ?? GlobalKey(debugLabel: "ProfileScreen Widget key"),
        controller: userController,
        builder: (controller) {
          return Theme(
            data: theme.copyWith(
                colorScheme: theme.colorScheme.copyWith(
                    secondary: customTheme.estatePrimary.withAlpha(40))),
            child: SafeArea(
              /*
              StreamBuilder<QuerySnapshot>(
              stream: postController.postsStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text(
                      'Something went wrong while loading data from the DB');
                }

               */
              child: StreamBuilder<QuerySnapshot>(
                  stream: userController.usersStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text(
                          'Something went wrong while loading data from the DB');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting ||
                        controller.loading) {
                      return Container(
                        margin: FxSpacing.top(16),
                        child: LoadingEffect.getFavouriteLoadingScreen(
                          context,
                        ),
                      );
                    }
                    User user = User('N/A', 'N/A','');
                    if(snapshot.data!.docs.length == 1) {
                      Map<String, dynamic> data =
                      snapshot.data!.docs[0].data()! as Map<String, dynamic>;
                      user = User(
                        data["email"],
                        data["name"],
                        data["profileURL"],
                      );
                    }

                    return Scaffold(
                      body: _buildBody(controller, user),
                    );
                  }),
            ),
          );
        });
  }

  Widget _buildBody(UserController controller, User user) {
    return ListView(
      padding: FxSpacing.fromLTRB(24, 36, 24, 24),
      children: [
        FxContainer(
          child: Row(
            children: [
              ImageClipRectStyled(
                image: user.image,
                icon: Icons.person,
                borderRadius: BorderRadius.circular(50),
                imageWidth: 80,
                imageHeight: 80,
                onTap: () {
                  print("Opening the image picker");
                },
              ),
              FxSpacing.width(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FxText.b1(controller.user?.displayName ?? '',
                        fontWeight: 700),
                    FxSpacing.width(8),
                    FxText.b2(
                      controller.user?.email ?? '',
                    ),
                    FxSpacing.height(8),
                    FxButton.outlined(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => ProfileEditScreen(
                                userController: controller,
                                user: user,
                              ),
                            ),
                          );
                        },
                        splashColor: customTheme.estatePrimary.withAlpha(40),
                        borderColor: customTheme.estatePrimary,
                        padding: FxSpacing.xy(16, 4),
                        borderRadiusAll: 32,
                        child: FxText.b3("Edit profile",
                            color: customTheme.estatePrimary)),
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
                    controller.logout();
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
    );
  }
}
