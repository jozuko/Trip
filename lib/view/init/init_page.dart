import 'package:flutter/cupertino.dart';
import 'package:trip/util/colors.dart';
import 'package:trip/util/global.dart';

///
/// Created by jozuko on 2023/02/17.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class InitPage extends StatelessWidget {
  const InitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '旅の計画を作ろう！！',
        style: TextStyle(
          color: TColors.blackText,
          fontSize: fontSize1,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
