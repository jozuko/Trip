import 'package:flutter/material.dart';
import 'package:trip/util/colors.dart';
import 'package:trip/util/string_ex.dart';

///
/// Created by jozuko on 2023/03/13.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class NetworkImageWidget extends StatelessWidget {
  final String? url;
  final double size;

  const NetworkImageWidget(
    this.url, {
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (url.nullToEmpty.isEmpty) {
      child = Center(
        child: Icon(
          Icons.photo,
          size: size / 2,
          color: TColors.darkGray,
        ),
      );
    } else {
      child = Image.network(
        url!,
        fit: BoxFit.fill,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Icon(
              Icons.photo,
              size: size / 2,
              color: TColors.darkGray,
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
            ),
          );
        },
      );
    }

    return Container(
      color: TColors.lightGray,
      height: size,
      width: size,
      child: child,
    );
  }
}
