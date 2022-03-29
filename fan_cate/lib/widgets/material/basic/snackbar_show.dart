import 'package:flutter/material.dart';
import 'package:fan_cate/flutx/flutx.dart';
import 'package:fan_cate/theme/app_theme.dart';

ThemeData theme = AppTheme.theme;
CustomTheme customTheme = AppTheme.customTheme;

void showSimpleSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: theme.textTheme.subtitle2!
            .merge(TextStyle(color: theme.colorScheme.onPrimary)),
      ),
    ),
  );
}

void showSnackBarWithAction(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: FxText.sh2(text,
          color: theme.colorScheme.onPrimary),
      action: SnackBarAction(
        onPressed: () {},
        label: "Undo",
        textColor: theme.colorScheme.onPrimary,
      ),
    ),
  );
}

void showSnackBarWithFloating(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: FxText.sh2(text,
          color: theme.colorScheme.onPrimary),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

void showSnackBarWithFloatingAction(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: FxText.sh2(text,
          color: theme.colorScheme.onPrimary),
      action: SnackBarAction(
        onPressed: () {},
        label: "Undo",
        textColor: theme.colorScheme.onPrimary,
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
