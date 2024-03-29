/*
* File : Expansion Panel
* Version : 1.0.0
* */

import 'package:flutter/material.dart';
import 'package:fan_cate/flutx/flutx.dart';
import 'package:fan_cate/theme/app_theme.dart';

class ExpansionPanelScreen extends StatefulWidget {
  @override
  _ExpansionPanelScreenState createState() => _ExpansionPanelScreenState();
}

class _ExpansionPanelScreenState extends State<ExpansionPanelScreen> {
  List<bool> _dataExpansionPanel = [false, true, false];
  late ThemeData theme;
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
        body: Column(
      children: <Widget>[
        ExpansionPanelList(
          expandedHeaderPadding: EdgeInsets.all(0),
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _dataExpansionPanel[index] = !isExpanded;
            });
          },
          animationDuration: Duration(milliseconds: 500),
          children: <ExpansionPanel>[
            ExpansionPanel(
                canTapOnHeader: true,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: FxText.b1("First panel",
                        color: isExpanded
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onBackground,
                        fontWeight: isExpanded ? 700 : 600),
                  );
                },
                body: Container(
                  padding: FxSpacing.bottom(16),
                  child: Center(
                    child: FxText.b2("Content of panel", fontWeight: 500),
                  ),
                ),
                isExpanded: _dataExpansionPanel[0]),
            ExpansionPanel(
                canTapOnHeader: true,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: FxText.b1("Second panel",
                        color: isExpanded
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onBackground,
                        fontWeight: isExpanded ? 700 : 600),
                  );
                },
                body: Container(
                  padding: FxSpacing.bottom(16),
                  child: Center(
                    child: FxText.b2("Content of panel", fontWeight: 500),
                  ),
                ),
                isExpanded: _dataExpansionPanel[1]),
            ExpansionPanel(
                canTapOnHeader: true,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: FxText.b1("Third panel",
                        color: isExpanded
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onBackground,
                        fontWeight: isExpanded ? 700 : 600),
                  );
                },
                body: Container(
                  padding: FxSpacing.bottom(16),
                  child: Center(
                    child: FxText.b2("Content of panel", fontWeight: 500),
                  ),
                ),
                isExpanded: _dataExpansionPanel[2])
          ],
        )
      ],
    ));
  }
}
