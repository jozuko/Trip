import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip/domain/firestore/poi.dart';
import 'package:trip/repository/log/trip_logger.dart';
import 'package:trip/util/colors.dart';
import 'package:trip/util/global.dart';
import 'package:trip/util/text_style_ex.dart';
import 'package:trip/view/base_state.dart';
import 'package:trip/view/main/poi_list_bloc.dart';
import 'package:trip/widget/button/square_icon_button.dart';
import 'package:trip/widget/button/square_text_button.dart';
import 'package:trip/widget/network_image_widget.dart';
import 'package:trip/widget/title_bar.dart';

///
/// TODO スポットに登録済みとか出したい
/// TODO なんかフィルターほしい
///
/// Created by jozuko on 2023/03/10.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class PoiListPage extends StatefulWidget {
  static Route<Poi?> routePage({Key? key}) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => PoiListBloc(),
        child: PoiListPage(key: key),
      ),
    );
  }

  const PoiListPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PoiListState();
  }
}

class _PoiListState extends BaseState<PoiListPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PoiListBloc, PoiListState>(
      builder: (context, state) {
        TripLog.d("_PoiListState#build $state");

        return buildRootPage(
          child: Column(
            children: [
              _buildTitle(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(margin),
                  child: Column(
                    children: [
                      _buildListTitle(),
                      Flexible(
                        child: ListView.builder(
                          itemCount: state.pois.length,
                          itemBuilder: (context, index) {
                            return _buildListItem(context, state.pois[index]);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return TitleBar(
      isBack: true,
      onTapLeadingIcon: _onBackPress,
    );
  }

  Widget _buildListTitle() {
    return Row(
      children: [
        Text('地点一覧', style: TextStyleEx.normalStyle(isBold: true)),
        const Spacer(),
        SquareIconButton.transparent(
          Icons.add_circle_outline_rounded,
          onPressed: _onPressAdd,
        ),
      ],
    );
  }

  Widget _buildListItem(BuildContext context, Poi poi) {
    final memo = <String>[];
    if (poi.description.isNotEmpty) {
      memo.add(poi.description);
    }
    if (poi.address.isNotEmpty) {
      memo.add(poi.address);
    }
    if (poi.phoneNumber.isNotEmpty) {
      memo.add(poi.phoneNumber);
    }
    if (poi.openingHours.isNotEmpty) {
      memo.addAll(poi.openingHours);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: marginS),
      child: SquareWidgetButton.whiteWidgetButton(
        onPressed: () {
          _onPressedItem(poi);
        },
        height: 200,
        radius: 10,
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NetworkImageWidget(poi.imageUrl, size: 100),
                  const SizedBox(width: marginS),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          poi.title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyleEx.normalStyle(textColor: TColors.blackStrongText, isBold: true),
                        ),
                        Flexible(
                          child: SingleChildScrollView(
                            child: Text(
                              memo.join('\n'),
                              style: TextStyleEx.normalStyle(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: marginS),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onBackPress() {
    Navigator.pop(context);
  }

  void _onPressedItem(Poi poi) {
    Navigator.of(context).pop(poi);
  }

  void _onPressAdd() {
    openGoogleMapsApp();
  }
}
