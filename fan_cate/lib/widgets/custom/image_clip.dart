import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ImageClipRectStyled extends StatefulWidget {
  const ImageClipRectStyled(
      {Key? key, this.image, this.icon = Icons.image, this.borderRadius})
      : super(key: key);
  final String? image;
  final IconData icon;
  final BorderRadius? borderRadius;

  @override
  _ImageClipRectStyledState createState() => _ImageClipRectStyledState();
}

class _ImageClipRectStyledState extends State<ImageClipRectStyled> {
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
    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(50),
      child: (widget.image == null || widget.image == '')
          ? Icon(
              widget.icon,
              size: 40,
            )
          : (widget.image!.contains("http"))
              ? Image.network(
                  widget.image!,
                  width: 100,
                  height: 100,
                )
              : Image(
                  image: AssetImage(widget.image!),
                  height: 100,
                  width: 100,
                ),
    );
  }
}
