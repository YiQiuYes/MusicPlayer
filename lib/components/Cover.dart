import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Cover extends StatelessWidget {
  const Cover(
      {Key? key, required this.imageUrl, this.id, this.width, this.height})
      : super(key: key);

  // 专辑id
  final int? id;
  final String imageUrl;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.contain,
      width: width,
      height: height,
    );
  }
}
