import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip/domain/map_pin_type.dart';
import 'package:trip/util/global.dart';
import 'package:trip/view/base_state.dart';
import 'package:trip/view/main/account_page.dart';
import 'package:trip/view/main/settings_bloc.dart';
import 'package:trip/view/main/spot_list_page.dart';
import 'package:trip/view/map_page.dart';
import 'package:trip/widget/button/square_text_button.dart';
import 'package:trip/widget/title_bar.dart';

///
/// Created by jozuko on 2023/03/06.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class SettingsPage extends StatefulWidget {
  static Route routePage({Key? key}) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => SettingsBloc(),
        child: SettingsPage(key: key),
      ),
    );
  }

  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingsState();
  }
}

class _SettingsState extends BaseState<SettingsPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SettingsBloc>(context).add(SettingsInitEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return buildRootPage(
          child: Column(
            children: [
              _buildTitle(),
              Padding(
                padding: const EdgeInsets.all(margin),
                child: Column(
                  children: [
                    _buildMenu('自宅設定', () {
                      onTapHomePos(state);
                    }),
                    const SizedBox(height: marginS),
                    _buildMenu('スポット情報', onTapSpot),
                    const SizedBox(height: marginS),
                    _buildMenu('アカウント情報', onTapAccount),
                  ],
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

  void _onBackPress() {
    Navigator.pop(context);
  }

  Widget _buildMenu(String label, VoidCallback onTap) {
    return SquareWidgetButton.whiteButton(
      label,
      onPressed: onTap,
    );
  }

  void onTapHomePos(SettingsState state) {
    final user = state.user;
    if (user == null) {
      return;
    }

    Navigator.of(context)
        .push(MapPage.routePage(
      location: user.homePos,
      isEditable: true,
      mapPinType: MapPinType.home,
    ))
        .then((value) {
      if (value == null) {
        return;
      }
      if (value.isInvalid) {
        return;
      }
      BlocProvider.of<SettingsBloc>(context).add(SettingsUpdateHomeEvent(location: value));
    });
  }

  void onTapSpot() {
    Navigator.of(context).push(SpotListPage.routePage());
  }

  void onTapAccount() {
    Navigator.of(context).push(AccountPage.routePage());
  }
}
