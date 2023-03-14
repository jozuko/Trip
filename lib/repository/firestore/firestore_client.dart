import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trip/domain/firestore/plan.dart';
import 'package:trip/domain/firestore/poi.dart';
import 'package:trip/domain/firestore/spot.dart';
import 'package:trip/domain/firestore/user.dart';
import 'package:trip/repository/firestore/firestore_plan_client.dart';
import 'package:trip/repository/firestore/firestore_poi_client.dart';
import 'package:trip/repository/firestore/firestore_spot_client.dart';
import 'package:trip/repository/firestore/firestore_user_client.dart';
import 'package:trip/repository/shared_holder.dart';
import 'package:trip/util/global.dart';

///
/// Created by jozuko on 2023/03/01.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class FirestoreClient {
  final shareHolder = getIt.get<SharedHolder>();
  final _userClient = FirestoreUserClient();
  final _planClient = FirestorePlanClient();
  final _spotClient = FirestoreSpotClient();
  final _poiClient = FirestorePoiClient();

  FirebaseFirestore? _db;
  String? _userId;

  void initialize() {
    _db = FirebaseFirestore.instance;
    _userId = shareHolder.userId;
  }

  FirebaseFirestore getDb() {
    if (_db == null) {
      initialize();
    }

    return _db!;
  }

  DocumentReference<User>? _getUserDocRef() {
    final db = getDb();
    final userId = _userId;
    if (userId == null) {
      return null;
    }

    return db.doc("users/$userId").withConverter<User>(
          fromFirestore: User.fromFirestore,
          toFirestore: (User user, _) => user.toFirestore(),
        );
  }

  Future<User> getUser() async {
    return await _userClient.get(getDb(), _getUserDocRef(), _userId);
  }

  Future<void> saveUser(User user) async {
    return await _userClient.save(getDb(), user);
  }

  StreamSubscription<DocumentSnapshot<User>>? addUserListener({
    required void Function(DocumentSnapshot<User>) onData,
    required Function onError,
  }) {
    return _userClient.addListener(_getUserDocRef(), onData: onData, onError: onError);
  }

  void cancelUserListener(StreamSubscription<DocumentSnapshot<User>>? listener) {
    _userClient.cancelListener(listener);
  }

  Future<List<Plan>> getPlans() async {
    return await _planClient.getAll(_getUserDocRef());
  }

  Future<Plan?> savePlan(Plan plan) async {
    return await _planClient.save(_getUserDocRef(), plan);
  }

  StreamSubscription<QuerySnapshot<Plan>>? addPlanListener({
    required void Function(DocumentSnapshot<Plan>) onAdded,
    required void Function(DocumentSnapshot<Plan>) onModified,
    required void Function(DocumentSnapshot<Plan>) onRemoved,
    required Function onError,
  }) {
    return _planClient.addListener(_getUserDocRef(), onAdded: onAdded, onModified: onModified, onRemoved: onRemoved, onError: onError);
  }

  void cancelPlanListener(StreamSubscription<QuerySnapshot<Plan>>? listener) {
    _planClient.cancelListener(listener);
  }

  Future<List<Spot>> getSpots() async {
    return await _spotClient.getAll(_getUserDocRef());
  }

  Future<Spot?> saveSpot(Spot spot) async {
    return await _spotClient.save(_getUserDocRef(), spot);
  }

  Future<void> removeSpot(Spot spot) async {
    await _spotClient.remove(_getUserDocRef(), spot);
  }

  StreamSubscription<QuerySnapshot<Spot>>? addSpotListener({
    required void Function(DocumentSnapshot<Spot>) onAdded,
    required void Function(DocumentSnapshot<Spot>) onModified,
    required void Function(DocumentSnapshot<Spot>) onRemoved,
    required Function onError,
  }) {
    return _spotClient.addListener(_getUserDocRef(), onAdded: onAdded, onModified: onModified, onRemoved: onRemoved, onError: onError);
  }

  void cancelSpotListener(StreamSubscription<QuerySnapshot<Spot>>? listener) {
    _spotClient.cancelListener(listener);
  }

  Future<List<Poi>> getPois() async {
    return await _poiClient.getAll(_getUserDocRef());
  }

  Future<Poi?> savePoi(Poi poi) async {
    return await _poiClient.save(_getUserDocRef(), poi);
  }

  StreamSubscription<QuerySnapshot<Poi>>? addPoiListener({
    required void Function(DocumentSnapshot<Poi>) onAdded,
    required void Function(DocumentSnapshot<Poi>) onModified,
    required void Function(DocumentSnapshot<Poi>) onRemoved,
    required Function onError,
  }) {
    return _poiClient.addListener(_getUserDocRef(), onAdded: onAdded, onModified: onModified, onRemoved: onRemoved, onError: onError);
  }

  void cancelPoiListener(StreamSubscription<QuerySnapshot<Poi>>? listener) {
    _poiClient.cancelListener(listener);
  }
}
