import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip/domain/firestore/spot.dart';
import 'package:trip/domain/map_pin_type.dart';
import 'package:trip/util/global.dart';
import 'package:trip/util/text_style_ex.dart';
import 'package:trip/view/base_state.dart';
import 'package:trip/view/main/spot_edit_page.dart';
import 'package:trip/view/main/spot_list_bloc.dart';
import 'package:trip/view/map_page.dart';
import 'package:trip/widget/button/square_icon_button.dart';
import 'package:trip/widget/spot_widget.dart';
import 'package:trip/widget/title_bar.dart';
import 'package:url_launcher/url_launcher.dart';

///
/// TODO なんかフィルターほしい
///
/// Created by jozuko on 2023/03/06.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class SpotListPage extends StatefulWidget {
  static Route routePage({Key? key}) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => SpotListBloc(),
        child: SpotListPage(key: key),
      ),
    );
  }

  const SpotListPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SpotListState();
  }
}

class _SpotListState extends BaseState<SpotListPage> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<SpotListBloc>(context).add(SpotListInitEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotListBloc, SpotListState>(
      builder: (context, state) {
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
                          itemCount: state.spots.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: marginS),
                              child: _buildSpotItem(context, state.spots[index]),
                            );
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
        Text('スポット一覧', style: TextStyleEx.normalStyle(isBold: true)),
        const Spacer(),
        SquareIconButton.transparent(
          Icons.add_circle_outline_rounded,
          onPressed: _onPressAdd,
        ),
      ],
    );
  }

  Widget _buildSpotItem(BuildContext context, Spot spot) {
    return SpotWidget(
      spot: spot,
      onPressedEdit: () {
        _onPressedEditItem(spot);
      },
      onPressedRemove: () {
        _onPressedRemoveItem(spot);
      },
      onPressedMap: () {
        _onPressedMapItem(spot);
      },
      onPressedOpenWeb: () {
        _onPressedOpenWeb(spot);
      },
    );
  }

  void _onBackPress() {
    Navigator.pop(context);
  }

  void _onPressAdd() {
    Navigator.of(context).push(SpotEditPage.routePage()).then((value) => BlocProvider.of<SpotListBloc>(context).add(SpotListInitEvent()));
  }

  void _onPressedEditItem(Spot spot) {
    Navigator.of(context).push(SpotEditPage.routePage(spot: spot)).then((value) {
      BlocProvider.of<SpotListBloc>(context).add(SpotListInitEvent());
    });
  }

  Future<void> _onPressedRemoveItem(Spot spot) async {
    await showConfirm(
      message: '${spot.name}を削除します。\nよろしいですか？',
      okLabel: '削除する',
      cancelLabel: '削除しない',
      callback: (canceled) {
        if (canceled) {
          return;
        }
        BlocProvider.of<SpotListBloc>(context).add(SpotListRemoveItemEvent(spot));
      },
    );
  }

  void _onPressedMapItem(Spot spot) {
    Navigator.of(context).push(MapPage.routePage(location: spot.location, mapPinType: MapPinTypeEx.fromSpotType(spot.spotType), isEditable: false));
  }

  Future<void> _onPressedOpenWeb(Spot spot) async {
    if (spot.url.isEmpty) {
      return;
    }
    final uri = Uri.parse(spot.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
