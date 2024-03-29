/*
* File : Simple Stepper
* Version : 1.0.0
* */

import 'package:flutter/material.dart';
import 'package:fan_cate/flutx/flutx.dart';
import 'package:fan_cate/theme/app_theme.dart';

class SimpleStepperScreen extends StatefulWidget {
  @override
  _SimpleStepperScreenState createState() => _SimpleStepperScreenState();
}

class _SimpleStepperScreenState extends State<SimpleStepperScreen> {
  late ThemeData theme;
  late CustomTheme customTheme;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
  }

  int _currentStep = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep >= 4) return;
            setState(() {
              _currentStep += 1;
            });
          },
          onStepCancel: () {
            if (_currentStep <= 0) return;
            setState(() {
              _currentStep -= 1;
            });
          },
          onStepTapped: (pos) {
            setState(() {
              _currentStep = pos;
            });
          },
          steps: <Step>[
            Step(
              isActive: true,
              state: StepState.complete,
              title: FxText.sh1('Step 1', fontWeight: 600),
              content: SizedBox(
                  height: 60.0,
                  child: FxText.sh2("Completed (content is here)",
                      fontWeight: 500)),
            ),
            Step(
              isActive: true,
              state: StepState.complete,
              title: FxText.sh1('Step 2', fontWeight: 600),
              content: SizedBox(
                  height: 60.0,
                  child: FxText.sh2("Completed (content is here)",
                      fontWeight: 500)),
            ),
            Step(
              isActive: true,
              state: StepState.editing,
              title: FxText.sh1('Step 3', fontWeight: 600),
              content: SizedBox(
                  height: 60.0,
                  child:
                      FxText.sh2("Editing (content is here)", fontWeight: 500)),
            ),
            Step(
              isActive: true,
              title: FxText.sh1('Step 4', fontWeight: 600),
              content: SizedBox(
                  height: 60.0,
                  child: FxText.sh2("Uncompleted (content is here)",
                      fontWeight: 500)),
            ),
            Step(
              state: StepState.disabled,
              title: FxText.sh1('Step 5', fontWeight: 600),
              content: SizedBox(
                  height: 60.0,
                  child: FxText.sh2("Disabled (content is here)",
                      fontWeight: 500)),
            ),
          ],
        ),
      ),
    ));
  }
}
