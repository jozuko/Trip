import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trip/domain/firestore/spot.dart';
import 'package:trip/repository/firestore/firestore_client.dart';
import 'package:trip/repository/log/trip_logger.dart';
import 'package:trip/util/global.dart';

///
/// Created by jozuko on 2023/03/06.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class SpotService {
  final _firestoreClient = getIt.get<FirestoreClient>();
  StreamSubscription<QuerySnapshot<Spot>>? _spotListener;
  List<Spot> _spots = [];

  void dispose() {
    _firestoreClient.cancelSpotListener(_spotListener);
    _spotListener = null;
    _spots.clear();
  }

  Future<void> initSpots() async {
    _spots = await _firestoreClient.getSpots();
    _spotListener = _firestoreClient.addSpotListener(onAdded: _onAdded, onModified: _onModified, onRemoved: _onRemoved, onError: _onError);
  }

  List<Spot> getSpot() {
    return _spots.map((e) => e.copyWith()).toList();
  }

  Future<void> save(Spot spot) async {
    try {
      final newSpot = await _firestoreClient.saveSpot(spot);
      if (newSpot != null) {
        _addOrReplaceSpotCache(newSpot);
      }
    } catch (e) {
      TripLog.e("SpotService#save $e");
    }
  }

  Future<void> remove(Spot spot) async {
    try {
      await _firestoreClient.removeSpot(spot);
      _removeSpotCache(spot);
    } catch (e) {
      TripLog.e("SpotService#save $e");
    }
  }

  void _onAdded(DocumentSnapshot<Spot> spotSnapshot) {
    final spot = spotSnapshot.data();
    if (spot == null) {
      return;
    }
    _addOrReplaceSpotCache(spot);
  }

  void _onModified(DocumentSnapshot<Spot> spotSnapshot) {
    final spot = spotSnapshot.data();
    if (spot == null) {
      return;
    }
    _addOrReplaceSpotCache(spot);
  }

  void _onRemoved(DocumentSnapshot<Spot> spotSnapshot) {
    final spot = spotSnapshot.data();
    if (spot == null) {
      return;
    }
    _removeSpotCache(spot);
  }

  void _onError(error) {
    TripLog.e("PlanListener#onError $error");
  }

  void _addOrReplaceSpotCache(Spot spot) {
    final index = _spots.indexWhere((element) => element.docId == spot.docId);
    TripLog.d("SpotService#_addOrReplaceSpotCache ${spot.docId}, $index");
    if (index < 0) {
      _spots.add(spot);
    } else {
      _spots[index] = spot;
    }
  }

  void _removeSpotCache(Spot spot) {
    final index = _spots.indexWhere((element) => element.docId == spot.docId);
    TripLog.d("SpotService#_removeSpotCache ${spot.docId}, $index");
    if (index >= 0) {
      _spots.removeAt(index);
    }
  }
}
