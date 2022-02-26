import 'package:fan_cate/controllers/post_controller.dart';
import 'package:fan_cate/data/user.dart';
import 'package:fan_cate/loading_effect.dart';
import 'package:fan_cate/screens/donation_screen.dart';
import 'package:fan_cate/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fan_cate/flutx/flutx.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../data/post.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User user;

  // late List<Post> posts;
  late CustomTheme customTheme;
  late ThemeData theme;

  late PostController postController;

  @override
  void initState() {
    super.initState();
    user = User.getOne();
    // posts = Post.postsList();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;

    postController = FxControllerStore.putOrFind(PostController());
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<PostController>(
      controller: postController,
      builder: (estateHomeController) => Theme(
        data: theme.copyWith(
            colorScheme: theme.colorScheme
                .copyWith(secondary: customTheme.estatePrimary.withAlpha(40))),
        child: SafeArea(
          child: Scaffold(
            body: Container(
              padding: FxSpacing.top(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: FxSpacing.x(16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FxText.h3("${user.name},",
                              color: customTheme.estatePrimary,
                              fontWeight: 800),
                          FxSpacing.height(16),
                          FxText.b2("Latest Update!",
                              color: theme.colorScheme.onBackground,
                              letterSpacing: 0,
                              xMuted: true,
                              fontWeight: 700),
                          FxSpacing.height(10),
                          FxTextField(
                            contentPadding: FxSpacing.horizontal(
                              24,
                            ),
                            textFieldStyle: FxTextFieldStyle.outlined,
                            labelText: 'Search ...',
                            focusedBorderColor: customTheme.estatePrimary,
                            cursorColor: customTheme.estatePrimary,
                            labelStyle: FxTextStyle.b3(
                                color: theme.colorScheme.onBackground,
                                xMuted: true),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            filled: true,
                            fillColor: customTheme.estatePrimary.withAlpha(40),
                            suffixIcon: Icon(
                              FeatherIcons.search,
                              color: customTheme.estatePrimary,
                              size: 20,
                            ),
                          ),
                        ]),
                  ),
                  Expanded(
                    child: _buildBody(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (postController.uiLoading) {
      return Container(
        margin: FxSpacing.top(16),
        child: LoadingEffect.getFavouriteLoadingScreen(
          context,
        ),
      );
    } else {
      return SingleChildScrollView(
        padding: FxSpacing.horizontal(
          24,
        ),
        child: Column(
          children: [
            FxSpacing.height(20),
            Column(
              children: buildPosts(),
            ),
          ],
        ),
      );
    }
  }

  List<Widget> buildPosts() {
    List<Widget> list = [];

    for (Post post in postController.posts!) {
      list.add(singlePost(post));
    }

    return list;
  }

  Widget singlePost(Post post) {
    return FxContainer(
      onTap: () {
        // Navigator.of(context, rootNavigator: true).push(
        //     MaterialPageRoute(builder: (context) => CookifyRecipeScreen()));
      },
      color: Colors.transparent,
      padding: FxSpacing.bottom(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Image(
                image: AssetImage(post.image),
              ),
            ),
          ),
          FxSpacing.height(8),
          FxText.b1(post.text, fontWeight: 700, letterSpacing: 0),
          // FxText.b3(post.body,
          //     muted: true, fontWeight: 500, letterSpacing: -0.1),
          FxSpacing.height(16),
          Row(
            children: [
              Icon(
                Icons.favorite_border,
                size: 16,
                color: theme.colorScheme.onBackground.withAlpha(200),
              ),
              FxSpacing.width(4),
              FxText.b3(post.likes.toString(), muted: true),
              FxSpacing.width(16),
              Icon(
                Icons.schedule,
                size: 16,
                color: theme.colorScheme.onBackground.withAlpha(200),
              ),
              FxSpacing.width(4),
              FxText.b3(post.time + "'", muted: true),
              FxSpacing.width(20),

              FxButton.outlined(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (context) => DonationScreen()),
                    );
                  },
                  splashColor:
                  customTheme.estatePrimary.withAlpha(40),
                  // borderColor: customTheme.estatePrimary,
                  padding: FxSpacing.xy(16, 4),
                  borderRadiusAll: 32,
                  child: FxText.b3("Donate",
                      color: customTheme.estatePrimary)),

            ],
          ),
        ],
      ),
    );
  }

/*
  List<Widget> recipeList() {
    List<Widget> list = [];
    list.add(FxSpacing.width(16));

    for (int i = 0; i < trendingRecipe.length; i++) {
      list.add(singleRecipe(trendingRecipe[i]));
      list.add(FxSpacing.width(16));
    }

    return list;
  }

  Widget singleRecipe(Recipe recipe) {
    return InkWell(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(builder: (context) => RecipeScreen()));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        child: Stack(
          children: [
            Image(
              image: AssetImage(recipe.image),
              width: 240,
            ),
            Positioned(
                left: 16,
                top: 16,
                child: FxContainer(
                  paddingAll: 8,
                  color: Colors.black.withAlpha(200),
                  child: FxText.b3(recipe.tag,
                      color: customTheme.cookifyOnPrimary, fontWeight: 600),
                )),
            Positioned(
                bottom: 16,
                left: 12,
                right: 12,
                child: FxContainer(
                  padding: FxSpacing.xy(12, 16),
                  color:
                  Color.lerp(customTheme.estatePrimary, Colors.black, 0.9)!
                      .withAlpha(160),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: FxText.t2(recipe.title,
                                color: Colors.white, fontWeight: 800),
                          ),
                          Icon(
                            recipe.favorite
                                ? Icons.bookmark
                                : Icons.bookmark_outline,
                            color: customTheme.estatePrimary,
                            size: 18,
                          )
                        ],
                      ),
                      FxSpacing.height(16),
                      FxText.b3(
                          recipe.preparationTime.toString() +
                              " Recipes | " +
                              recipe.serving.toString() +
                              " Serving",
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: 600),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
  */

}
