import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip/domain/firestore/open_time.dart';
import 'package:trip/domain/firestore/spot.dart';
import 'package:trip/domain/spot_type.dart';
import 'package:trip/util/colors.dart';
import 'package:trip/util/global.dart';
import 'package:trip/util/text_style_ex.dart';
import 'package:trip/view/base_state.dart';
import 'package:trip/view/main/spot_edit_bloc.dart';
import 'package:trip/widget/button/square_icon_button.dart';
import 'package:trip/widget/button/square_text_button.dart';
import 'package:trip/widget/field/single_line_field.dart';
import 'package:trip/widget/title_bar.dart';

///
/// Created by jozuko on 2023/03/07.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class SpotEditPage extends StatefulWidget {
  static Route routePage({Key? key, Spot? spot}) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => SpotEditBloc(spot),
        child: SpotEditPage(key: key),
      ),
    );
  }

  const SpotEditPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SpotEditState();
  }
}

class _SpotEditState extends BaseState<SpotEditPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _urlController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SpotEditBloc>(context).add(SpotEditInitEvent());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _urlController.dispose();
    _locationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotEditBloc, SpotEditState>(
      builder: (context, state) {
        if (!state.initialized) {
          _setTextInitValue(_nameController, state.name);
          _setTextInitValue(_phoneController, state.phone);
          _setTextInitValue(_addressController, state.address);
          _setTextInitValue(_urlController, state.url);
          _setTextInitValue(_locationController, state.location);
        }

        return buildRootPage(
          child: Column(
            children: [
              _buildTitle(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(margin),
                  child: SingleChildScrollView(
                    child: Column(
                      children: _buildContent(state),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _setTextInitValue(TextEditingController controller, String value) {
    controller.text = value;
    controller.value = controller.value.copyWith(selection: TextSelection(baseOffset: value.length, extentOffset: value.length));
  }

  Widget _buildTitle() {
    return TitleBar(
      isBack: true,
      onTapLeadingIcon: _onPressedBack,
      rightButton: Icons.upload_rounded,
      onTapRightIcon: _onPressSave,
    );
  }

  List<Widget> _buildContent(SpotEditState state) {
    final children = [
      _buildSpotType(state),
      SingleLineField(
        labelText: "名称",
        controller: _nameController,
        textInputType: TextInputType.text,
        textInputAction: TextInputAction.next,
        errorText: state.nameError,
        onChanged: _onChangeName,
      ),
      SingleLineField(
        labelText: "電話番号",
        controller: _phoneController,
        textInputType: TextInputType.phone,
        textInputAction: TextInputAction.next,
        errorText: state.phoneError,
        onChanged: _onChangePhone,
      ),
      SingleLineField(
        labelText: "住所",
        controller: _addressController,
        textInputType: TextInputType.text,
        textInputAction: TextInputAction.next,
        errorText: state.addressError,
        onChanged: _onChangeAddress,
      ),
      _buildUrl(state),
      _buildLocation(state),
      _buildOpenTime(state),
    ];

    return children;
  }

  Widget _buildSpotType(SpotEditState state) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text("種類", style: TextStyleEx.normalStyle(isBold: true)),
        const SizedBox(width: marginS),
        Expanded(
          child: SquareWidgetButton.whiteWidgetButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(state.spotType.assetsIconName, width: 30, height: 30, color: TColors.whiteButtonText),
                const SizedBox(width: marginS),
                Text(state.spotType.label, style: TextStyleEx.normalStyle()),
              ],
            ),
            height: 40,
            onPressed: _onPressedSpotType,
          ),
        ),
      ],
    );
  }

  Widget _buildUrl(SpotEditState state) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          child: SingleLineField(
            labelText: "URL",
            textInputType: TextInputType.url,
            textInputAction: TextInputAction.next,
            errorText: state.urlError,
            onChanged: _onChangeUrl,
          ),
        ),
        const SizedBox(width: marginS),
        SquareIconButton(
          icon: Icons.link_rounded,
          onPressed: _onPressedUrlButton,
        ),
      ],
    );
  }

  Widget _buildLocation(SpotEditState state) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          child: SingleLineField(
            labelText: "緯度・経度",
            textInputType: TextInputType.text,
            textInputAction: TextInputAction.done,
            errorText: state.locationError,
            onChanged: _onChangeLocation,
          ),
        ),
        const SizedBox(width: marginS),
        SquareIconButton(
          icon: Icons.map_rounded,
          onPressed: _onPressedLocationButton,
        ),
      ],
    );
  }

  Widget _buildOpenTime(SpotEditState state) {
    final openTimes = state.openTimes;
    final openItems = <Widget>[];
    for (var i = 0; i < openTimes.length; i++) {
      openItems.add(_buildOpenTimeItem(openTimes[i], i));
    }
    openItems.add(_buildOpenTimeItem(null, -1));

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          height: 40,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("営業時間", style: TextStyleEx.normalStyle(isBold: true)),
          ),
        ),
        const SizedBox(width: marginS),
        Column(
          children: openItems,
        ),
      ],
    );
  }

  Widget _buildOpenTimeItem(OpenTime? openTime, int index) {
    final from = openTime?.from ?? "";
    final to = openTime?.to ?? "";

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SquareWidgetButton.whiteButton(
          from,
          width: 80,
          height: 40,
          onPressed: () {
            _onPressedOpenTimeFrom(from, index);
          },
        ),
        SizedBox(
          width: 30,
          height: 40,
          child: Align(
            alignment: Alignment.center,
            child: Text("〜", style: TextStyleEx.normalStyle()),
          ),
        ),
        SquareWidgetButton.whiteButton(
          to,
          width: 80,
          height: 40,
          onPressed: () {
            _onPressedOpenTimeTo(to, index);
          },
        ),
        if (openTime != null) const SizedBox(width: marginS),
        if (openTime != null)
          SquareIconButton.transparent(
            Icons.remove_circle_outline_rounded,
            onPressed: () {
              _onPressedOpenTimeRemove(index);
            },
          ),
      ],
    );
  }

  void _onPressedBack() {
    Navigator.pop(context);
  }

  void _onPressedSpotType() {
    // TODO 選択ダイアログの表示から
  }

  void _onChangeName(String value) {
    BlocProvider.of<SpotEditBloc>(context).add(SpotEditChangeNameEvent(value: value));
  }

  void _onChangePhone(String value) {
    BlocProvider.of<SpotEditBloc>(context).add(SpotEditChangePhoneEvent(value: value));
  }

  void _onChangeAddress(String value) {
    BlocProvider.of<SpotEditBloc>(context).add(SpotEditChangeAddressEvent(value: value));
  }

  void _onChangeUrl(String value) {
    BlocProvider.of<SpotEditBloc>(context).add(SpotEditChangeUrlEvent(value: value));
  }

  void _onChangeLocation(String value) {
    BlocProvider.of<SpotEditBloc>(context).add(SpotEditChangeLocationEvent(value: value));
  }

  void _onPressedUrlButton() {}

  void _onPressedLocationButton() {}

  void _onPressedOpenTimeFrom(String from, int index) {}

  void _onPressedOpenTimeTo(String to, int index) {}

  void _onPressedOpenTimeRemove(int index) {}

  void _onPressSave() {}
}
