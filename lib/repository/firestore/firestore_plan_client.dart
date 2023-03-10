import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trip/domain/firestore/plan.dart';
import 'package:trip/domain/firestore/user.dart';
import 'package:trip/repository/log/trip_logger.dart';

///
/// Created by jozuko on 2023/03/01.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class FirestorePlanClient {
  static const _collectionName = 'plans';

  CollectionReference<Plan>? _getCollectionRef(DocumentReference<User>? userDocRef) {
    if (userDocRef == null) {
      return null;
    }

    return userDocRef.collection(_collectionName).withConverter<Plan>(
          fromFirestore: Plan.fromFirestore,
          toFirestore: (Plan plan, _) => plan.toFirestore(),
        );
  }

  Future<List<Plan>> getAll(DocumentReference<User>? userDocRef) async {
    TripLog.d("FirestorePlanClient#getAll start");
    final collectionRef = _getCollectionRef(userDocRef);
    if (collectionRef == null) {
      return [];
    }

    final collectionSnapshot = await collectionRef.get();

    final plans = <Plan>[];
    for (var doc in collectionSnapshot.docs) {
      final plan = doc.data();
      plans.add(plan);
    }

    TripLog.d("FirestorePlanClient#getAll $plans");
    return plans;
  }

  Future<Plan?> save(DocumentReference<User>? userDocRef, Plan plan) async {
    TripLog.d("FirestorePlanClient#save start");
    final collectionRef = _getCollectionRef(userDocRef);
    if (collectionRef == null) {
      throw "cannot save plan. DocRef is null";
    }

    if (plan.docId.isEmpty) {
      DocumentReference<Plan> planDocRef = await collectionRef.add(plan);
      final newPlan = await planDocRef.get();
      return newPlan.data();
    } else {
      await collectionRef.doc(plan.docId).set(plan);
      return plan;
    }
  }

  StreamSubscription<QuerySnapshot<Plan>>? addListener(
    DocumentReference<User>? userDocRef, {
    required void Function(DocumentSnapshot<Plan>) onAdded,
    required void Function(DocumentSnapshot<Plan>) onModified,
    required void Function(DocumentSnapshot<Plan>) onRemoved,
    required Function onError,
  }) {
    TripLog.d("FirestorePlanClient#addListener");
    return _getCollectionRef(userDocRef)?.snapshots().listen(
      (event) {
        if (!event.metadata.hasPendingWrites) {
          for (var change in event.docChanges) {
            switch (change.type) {
              case DocumentChangeType.added:
                TripLog.d("FirestorePlanClient#listener added");
                onAdded(change.doc);
                break;
              case DocumentChangeType.modified:
                TripLog.d("FirestorePlanClient#listener modified");
                onModified(change.doc);
                break;
              case DocumentChangeType.removed:
                TripLog.d("FirestorePlanClient#listener removed");
                onRemoved(change.doc);
                break;
            }
          }
        }
      },
      onError: onError,
    );
  }

  void cancelListener(StreamSubscription<QuerySnapshot<Plan>>? listener) {
    TripLog.d("FirestorePlanClient#addListener");
    listener?.cancel();
  }
}
