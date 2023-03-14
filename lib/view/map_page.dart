import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trip/domain/firestore/location.dart';
import 'package:trip/domain/map_pin_type.dart';
import 'package:trip/view/base_state.dart';
import 'package:trip/view/map_bloc.dart';
import 'package:trip/widget/title_bar.dart';

///
/// Created by jozuko on 2023/03/09.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class MapPage extends StatefulWidget {
  static Route<Location?> routePage({
    Key? key,
    Location? location,
    required MapPinType mapPinType,
    required bool isEditable,
  }) {
    Location? initPos = location;
    if (initPos == null || initPos.isInvalid) {
      initPos = Location.def;
    }

    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => MapBloc(initPos, mapPinType, isEditable),
        child: MapPage(key: key),
      ),
    );
  }

  const MapPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MapState();
  }
}

class _MapState extends BaseState<MapPage> {
  final _pinWidth = 45.0;
  final _pinHeight = 60.0;
  final GlobalKey _mapWidgetKey = GlobalKey();

  bool isCompletedDraw = false;
  late GoogleMapController _mapController;
  LatLng _pinLatLng = const LatLng(0, 0);
  Offset? _pinTopLeftPos;

  double get _devicePixelRatio => Platform.isAndroid ? MediaQuery.of(context).devicePixelRatio : 1.0;

  @override
  void initState() {
    super.initState();
    _pinLatLng = BlocProvider.of<MapBloc>(context).state.source.latLng;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        return buildRootPage(
          child: Column(
            children: [
              _buildTitle(),
              Expanded(
                child: Stack(
                  children: [
                    _buildMap(state),
                    _buildPin(state),
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

  Widget _buildMap(MapState state) {
    return FutureBuilder(
      future: _generateMarkers(state),
      initialData: const <Marker>{},
      builder: (context, snapshot) => GoogleMap(
        key: _mapWidgetKey,
        markers: snapshot.data ?? const <Marker>{},
        onMapCreated: _onMapCreated,
        onCameraIdle: _onCameraIdle,
        onCameraMove: _onCameraMove,
        onTap: _onTapMap,
        initialCameraPosition: CameraPosition(
          target: _pinLatLng,
          zoom: 18.0,
        ),
      ),
    );
  }

  Future<Set<Marker>> _generateMarkers(MapState state) async {
    final markers = <Marker>{};
    if (!state.isEditable) {
      // BitmapDescriptor.fromAssetImageはサイズがおかしいので自力で作成する
      ByteData data = await rootBundle.load(state.mapPinType.assetsPinName);
      ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: (_pinWidth * _devicePixelRatio).toInt(), targetHeight: (_pinHeight * _devicePixelRatio).toInt());
      ui.FrameInfo fi = await codec.getNextFrame();
      final Uint8List? markerIcon = (await fi.image.toByteData(format: ui.ImageByteFormat.png))?.buffer.asUint8List();
      if (markerIcon != null) {
        markers.add(Marker(
          markerId: MarkerId(state.source.label),
          icon: BitmapDescriptor.fromBytes(markerIcon),
          position: state.source.latLng,
        ));
      }
    }

    return markers;
  }

  Widget _buildPin(MapState state) {
    if (!state.isEditable) {
      return Container();
    }

    final pinImage = Image.asset(
      state.mapPinType.assetsPinName,
      width: _pinWidth,
      height: _pinHeight,
    );

    return Visibility(
      visible: _pinTopLeftPos != null,
      child: Positioned(
        left: _pinTopLeftPos?.dx ?? 0,
        top: _pinTopLeftPos?.dy ?? 0,
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
    Navigator.pop(context, Location(latitude: _pinLatLng.latitude, longitude: _pinLatLng.longitude));
  }

  void _onCameraIdle() {
    _updatePinPosition(_pinLatLng);
  }

  void _onCameraMove(CameraPosition position) {
    _updatePinPosition(_pinLatLng);
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_pinTopLeftPos == null) {
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
      _pinTopLeftPos = _getPinTopLeft(offset);
    });
  }

  Future<void> _updatePinFromOffset(Offset pinTopLeft) async {
    final latLng = await _getPinLatLng(pinTopLeft);
    setState(() {
      _pinLatLng = latLng;
      _pinTopLeftPos = pinTopLeft;
    });
  }

  Future<LatLng> _getPinLatLng(Offset pinTopLeft) async {
    final screenCoordinate = _getScreenCoordinateFromOffset(_getPinTip(pinTopLeft));
    return await _mapController.getLatLng(screenCoordinate);
  }

  Offset _getPinTip(Offset pinTopLeft) {
    return Offset(pinTopLeft.dx + (_pinWidth / 2), pinTopLeft.dy + _pinHeight);
  }

  Offset _getPinTopLeft(Offset pinTip) {
    return Offset(pinTip.dx - (_pinWidth / 2), pinTip.dy - _pinHeight);
  }

  Future<bool> _isCompletedDrawMap() async {
    final zeroLatLng = await _mapController.getLatLng(const ScreenCoordinate(x: 0, y: 0));
    if (zeroLatLng.latitude == 0.0 && zeroLatLng.longitude == 0.0) {
      return false;
    }
    return true;
  }

  Offset _getOffsetFromScreenCoordinate(ScreenCoordinate coordinate) {
    return Offset(
      coordinate.x / _devicePixelRatio,
      coordinate.y / _devicePixelRatio,
    );
  }

  ScreenCoordinate _getScreenCoordinateFromOffset(Offset offset) {
    return ScreenCoordinate(
      x: (offset.dx * _devicePixelRatio).toInt(),
      y: (offset.dy * _devicePixelRatio).toInt(),
    );
  }

  Rect get _mapWidgetRect {
    final RenderBox renderBox = _mapWidgetKey.currentContext?.findRenderObject() as RenderBox;

    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    return Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
  }
}
