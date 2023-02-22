import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip/util/colors.dart';
import 'package:trip/util/global.dart';
import 'package:trip/view/base_state.dart';
import 'package:trip/view/main/home_bloc.dart';

///
/// Created by jozuko on 2023/02/17.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends BaseState<HomePage> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<HomeBloc>(context).add(HomeInitEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      final children = <Widget>[];
      for (var bookmark in state.bookmarks) {
        children.add(
          Text(bookmark.title),
        );
      }

      return Column(
        children: children,
      );

      const Center(
        child: Text(
          'HomePage',
          style: TextStyle(
            color: TColors.blackText,
            fontSize: fontSize1,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    });
  }
}
