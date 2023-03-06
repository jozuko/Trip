import 'package:flutter/cupertino.dart';
import 'package:trip/widget/title_bar.dart';

///
/// Created by jozuko on 2023/02/17.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class InitPage extends StatelessWidget {
  static Widget newPage({Key? key}) {
    return InitPage(key: key);
  }

  const InitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        TitleBar(),
      ],
    );
  }
}
