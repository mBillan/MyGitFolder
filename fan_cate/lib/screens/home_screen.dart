import 'package:fan_cate/data/user.dart';
import 'package:fan_cate/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fan_cate/flutx/flutx.dart';

// import 'recipe_screen.dart';
// import 'models/recipe.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // late Recipe recipe;
  late User user;
  // late List<Recipe> trendingRecipe;
  late CustomTheme customTheme;
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    user = User.getOne();
    // recipe = Recipe.getOne();
    // trendingRecipe = Recipe.getList();
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
          body: Container(
            padding: FxSpacing.top(24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: FxSpacing.x(16),
                    child: FxText.h3("${user.name},",
                        color: customTheme.estatePrimary, fontWeight: 800),
                  ),
                  Container(
                    margin: FxSpacing.x(16),
                    child: FxText.b2("Excited to cook something new today?",
                        color: theme.colorScheme.onBackground,
                        letterSpacing: 0,
                        xMuted: true,
                        fontWeight: 700),
                  ),
                  /*xSpacing.height(16),
                  FxContainer(
                      margin: FxSpacing.x(16),
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                                builder: (context) => RecipeScreen()));
                      },
                      splashColor: customTheme.estatePrimary.withAlpha(40),
                      color: customTheme.estatePrimary.withAlpha(30),
                      child: Row(
                        children: [
                          FxTwoToneIcon(
                            FxTwoToneMdiIcons.outdoor_grill,
                            color: customTheme.estatePrimary,
                            size: 48,
                          ),
                          FxSpacing.width(16),
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FxText.b3(
                                      "You have 12 recipes that\nyou haven\'t tried yet",
                                      fontWeight: 700),
                                  FxButton.text(
                                      padding: FxSpacing.zero,
                                      onPressed: () {},
                                      splashColor:
                                      customTheme.estatePrimary.withAlpha(40),
                                      child: FxText.l2("See Recipes",
                                          color: customTheme.estatePrimary,
                                          decoration: TextDecoration.underline))
                                ],
                              ))
                        ],
                      )),
                  FxSpacing.height(16),
                  Container(
                    margin: FxSpacing.x(16),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                                builder: (context) => RecipeScreen()));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        child: Stack(
                          children: [
                            Image(
                              image: AssetImage(recipe.image),
                            ),
                            Positioned(
                                left: 16,
                                top: 16,
                                child: FxContainer(
                                  paddingAll: 8,
                                  color:
                                  customTheme.estatePrimary.withAlpha(200),
                                  child: FxText.b3(recipe.tag,
                                      color: customTheme.cookifyOnPrimary,
                                      fontWeight: 600),
                                )),
                            Positioned(
                                right: 16,
                                top: 16,
                                child: Icon(
                                  recipe.favorite
                                      ? Icons.bookmark
                                      : Icons.bookmark_outline,
                                  color: customTheme.estatePrimary,
                                  size: 28,
                                )),
                            Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: FxSpacing.fromLTRB(16, 48, 16, 32),
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            customTheme.estatePrimary
                                                .withAlpha(220),
                                            customTheme.estatePrimary
                                                .withAlpha(180),
                                            customTheme.estatePrimary
                                                .withAlpha(140),
                                            customTheme.estatePrimary
                                                .withAlpha(100),
                                            Colors.transparent
                                          ],
                                          stops: [
                                            0.1,
                                            0.25,
                                            0.5,
                                            0.7,
                                            1
                                          ])),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      FxText.h3(recipe.title,
                                          color: Colors.white, fontWeight: 800),
                                      FxSpacing.height(16),
                                      FxText.b3(
                                          recipe.preparationTime.toString() +
                                              " Recipes | " +
                                              recipe.serving.toString() +
                                              " Serving",
                                          color: Colors.white,
                                          fontWeight: 600),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                  FxSpacing.height(16),
                  Container(
                      margin: FxSpacing.x(16),
                      child: FxText.t2(
                        "Trending Recipe",
                        fontWeight: 800,
                      )),
                  FxSpacing.height(16),
                  SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: recipeList(),
                    ),
                  ),
                  FxSpacing.height(16),

                   */
                ],
              ),
            ),
          ),
        ),
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
