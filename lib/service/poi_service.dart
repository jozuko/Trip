import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:trip/domain/firestore/poi.dart';
import 'package:trip/domain/shared_poi.dart';
import 'package:trip/repository/firestore/firestore_client.dart';
import 'package:trip/repository/log/trip_logger.dart';
import 'package:trip/repository/shared_holder.dart';
import 'package:trip/service/auth_service.dart';
import 'package:trip/util/global.dart';

///
/// Created by jozuko on 2023/03/10.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class PoiService {
  final _authService = getIt.get<AuthService>();
  final _firestoreClient = getIt.get<FirestoreClient>();
  final _sharedHolder = getIt.get<SharedHolder>();
  StreamSubscription<QuerySnapshot<Poi>>? _poiListener;
  List<Poi> _pois = [];

  void dispose() {
    _firestoreClient.cancelPoiListener(_poiListener);
    _poiListener = null;
    _pois.clear();
  }

  Future<void> initPois() async {
    _pois = await _firestoreClient.getPois();
    _poiListener = _firestoreClient.addPoiListener(onAdded: _onAdded, onModified: _onModified, onRemoved: _onRemoved, onError: _onError);
    await syncData();
  }

  List<Poi> getPois() {
    return _pois;
  }

  void _onAdded(DocumentSnapshot<Poi> poiDocSnapshot) {
    final poi = poiDocSnapshot.data();
    if (poi == null) {
      return;
    }
    _addOrReplacePoi(poi);
  }

  void _onModified(DocumentSnapshot<Poi> poiDocSnapshot) {
    final poi = poiDocSnapshot.data();
    if (poi == null) {
      return;
    }
    _addOrReplacePoi(poi);
  }

  void _onRemoved(DocumentSnapshot<Poi> poiDocSnapshot) {
    final poi = poiDocSnapshot.data();
    if (poi == null) {
      return;
    }

    final index = _pois.indexWhere((element) => element.docId == poi.docId);
    if (index >= 0) {
      _pois.removeAt(index);
    }
  }

  void _onError(error) {
    TripLog.e("PoiListener#onError $error");
  }

  void _addOrReplacePoi(Poi poi) {
    final index = _pois.indexWhere((element) => element.docId == poi.docId);
    if (index < 0) {
      _pois.add(poi);
    } else {
      _pois[index] = poi;
    }
  }

  Future<void> save(SharedPoi sharedPoi) async {
    final poi = Poi.fromSharedPoi(sharedPoi);
    if (_authService.isInitialized) {
      if (_authService.user != null) {
        await _saveFireStore(poi);
        return;
      }
    }

    _saveSharedHolder(poi);
  }

  Future<void> _saveFireStore(Poi poi) async {
    await _firestoreClient.savePoi(poi);
    _addOrReplacePoi(poi);
  }

  void _saveSharedHolder(Poi poi) {
    final tempPoisJson = _sharedHolder.tempPois;
    List<Poi> tempPois = Poi.fromJson(tempPoisJson);

    final index = tempPois.indexWhere((element) => element.docId == poi.docId);
    if (index < 0) {
      tempPois.add(poi);
    } else {
      tempPois[index] = poi;
    }

    List<Map<String, dynamic>> jsonMap = tempPois.map((e) => e.toMap()).toList();
    _sharedHolder.tempPois = jsonEncode(jsonMap);
  }

  Future<void> syncData() async {
    List<Poi> tempPois = Poi.fromJson(_sharedHolder.tempPois);
    if (tempPois.isEmpty) {
      return;
    }

    final updateList = <Poi>[];
    for (var tempPoi in tempPois) {
      final serverPoi = _pois.firstWhereOrNull((poi) => poi.docId == tempPoi.docId);
      if (serverPoi == null) {
        updateList.add(tempPoi);
      } else {
        final serverSec = serverPoi.updatedAt.seconds ?? 0;
        final tempSec = tempPoi.updatedAt.seconds ?? 0;
        if (serverSec < tempSec) {
          updateList.add(tempPoi);
        }
      }
    }

    if (updateList.isEmpty) {
      _sharedHolder.tempPois = "";
      return;
    }

    for (var poi in updateList) {
      await _firestoreClient.savePoi(poi);
    }

    _sharedHolder.tempPois = "";
  }
}
