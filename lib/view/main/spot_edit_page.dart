import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip/domain/bookmark.dart';
import 'package:trip/domain/firestore/location.dart';
import 'package:trip/domain/firestore/poi.dart';
import 'package:trip/domain/firestore/spot.dart';
import 'package:trip/domain/map_pin_type.dart';
import 'package:trip/domain/spot_type.dart';
import 'package:trip/util/colors.dart';
import 'package:trip/util/global.dart';
import 'package:trip/util/text_style_ex.dart';
import 'package:trip/view/base_state.dart';
import 'package:trip/view/main/poi_list_page.dart';
import 'package:trip/view/main/spot_edit_bloc.dart';
import 'package:trip/view/map_page.dart';
import 'package:trip/widget/button/square_icon_button.dart';
import 'package:trip/widget/button/square_text_button.dart';
import 'package:trip/widget/dialog/animation_dialog.dart';
import 'package:trip/widget/dialog/select_bookmark_dialog.dart';
import 'package:trip/widget/dialog/select_dialog.dart';
import 'package:trip/widget/field/multi_line_field.dart';
import 'package:trip/widget/field/single_line_field.dart';
import 'package:trip/widget/loading.dart';
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
  final _stayTimeController = TextEditingController();
  final _memoController = TextEditingController();

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
    _stayTimeController.dispose();
    _memoController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpotEditBloc, SpotEditState>(
      listener: (context, state) {
        if (state.isDone) {
          _showDoneMessage();
        }
      },
      builder: (context, state) {
        if (!state.initialized) {
          _setTextInitValue(_nameController, state.name);
          _setTextInitValue(_phoneController, state.phone);
          _setTextInitValue(_addressController, state.address);
          _setTextInitValue(_urlController, state.url);
          _setTextInitValue(_locationController, state.location);
          _setTextInitValue(_stayTimeController, state.stayTime.toString());
          _setTextInitValue(_memoController, state.memo);
        }

        return WillPopScope(
          onWillPop: () async {
            _onPressedBack();
            return false;
          },
          child: buildRootPage(
            child: Stack(
              children: [
                Column(
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
                LoadingWidget(visible: state.isLoading),
              ],
            ),
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
      _buildImportButton(state),
      const SizedBox(height: marginS),
      _buildSpotType(state),
      SingleLineField(
        labelText: "名称",
        controller: _nameController,
        textInputType: TextInputType.text,
        textInputAction: TextInputAction.next,
        showClear: _nameController.text.isNotEmpty,
        onChanged: _onChangeName,
      ),
      SingleLineField(
        labelText: "電話番号",
        controller: _phoneController,
        textInputType: TextInputType.phone,
        textInputAction: TextInputAction.next,
        showClear: _phoneController.text.isNotEmpty,
        onChanged: _onChangePhone,
      ),
      SingleLineField(
        labelText: "住所",
        controller: _addressController,
        textInputType: TextInputType.text,
        textInputAction: TextInputAction.next,
        showClear: _addressController.text.isNotEmpty,
        onChanged: _onChangeAddress,
      ),
      _buildUrl(state),
      _buildLocation(state),
      SingleLineField(
        labelText: "滞在時間",
        controller: _stayTimeController,
        textInputType: TextInputType.number,
        textInputAction: TextInputAction.next,
        showClear: _stayTimeController.text.isNotEmpty,
        onChanged: _onChangeStayTime,
      ),
      MultiLineField(
        hintText: "メモ",
        controller: _memoController,
        onChanged: _onChangeMemo,
      ),
    ];

    return children;
  }

  Widget _buildImportButton(SpotEditState state) {
    return SquareWidgetButton.whiteWidgetButton(
      onPressed: () {
        _onPressedImportButton(state);
      },
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.download_rounded,
              color: TColors.blackText,
            ),
            Text(
              'POIからインポート',
              style: TextStyleEx.normalStyle(isBold: true),
            ),
          ],
        ),
      ),
    );
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
            controller: _urlController,
            labelText: "URL",
            textInputType: TextInputType.url,
            textInputAction: TextInputAction.next,
            showClear: _urlController.text.isNotEmpty,
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
            controller: _locationController,
            labelText: "緯度・経度",
            textInputType: TextInputType.text,
            textInputAction: TextInputAction.next,
            showClear: _locationController.text.isNotEmpty,
            onChanged: _onChangeLocation,
          ),
        ),
        const SizedBox(width: marginS),
        SquareIconButton(
          icon: Icons.map_rounded,
          onPressed: () {
            _onPressedLocationButton(state);
          },
        ),
      ],
    );
  }

  Future<void> _onPressedBack() async {
    if (BlocProvider.of<SpotEditBloc>(context).hasDiff) {
      await showConfirm(
          message: '変更を保存しますか？',
          okLabel: '保存する',
          cancelLabel: '保存しない',
          callback: (canceled) {
            if (canceled) {
              Navigator.pop(context);
            } else {
              _onPressSave();
            }
          });
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _onPressedSpotType() async {
    showAnimatedDialog<SpotType?>(
      context: context,
      builder: (_) {
        return SelectDialog(
          items: SpotType.values.map((spotType) => SelectDialogItem(value: spotType, label: spotType.label)).toList(),
          onCanceled: () {
            Navigator.of(context).pop(null);
          },
          onSelected: (value) {
            Navigator.of(context).pop(value);
          },
        );
      },
    ).then((value) {
      if (value == null) {
        return;
      }
      BlocProvider.of<SpotEditBloc>(context).add(SpotEditChangeSpotTypeEvent(value));
    });
  }

  void _onChangeName(String value) {
    BlocProvider.of<SpotEditBloc>(context).add(SpotEditChangeNameEvent(value));
  }

  void _onChangePhone(String value) {
    BlocProvider.of<SpotEditBloc>(context).add(SpotEditChangePhoneEvent(value));
  }

  void _onChangeAddress(String value) {
    BlocProvider.of<SpotEditBloc>(context).add(SpotEditChangeAddressEvent(value));
  }

  void _onChangeUrl(String value) {
    BlocProvider.of<SpotEditBloc>(context).add(SpotEditChangeUrlEvent(value));
  }

  void _onChangeLocation(String value) {
    BlocProvider.of<SpotEditBloc>(context).add(SpotEditChangeLocationEvent(value));
  }

  void _onChangeStayTime(String value) {
    final stayTime = int.tryParse(value);
    if (stayTime != null) {
      BlocProvider.of<SpotEditBloc>(context).add(SpotEditChangeStayTimeEvent(value: stayTime));
    }
  }

  void _onChangeMemo(String value) {
    BlocProvider.of<SpotEditBloc>(context).add(SpotEditChangeMemoEvent(value));
  }

  Future<void> _onPressedUrlButton() async {
    showAnimatedDialog<Bookmark?>(
      context: context,
      builder: (_) {
        return SelectBookmarkDialog(
          items: BlocProvider.of<SpotEditBloc>(context).getBookmarks(),
          onCanceled: () {
            Navigator.of(context).pop(null);
          },
          onSelected: (value) {
            Navigator.of(context).pop(value);
          },
        );
      },
    ).then((value) {
      if (value == null) {
        return;
      }

      BlocProvider.of<SpotEditBloc>(context).add(SpotEditChangeUrlEvent(value.url));
      setState(() {
        _setTextInitValue(_urlController, value.url);
      });
    });
  }

  void _onPressedLocationButton(SpotEditState state) {
    Navigator.of(context)
        .push(MapPage.routePage(
      location: Location.fromString(state.location),
      mapPinType: MapPinTypeEx.fromSpotType(state.spotType),
      isEditable: true,
    ))
        .then((Location? value) {
      if (value == null || state.location == value.label) {
        return;
      }
      BlocProvider.of<SpotEditBloc>(context).add(SpotEditChangeLocationEvent(value.label));
      setState(() {
        _setTextInitValue(_locationController, value.label);
      });
    });
  }

  void _onPressedImportButton(SpotEditState state) {
    Navigator.push<Poi?>(
      context,
      PoiListPage.routePage(),
    ).then((value) {
      if (value == null) {
        return;
      }

      String? name;
      if (value.title != state.name) {
        name = value.title;
      }
      String? phone;
      if (value.phoneNumber != state.phone) {
        phone = value.phoneNumber;
      }
      String? address;
      if (value.address != state.address) {
        address = value.address;
      }
      String? url;
      if (value.url != state.url) {
        url = value.url;
      }
      String? location;
      if (value.location.label != state.location) {
        location = value.location.label;
      }
      String? memo;
      if (value.memo != state.memo) {
        memo = value.memo;
      }

      BlocProvider.of<SpotEditBloc>(context).add(SpotEditSetPoiEvent(value));
      setState(() {
        if (name != null) {
          _setTextInitValue(_nameController, name);
        }
        if (phone != null) {
          _setTextInitValue(_phoneController, phone);
        }
        if (address != null) {
          _setTextInitValue(_addressController, address);
        }
        if (url != null) {
          _setTextInitValue(_urlController, url);
        }
        if (location != null) {
          _setTextInitValue(_locationController, location);
        }
        if (memo != null) {
          _setTextInitValue(_memoController, memo);
        }
      });
    });
  }

  void _onPressSave() {
    BlocProvider.of<SpotEditBloc>(context).add(SpotEditSaveEvent());
  }

  void _showDoneMessage() {
    showMessage('保存しました。', callback: () {
      Navigator.pop(context);
    });
  }
}
