import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trip/domain/firestore/spot.dart';
import 'package:trip/domain/firestore/user.dart';
import 'package:trip/repository/log/trip_logger.dart';

///
/// Created by jozuko on 2023/03/01.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class FirestoreSpotClient {
  static const _collectionName = 'spots';

  CollectionReference<Spot>? _getCollectionRef(DocumentReference<User>? userDocRef) {
    if (userDocRef == null) {
      return null;
    }

    return userDocRef.collection(_collectionName).withConverter<Spot>(
          fromFirestore: Spot.fromFirestore,
          toFirestore: (Spot spot, _) => spot.toFirestore(),
        );
  }

  Future<List<Spot>> getAll(DocumentReference<User>? userDocRef) async {
    TripLog.d("FirestoreSpotClient#getAll start");
    final collectionRef = _getCollectionRef(userDocRef);
    if (collectionRef == null) {
      return [];
    }

    final spotSnapshot = await collectionRef.get();

    final spots = <Spot>[];
    for (var doc in spotSnapshot.docs) {
      final spot = doc.data();
      spots.add(spot);
    }

    TripLog.d("FirestoreSpotClient#getAll $spots");
    return spots;
  }

  Future<Spot?> save(DocumentReference<User>? userDocRef, Spot spot) async {
    TripLog.d("FirestoreSpotClient#save start");
    final collectionRef = _getCollectionRef(userDocRef);
    if (collectionRef == null) {
      throw "cannot save spot. DocRef is null";
    }

    if (spot.docId.isEmpty) {
      DocumentReference<Spot> spotDocRef = await collectionRef.add(spot);
      final newSpot = await spotDocRef.get();
      return newSpot.data();
    } else {
      await collectionRef.doc(spot.docId).set(spot);
      return spot;
    }
  }

  StreamSubscription<QuerySnapshot<Spot>>? addListener(
    DocumentReference<User>? userDocRef, {
    required void Function(DocumentSnapshot<Spot>) onAdded,
    required void Function(DocumentSnapshot<Spot>) onModified,
    required void Function(DocumentSnapshot<Spot>) onRemoved,
    required Function onError,
  }) {
    TripLog.d("FirestoreSpotClient#addListener");
    return _getCollectionRef(userDocRef)?.snapshots().listen(
      (event) {
        if (!event.metadata.hasPendingWrites) {
          for (var change in event.docChanges) {
            switch (change.type) {
              case DocumentChangeType.added:
                TripLog.d("FirestoreSpotClient#listener added");
                onAdded(change.doc);
                break;
              case DocumentChangeType.modified:
                TripLog.d("FirestoreSpotClient#listener modified");
                onModified(change.doc);
                break;
              case DocumentChangeType.removed:
                TripLog.d("FirestoreSpotClient#listener removed");
                onRemoved(change.doc);
                break;
            }
          }
        }
      },
      onError: onError,
    );
  }

  void cancelListener(StreamSubscription<QuerySnapshot<Spot>>? listener) {
    TripLog.d("FirestoreSpotClient#cancelListener");
    listener?.cancel();
  }
}
