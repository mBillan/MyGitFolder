import 'package:flutter/material.dart';

import '../../flutx/themes/text_style.dart';
import '../../flutx/utils/spacing.dart';
import '../../theme/app_theme.dart';
import '../../theme/constant.dart';

class TextFormFieldStyled extends StatefulWidget {
  const TextFormFieldStyled(
      {Key? key,
      required this.hintText,
      required this.controller,
      this.validator,
      required this.icon,
      this.obscureText = false,
      this.keyboardType, this.maxLines, this.minLines})
      : super(key: key);
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? minLines;

  @override
  _TextFormFieldStyledState createState() => _TextFormFieldStyledState();
}

class _TextFormFieldStyledState extends State<TextFormFieldStyled> {
  late OutlineInputBorder enabledBorderOutline;
  late OutlineInputBorder focusedBorderOutline;
  late CustomTheme customTheme;
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
    enabledBorderOutline = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(MaterialRadius().small)),
      borderSide: const BorderSide(
        color: Colors.transparent,
      ),
    );
    focusedBorderOutline = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(MaterialRadius().small)),
      borderSide: BorderSide(
        color: customTheme.estatePrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      style: FxTextStyle.b2(color: customTheme.estatePrimary),
      keyboardType: widget.keyboardType,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      controller: widget.controller,
      validator: widget.validator,
      cursorColor: customTheme.estatePrimary,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(
          widget.icon,
          color: customTheme.estatePrimary,
          size: 25,
        ),
        focusColor: customTheme.estatePrimary,
        filled: true,
        fillColor: customTheme.estatePrimary.withAlpha(40),
        hoverColor: customTheme.estatePrimary,
        prefixIconColor: customTheme.estatePrimary,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        isDense: true,
        labelStyle: FxTextStyle.b2(),
        hintText: widget.hintText,
        border: enabledBorderOutline,
        enabledBorder: enabledBorderOutline,
        focusedBorder: focusedBorderOutline,
        contentPadding: FxSpacing.all(16),
        hintStyle: FxTextStyle.b2(xMuted: true),
        isCollapsed: true,
      ),
    );
  }
}
