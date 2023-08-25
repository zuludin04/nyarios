import 'package:flutter/material.dart';

class ImageAsset extends StatelessWidget {
  final String assets;
  final Color color;
  final double size;

  const ImageAsset({
    super.key,
    required this.assets,
    this.color = Colors.white,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(assets, width: size, color: color);
  }
}
