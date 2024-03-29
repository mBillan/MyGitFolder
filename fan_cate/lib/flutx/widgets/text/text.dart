// Copyright 2021 The FlutX Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// There are mainly 13 types of Text widgets.
/// h1,h2,h3,h4,h5,h6,sh1,sh2,b1,b2,button,caption,overline - This is the order of its size.

import 'package:flutter/material.dart';
import 'package:fan_cate/flutx/flutx.dart';
import 'package:fan_cate/flutx/themes/text_style.dart';

class FxText extends StatelessWidget {
  //Key

  final Key? key;

  final String text;
  final TextStyle? style;
  final int? fontWeight;
  final bool muted, xMuted;
  final double? letterSpacing;
  final Color? color;
  final TextDecoration decoration;
  final double? height;
  final double wordSpacing;
  final double? fontSize;
  final FxTextType textType;

  //Text Style
  final TextAlign? textAlign;
  final int? maxLines;
  final Locale? locale;
  final TextOverflow? overflow;
  final String? semanticsLabel;
  final bool? softWrap;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final TextHeightBehavior? textHeightBehavior;
  final double? textScaleFactor;
  final TextWidthBasis? textWidthBasis;

  FxText(this.text,
      {this.style,
      this.fontWeight = 500,
      this.muted = false,
      this.xMuted = false,
      this.letterSpacing = 0.15,
      this.color,
      this.decoration = TextDecoration.none,
      this.height,
      this.wordSpacing = 0,
      this.fontSize,
      this.textType = FxTextType.b1,
      this.key,
      this.textAlign,
      this.maxLines,
      this.locale,
      this.overflow,
      this.semanticsLabel,
      this.softWrap,
      this.strutStyle,
      this.textDirection,
      this.textHeightBehavior,
      this.textScaleFactor,
      this.textWidthBasis});




  FxText.h4(this.text,
      {this.style,
      this.fontWeight = 500,
      this.muted = false,
      this.xMuted = false,
      this.letterSpacing,
      this.color,
      this.decoration = TextDecoration.none,
      this.height,
      this.wordSpacing = 0,
      this.fontSize,
      this.textType = FxTextType.h4,
      this.key,
      this.textAlign,
      this.maxLines,
      this.locale,
      this.overflow,
      this.semanticsLabel,
      this.softWrap,
      this.strutStyle,
      this.textDirection,
      this.textHeightBehavior,
      this.textScaleFactor,
      this.textWidthBasis});

  
  FxText.h5(this.text,
      {this.style,
      this.fontWeight = 500,
      this.muted = false,
      this.xMuted = false,
      this.letterSpacing,
      this.color,
      this.decoration = TextDecoration.none,
      this.height,
      this.wordSpacing = 0,
      this.fontSize,
      this.textType = FxTextType.h5,
      this.key,
      this.textAlign,
      this.maxLines,
      this.locale,
      this.overflow,
      this.semanticsLabel,
      this.softWrap,
      this.strutStyle,
      this.textDirection,
      this.textHeightBehavior,
      this.textScaleFactor,
      this.textWidthBasis});

  
  FxText.h6(this.text,
      {this.style,
      this.fontWeight = 500,
      this.muted = false,
      this.xMuted = false,
      this.letterSpacing,
      this.color,
      this.decoration = TextDecoration.none,
      this.height,
      this.wordSpacing = 0,
      this.fontSize,
      this.textType = FxTextType.h6,
      this.key,
      this.textAlign,
      this.maxLines,
      this.locale,
      this.overflow,
      this.semanticsLabel,
      this.softWrap,
      this.strutStyle,
      this.textDirection,
      this.textHeightBehavior,
      this.textScaleFactor,
      this.textWidthBasis});

  
  FxText.sh1(this.text,
      {this.style,
      this.fontWeight = 500,
      this.muted = false,
      this.xMuted = false,
      this.letterSpacing,
      this.color,
      this.decoration = TextDecoration.none,
      this.height,
      this.wordSpacing = 0,
      this.fontSize,
      this.textType = FxTextType.sh1,
      this.key,
      this.textAlign,
      this.maxLines,
      this.locale,
      this.overflow,
      this.semanticsLabel,
      this.softWrap,
      this.strutStyle,
      this.textDirection,
      this.textHeightBehavior,
      this.textScaleFactor,
      this.textWidthBasis});

  
  FxText.sh2(this.text,
      {this.style,
      this.fontWeight = 500,
      this.muted = false,
      this.xMuted = false,
      this.letterSpacing,
      this.color,
      this.decoration = TextDecoration.none,
      this.height,
      this.wordSpacing = 0,
      this.fontSize,
      this.textType = FxTextType.sh2,
      this.key,
      this.textAlign,
      this.maxLines,
      this.locale,
      this.overflow,
      this.semanticsLabel,
      this.softWrap,
      this.strutStyle,
      this.textDirection,
      this.textHeightBehavior,
      this.textScaleFactor,
      this.textWidthBasis});



  
  FxText.button(this.text,
      {this.style,
      this.fontWeight = 500,
      this.muted = false,
      this.xMuted = false,
      this.letterSpacing,
      this.color,
      this.decoration = TextDecoration.none,
      this.height,
      this.wordSpacing = 0,
      this.fontSize,
      this.textType = FxTextType.button,
      this.key,
      this.textAlign,
      this.maxLines,
      this.locale,
      this.overflow,
      this.semanticsLabel,
      this.softWrap,
      this.strutStyle,
      this.textDirection,
      this.textHeightBehavior,
      this.textScaleFactor,
      this.textWidthBasis});

  
  FxText.caption(this.text,
      {this.style,
      this.fontWeight = 500,
      this.muted = false,
      this.xMuted = false,
      this.letterSpacing,
      this.color,
      this.decoration = TextDecoration.none,
      this.height,
      this.wordSpacing = 0,
      this.fontSize,
      this.textType = FxTextType.caption,
      this.key,
      this.textAlign,
      this.maxLines,
      this.locale,
      this.overflow,
      this.semanticsLabel,
      this.softWrap,
      this.strutStyle,
      this.textDirection,
      this.textHeightBehavior,
      this.textScaleFactor,
      this.textWidthBasis});

  
  FxText.overline(this.text,
      {this.style,
      this.fontWeight = 500,
      this.muted = false,
      this.xMuted = false,
      this.letterSpacing,
      this.color,
      this.decoration = TextDecoration.none,
      this.height,
      this.wordSpacing = 0,
      this.fontSize,
      this.textType = FxTextType.overline,
      this.key,
      this.textAlign,
      this.maxLines,
      this.locale,
      this.overflow,
      this.semanticsLabel,
      this.softWrap,
      this.strutStyle,
      this.textDirection,
      this.textHeightBehavior,
      this.textScaleFactor,
      this.textWidthBasis});



  // Material Design 3


  FxText.d1(this.text,
      {this.style,
          this.fontWeight,
          this.muted = false,
          this.xMuted = false,
          this.letterSpacing,
          this.color,
          this.decoration = TextDecoration.none,
          this.height,
          this.wordSpacing = 0,
          this.fontSize,
          this.textType = FxTextType.d1,
          this.key,
          this.textAlign,
          this.maxLines,
          this.locale,
          this.overflow,
          this.semanticsLabel,
          this.softWrap,
          this.strutStyle,
          this.textDirection,
          this.textHeightBehavior,
          this.textScaleFactor,
          this.textWidthBasis});

  FxText.d2(this.text,
      {this.style,
          this.fontWeight,
          this.muted = false,
          this.xMuted = false,
          this.letterSpacing,
          this.color,
          this.decoration = TextDecoration.none,
          this.height,
          this.wordSpacing = 0,
          this.fontSize,
          this.textType = FxTextType.d2,
          this.key,
          this.textAlign,
          this.maxLines,
          this.locale,
          this.overflow,
          this.semanticsLabel,
          this.softWrap,
          this.strutStyle,
          this.textDirection,
          this.textHeightBehavior,
          this.textScaleFactor,
          this.textWidthBasis});

  FxText.d3(this.text,
      {this.style,
          this.fontWeight,
          this.muted = false,
          this.xMuted = false,
          this.letterSpacing,
          this.color,
          this.decoration = TextDecoration.none,
          this.height,
          this.wordSpacing = 0,
          this.fontSize,
          this.textType = FxTextType.d3,
          this.key,
          this.textAlign,
          this.maxLines,
          this.locale,
          this.overflow,
          this.semanticsLabel,
          this.softWrap,
          this.strutStyle,
          this.textDirection,
          this.textHeightBehavior,
          this.textScaleFactor,
          this.textWidthBasis});

  FxText.h1(this.text,
      {this.style,
          this.fontWeight = 500,
          this.muted = false,
          this.xMuted = false,
          this.letterSpacing,
          this.color,
          this.decoration = TextDecoration.none,
          this.height,
          this.wordSpacing = 0,
          this.fontSize,
          this.textType = FxTextType.h1,
          this.key,
          this.textAlign,
          this.maxLines,
          this.locale,
          this.overflow,
          this.semanticsLabel,
          this.softWrap,
          this.strutStyle,
          this.textDirection,
          this.textHeightBehavior,
          this.textScaleFactor,
          this.textWidthBasis});

  FxText.h2(this.text,
      {this.style,
          this.fontWeight = 500,
          this.muted = false,
          this.xMuted = false,
          this.letterSpacing,
          this.color,
          this.decoration = TextDecoration.none,
          this.height,
          this.wordSpacing = 0,
          this.fontSize,
          this.textType = FxTextType.h2,
          this.key,
          this.textAlign,
          this.maxLines,
          this.locale,
          this.overflow,
          this.semanticsLabel,
          this.softWrap,
          this.strutStyle,
          this.textDirection,
          this.textHeightBehavior,
          this.textScaleFactor,
          this.textWidthBasis});

  FxText.h3(this.text,
      {this.style,
          this.fontWeight = 500,
          this.muted = false,
          this.xMuted = false,
          this.letterSpacing,
          this.color,
          this.decoration = TextDecoration.none,
          this.height,
          this.wordSpacing = 0,
          this.fontSize,
          this.textType = FxTextType.h3,
          this.key,
          this.textAlign,
          this.maxLines,
          this.locale,
          this.overflow,
          this.semanticsLabel,
          this.softWrap,
          this.strutStyle,
          this.textDirection,
          this.textHeightBehavior,
          this.textScaleFactor,
          this.textWidthBasis});



  FxText.t1(this.text,
      {this.style,
          this.fontWeight,
          this.muted = false,
          this.xMuted = false,
          this.letterSpacing,
          this.color,
          this.decoration = TextDecoration.none,
          this.height,
          this.wordSpacing = 0,
          this.fontSize,
          this.textType = FxTextType.t1,
          this.key,
          this.textAlign,
          this.maxLines,
          this.locale,
          this.overflow,
          this.semanticsLabel,
          this.softWrap,
          this.strutStyle,
          this.textDirection,
          this.textHeightBehavior,
          this.textScaleFactor,
          this.textWidthBasis});

  FxText.t2(this.text,
      {this.style,
          this.fontWeight,
          this.muted = false,
          this.xMuted = false,
          this.letterSpacing,
          this.color,
          this.decoration = TextDecoration.none,
          this.height,
          this.wordSpacing = 0,
          this.fontSize,
          this.textType = FxTextType.t2,
          this.key,
          this.textAlign,
          this.maxLines,
          this.locale,
          this.overflow,
          this.semanticsLabel,
          this.softWrap,
          this.strutStyle,
          this.textDirection,
          this.textHeightBehavior,
          this.textScaleFactor,
          this.textWidthBasis});

  FxText.t3(this.text,
      {this.style,
          this.fontWeight,
          this.muted = false,
          this.xMuted = false,
          this.letterSpacing,
          this.color,
          this.decoration = TextDecoration.none,
          this.height,
          this.wordSpacing = 0,
          this.fontSize,
          this.textType = FxTextType.t3,
          this.key,
          this.textAlign,
          this.maxLines,
          this.locale,
          this.overflow,
          this.semanticsLabel,
          this.softWrap,
          this.strutStyle,
          this.textDirection,
          this.textHeightBehavior,
          this.textScaleFactor,
          this.textWidthBasis});



  FxText.l1(this.text,
      {this.style,
          this.fontWeight,
          this.muted = false,
          this.xMuted = false,
          this.letterSpacing,
          this.color,
          this.decoration = TextDecoration.none,
          this.height,
          this.wordSpacing = 0,
          this.fontSize,
          this.textType = FxTextType.l1,
          this.key,
          this.textAlign,
          this.maxLines,
          this.locale,
          this.overflow,
          this.semanticsLabel,
          this.softWrap,
          this.strutStyle,
          this.textDirection,
          this.textHeightBehavior,
          this.textScaleFactor,
          this.textWidthBasis});

  FxText.l2(this.text,
      {this.style,
          this.fontWeight,
          this.muted = false,
          this.xMuted = false,
          this.letterSpacing,
          this.color,
          this.decoration = TextDecoration.none,
          this.height,
          this.wordSpacing = 0,
          this.fontSize,
          this.textType = FxTextType.l2,
          this.key,
          this.textAlign,
          this.maxLines,
          this.locale,
          this.overflow,
          this.semanticsLabel,
          this.softWrap,
          this.strutStyle,
          this.textDirection,
          this.textHeightBehavior,
          this.textScaleFactor,
          this.textWidthBasis});

  FxText.l3(this.text,
      {this.style,
          this.fontWeight ,
          this.muted = false,
          this.xMuted = false,
          this.letterSpacing,
          this.color,
          this.decoration = TextDecoration.none,
          this.height,
          this.wordSpacing = 0,
          this.fontSize,
          this.textType = FxTextType.l3,
          this.key,
          this.textAlign,
          this.maxLines,
          this.locale,
          this.overflow,
          this.semanticsLabel,
          this.softWrap,
          this.strutStyle,
          this.textDirection,
          this.textHeightBehavior,
          this.textScaleFactor,
          this.textWidthBasis});



  FxText.b1(this.text,
      {this.style,
          this.fontWeight,
          this.muted = false,
          this.xMuted = false,
          this.letterSpacing,
          this.color,
          this.decoration = TextDecoration.none,
          this.height,
          this.wordSpacing = 0,
          this.fontSize,
          this.textType = FxTextType.b1,
          this.key,
          this.textAlign,
          this.maxLines,
          this.locale,
          this.overflow,
          this.semanticsLabel,
          this.softWrap,
          this.strutStyle,
          this.textDirection,
          this.textHeightBehavior,
          this.textScaleFactor,
          this.textWidthBasis});

  FxText.b2(this.text,
      {this.style,
          this.fontWeight,
          this.muted = false,
          this.xMuted = false,
          this.letterSpacing,
          this.color,
          this.decoration = TextDecoration.none,
          this.height,
          this.wordSpacing = 0,
          this.fontSize,
          this.textType = FxTextType.b2,
          this.key,
          this.textAlign,
          this.maxLines,
          this.locale,
          this.overflow,
          this.semanticsLabel,
          this.softWrap,
          this.strutStyle,
          this.textDirection,
          this.textHeightBehavior,
          this.textScaleFactor,
          this.textWidthBasis});

  FxText.b3(this.text,
      {this.style,
          this.fontWeight,
          this.muted = false,
          this.xMuted = false,
          this.letterSpacing,
          this.color,
          this.decoration = TextDecoration.none,
          this.height,
          this.wordSpacing = 0,
          this.fontSize,
          this.textType = FxTextType.b3,
          this.key,
          this.textAlign,
          this.maxLines,
          this.locale,
          this.overflow,
          this.semanticsLabel,
          this.softWrap,
          this.strutStyle,
          this.textDirection,
          this.textHeightBehavior,
          this.textScaleFactor,
          this.textWidthBasis});





  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style?? FxTextStyle.getStyle(
        textStyle: style,
        color: color,
        fontWeight:fontWeight?? FxTextStyle.defaultTextFontWeight[textType] ?? 500,
        muted: muted,
        letterSpacing: letterSpacing ??
            FxTextStyle.defaultLetterSpacing[textType] ??
            0.15,
        height: height,
        xMuted: xMuted,
        decoration: decoration,
        wordSpacing: wordSpacing,
        fontSize: fontSize ?? FxTextStyle.defaultTextSize[textType],
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      locale: locale,
      overflow: overflow,
      semanticsLabel: semanticsLabel,
      softWrap: softWrap,
      strutStyle: strutStyle,
      textDirection: textDirection??FxAppTheme.textDirection,
      textHeightBehavior: textHeightBehavior,
      textScaleFactor: textScaleFactor,
      textWidthBasis: textWidthBasis,
      key: key,
    );
  }
}
