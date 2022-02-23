/*
* File : Selectable List
* Version : 1.0.0
* */

import 'package:flutter/material.dart';
import 'package:fan_cate/flutx/flutx.dart';
import 'package:fan_cate/theme/app_theme.dart';

class SelectableList extends StatefulWidget {
  @override
  _SelectableListState createState() => _SelectableListState();
}

class _SelectableListState extends State<SelectableList> {
  List<int> _list = List.generate(20, (i) => i);
  List<bool> _selected = List.generate(20, (i) => false);
  late ThemeData theme;
  bool _isSelectable = false;
  late CustomTheme customTheme;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.separated(
            itemCount: _list.length,
            itemBuilder: (context, index) {
              return Ink(
                color: _selected[index]
                    ? theme.colorScheme.primary
                    : theme.backgroundColor,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _selected[index]
                        ? theme.colorScheme.secondary
                        : theme.colorScheme.secondary.withAlpha(240),
                    child: _selected[index]
                        ? Icon(
                            Icons.done,
                            color: theme.colorScheme.onSecondary,
                          )
                        : FxText.b1(_list[index].toString(),
                            fontWeight: 600,
                            color: _selected[index]
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSecondary),
                  ),
                  subtitle: FxText.b2('Sub Item',
                      fontWeight: 500,
                      color: _selected[index]
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onBackground),
                  title: FxText.b1('Item - ' + _list[index].toString(),
                      fontWeight: 600,
                      color: _selected[index]
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onBackground),
                  onTap: () => {
                    if (_isSelectable)
                      {
                        setState(() {
                          _selected[index] = !_selected[index];
                        })
                      },
                    if (_selected.indexOf(true) == -1)
                      {
                        setState(() {
                          _isSelectable = false;
                        })
                      }
                  },
                  onLongPress: (() => setState(() => {
                        if (_isSelectable)
                          {_selected[index] = true}
                        else
                          {_isSelectable = true, _selected[index] = true}
                      })),
                ),
              );
            },
            separatorBuilder: (_, __) => Divider(
                  height: 0.5,
                  color: theme.dividerColor,
                )));
  }
}
