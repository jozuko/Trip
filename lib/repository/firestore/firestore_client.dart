import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trip/domain/firestore/plan.dart';
import 'package:trip/domain/firestore/spot.dart';
import 'package:trip/domain/firestore/user.dart';
import 'package:trip/repository/log/trip_logger.dart';
import 'package:trip/repository/shared_holder.dart';
import 'package:trip/util/global.dart';

///
/// Created by jozuko on 2023/03/01.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class FirestoreClient {
  final shareHolder = getIt.get<SharedHolder>();
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
    final userDocRef = _getUserDocRef();
    if (userDocRef == null) {
      final user = User.create(_userId);
      await saveUser(user);
      return user;
    }

    final userSnapshot = await userDocRef.get();
    final user = userSnapshot.data();
    if (user == null) {
      final user = User.create(_userId);
      await saveUser(user);
      return user;
    }

    return user;
  }

  Future<void> saveUser(User user) async {
    await getDb()
        .collection("users")
        .doc(user.id)
        .withConverter<User>(
          fromFirestore: User.fromFirestore,
          toFirestore: (User user, _) => user.toFirestore(),
        )
        .set(user);
  }

  StreamSubscription<DocumentSnapshot<User>>? addUserListener({
    required void Function(DocumentSnapshot<User>) onData,
    required Function onError,
  }) {
    return _getUserDocRef()?.snapshots().listen(onData, onError: onError);
  }

  void cancelUserListener(StreamSubscription<DocumentSnapshot<User>>? listener) {
    listener?.cancel();
  }

  Future<List<Plan>> getPlans() async {
    final userDocRef = _getUserDocRef();
    if (userDocRef == null) {
      return [];
    }

    final plansRef = await userDocRef
        .collection('plans')
        .withConverter<Plan>(
          fromFirestore: Plan.fromFirestore,
          toFirestore: (Plan plan, _) => plan.toFirestore(),
        )
        .get();

    final plans = <Plan>[];
    for (var doc in plansRef.docs) {
      final plan = doc.data();
      TripLog.d("Firestore $plan");
    }
    return plans;
  }

  StreamSubscription<QuerySnapshot<Plan>>? addPlanListener({
    required void Function(DocumentSnapshot<Plan>) onAdded,
    required void Function(DocumentSnapshot<Plan>) onModified,
    required void Function(DocumentSnapshot<Plan>) onRemoved,
    required Function onError,
  }) {
    return _getUserDocRef()
        ?.collection('plans')
        .withConverter<Plan>(
          fromFirestore: Plan.fromFirestore,
          toFirestore: (Plan plan, _) => plan.toFirestore(),
        )
        .snapshots()
        .listen(
      (event) {
        if (!event.metadata.hasPendingWrites) {
          for (var change in event.docChanges) {
            switch (change.type) {
              case DocumentChangeType.added:
                onAdded(change.doc);
                break;
              case DocumentChangeType.modified:
                onModified(change.doc);
                break;
              case DocumentChangeType.removed:
                onRemoved(change.doc);
                break;
            }
          }
        }
      },
      onError: onError,
    );
  }

  void cancelPlanListener(StreamSubscription<QuerySnapshot<Plan>>? listener) {
    listener?.cancel();
  }

  Future<Plan?> savePlan(Plan plan) async {
    final userDocRef = _getUserDocRef();
    if (userDocRef == null) {
      throw "cannot create plan. UserDocRef is null";
    }

    final plansRef = userDocRef.collection('plans').withConverter<Plan>(
          fromFirestore: Plan.fromFirestore,
          toFirestore: (Plan plan, _) => plan.toFirestore(),
        );

    if (plan.docId.isEmpty) {
      DocumentReference<Plan> planDocRef = await plansRef.add(plan);
      final newPlan = await planDocRef.get();
      return newPlan.data();
    } else {
      await plansRef.doc(plan.docId).set(plan);
      return plan;
    }
  }

  Future<List<Spot>> getSpots() async {
    final userDocRef = _getUserDocRef();
    if (userDocRef == null) {
      return [];
    }

    final spotsRef = await userDocRef
        .collection('spots')
        .withConverter<Spot>(
          fromFirestore: Spot.fromFirestore,
          toFirestore: (Spot spot, _) => spot.toFirestore(),
        )
        .get();

    final spots = <Spot>[];
    for (var doc in spotsRef.docs) {
      final spot = doc.data();
      TripLog.d("Firestore $spot");
    }
    return spots;
  }

  Future<Spot?> saveSpot(Spot spot) async {
    final userDocRef = _getUserDocRef();
    if (userDocRef == null) {
      throw "cannot create spot. UserDocRef is null";
    }

    final spotsRef = userDocRef.collection('spots').withConverter<Spot>(
          fromFirestore: Spot.fromFirestore,
          toFirestore: (Spot spot, _) => spot.toFirestore(),
        );

    if (spot.docId.isEmpty) {
      DocumentReference<Spot> spotDocRef = await spotsRef.add(spot);
      final newSpot = await spotDocRef.get();
      return newSpot.data();
    } else {
      await spotsRef.doc(spot.docId).set(spot);
      return spot;
    }
  }

  StreamSubscription<QuerySnapshot<Spot>>? addSpotListener({
    required void Function(DocumentSnapshot<Spot>) onAdded,
    required void Function(DocumentSnapshot<Spot>) onModified,
    required void Function(DocumentSnapshot<Spot>) onRemoved,
    required Function onError,
  }) {
    return _getUserDocRef()
        ?.collection('spots')
        .withConverter<Spot>(
          fromFirestore: Spot.fromFirestore,
          toFirestore: (Spot spot, _) => spot.toFirestore(),
        )
        .snapshots()
        .listen(
      (event) {
        if (!event.metadata.hasPendingWrites) {
          for (var change in event.docChanges) {
            switch (change.type) {
              case DocumentChangeType.added:
                onAdded(change.doc);
                break;
              case DocumentChangeType.modified:
                onModified(change.doc);
                break;
              case DocumentChangeType.removed:
                onRemoved(change.doc);
                break;
            }
          }
        }
      },
      onError: onError,
    );
  }

  void cancelSpotListener(StreamSubscription<QuerySnapshot<Spot>>? listener) {
    listener?.cancel();
  }
}
