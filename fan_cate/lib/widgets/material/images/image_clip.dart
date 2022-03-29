import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fan_cate/theme/app_theme.dart';

class ImageClipRectStyled extends StatefulWidget {
  const ImageClipRectStyled({
    Key? key,
    this.image,
    this.imageBytes,
    this.icon = Icons.image,
    this.borderRadius,
    this.imageHeight,
    this.imageWidth,
    this.onTap,
  }) : super(key: key);
  final String? image;
  final Uint8List? imageBytes;
  final double? imageHeight;
  final double? imageWidth;
  final IconData icon;
  final BorderRadius? borderRadius;
  final void Function()? onTap;

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
    return InkWell(
      onTap: widget.onTap,
      child: ClipRRect(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(50),
        child: ((widget.image == null || widget.image == '') &&
                widget.imageBytes == null)
            ? Icon(
                widget.icon,
                size: 40,
              )
            : (widget.imageBytes != null)
                ? Image.memory(
                    widget.imageBytes!,
                    height: widget.imageHeight,
                    width: widget.imageWidth,
                  )
                : (widget.image!.contains("http"))
                    ? Image.network(
                        widget.image!,
                        height: widget.imageHeight,
                        width: widget.imageWidth,
                      )
                    : (widget.image!.startsWith('./'))
                        ?
                        // Reading an image from the assets directory
                        Image(
                            image: AssetImage(widget.image!),
                            height: widget.imageHeight,
                            width: widget.imageWidth,
                          )
                        : Image.file(
                            File(widget.image!),
                            height: widget.imageHeight,
                            width: widget.imageWidth,
                          ),
      ),
    );
  }
}
