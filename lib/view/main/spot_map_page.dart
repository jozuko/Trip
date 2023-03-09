import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trip/domain/location_data.dart';
import 'package:trip/domain/spot_type.dart';
import 'package:trip/view/base_state.dart';
import 'package:trip/view/main/spot_map_bloc.dart';
import 'package:trip/widget/title_bar.dart';

///
/// Created by jozuko on 2023/03/09.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class SpotMapPage extends StatefulWidget {
  static Route<LocationData?> routePage({Key? key, LocationData? locationData, required SpotType spotType}) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => SpotMapBloc(locationData, spotType),
        child: SpotMapPage(key: key),
      ),
    );
  }

  const SpotMapPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SpotMapState();
  }
}

class _SpotMapState extends BaseState<SpotMapPage> {
  final _pinWidth = 45.0;
  final _pinHeight = 60.0;
  final GlobalKey _mapWidgetKey = GlobalKey();

  bool isCompletedDraw = false;
  late GoogleMapController _mapController;
  LatLng _pinLatLng = const LatLng(0, 0);
  Offset? _pinPos;

  SpotMapState get blocState => BlocProvider.of<SpotMapBloc>(context).state;

  @override
  void initState() {
    super.initState();
    _pinLatLng = blocState.source.location.latLng;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotMapBloc, SpotMapState>(
      builder: (context, state) {
        return buildRootPage(
          child: Column(
            children: [
              _buildTitle(),
              Expanded(
                child: Stack(
                  children: [
                    _buildMap(),
                    _buildPin(),
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
      onTapLeadingIcon: _onPressedBack,
      rightButton: Icons.done_rounded,
      onTapRightIcon: _onPressedDone,
    );
  }

  Widget _buildMap() {
    return GoogleMap(
      key: _mapWidgetKey,
      onMapCreated: _onMapCreated,
      onCameraIdle: _onCameraIdle,
      onCameraMove: _onCameraMove,
      onTap: _onTapMap,
      initialCameraPosition: CameraPosition(
        target: _pinLatLng,
        zoom: 11.0,
      ),
    );
  }

  Widget _buildPin() {
    final pinImage = Image.asset(
      blocState.spotType.assetsPinName,
      width: _pinWidth,
      height: _pinHeight,
    );

    return Visibility(
      visible: _pinPos != null,
      child: Positioned(
        left: _pinPos?.dx ?? 0,
        top: _pinPos?.dy ?? 0,
        child: Draggable(
          feedback: pinImage,
          childWhenDragging: Container(),
          onDraggableCanceled: _onDraggedPin,
          child: pinImage,
        ),
      ),
    );
  }

  void _onPressedBack() {
    Navigator.pop(context, null);
  }

  void _onPressedDone() {
    // TODO location
    Navigator.pop(context, null);
  }

  void _onCameraIdle() {
    _updatePinPosition(_pinLatLng);
  }

  void _onCameraMove(CameraPosition position) {
    _updatePinPosition(_pinLatLng);
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_pinPos == null) {
      _updatePinPosition(_pinLatLng);
    }
  }

  void _onTapMap(LatLng latLng) {
    _updatePinPosition(latLng);
  }

  void _onDraggedPin(Velocity velocity, Offset offset) {
    final mapWidgetRect = _mapWidgetRect;
    final left = offset.dx - mapWidgetRect.left;
    final top = offset.dy - mapWidgetRect.top;

    _updatePinFromOffset(Offset(left, top));
  }

  Future<void> _updatePinPosition(LatLng latLng) async {
    // Widgetの描画完了チェック
    if (!isCompletedDraw) {
      isCompletedDraw = await _isCompletedDrawMap();
      if (!isCompletedDraw) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _updatePinPosition(latLng);
        });
        return;
      }
    }

    final screenCoordinate = await _mapController.getScreenCoordinate(latLng);
    final offset = _getOffsetFromScreenCoordinate(screenCoordinate);
    setState(() {
      _pinLatLng = latLng;
      _pinPos = Offset(offset.dx - (_pinWidth / 2), offset.dy - _pinHeight);
    });
  }

  Future<void> _updatePinFromOffset(Offset offset) async {
    final screenCoordinate = _getScreenCoordinateFromOffset(offset);
    final latLng = await _mapController.getLatLng(screenCoordinate);
    setState(() {
      _pinLatLng = latLng;
      _pinPos = offset;
    });
  }

  Future<bool> _isCompletedDrawMap() async {
    final zeroLatLng = await _mapController.getLatLng(const ScreenCoordinate(x: 0, y: 0));
    if (zeroLatLng.latitude == 0.0 && zeroLatLng.longitude == 0.0) {
      return false;
    }
    return true;
  }

  Offset _getOffsetFromScreenCoordinate(ScreenCoordinate coordinate) {
    final devicePixelRatio = Platform.isAndroid ? MediaQuery.of(context).devicePixelRatio : 1.0;
    return Offset(
      coordinate.x / devicePixelRatio,
      coordinate.y / devicePixelRatio,
    );
  }

  ScreenCoordinate _getScreenCoordinateFromOffset(Offset offset) {
    final devicePixelRatio = Platform.isAndroid ? MediaQuery.of(context).devicePixelRatio : 1.0;

    return ScreenCoordinate(
      x: (offset.dx * devicePixelRatio).toInt(),
      y: (offset.dy * devicePixelRatio).toInt(),
    );
  }

  Rect get _mapWidgetRect {
    final RenderBox renderBox = _mapWidgetKey.currentContext?.findRenderObject() as RenderBox;

    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    return Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
  }
}
