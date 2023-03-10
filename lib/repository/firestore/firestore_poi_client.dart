import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trip/domain/firestore/poi.dart';
import 'package:trip/domain/firestore/user.dart';
import 'package:trip/repository/log/trip_logger.dart';

///
/// Created by jozuko on 2023/03/01.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class FirestorePoiClient {
  static const _collectionName = 'pois';

  CollectionReference<Poi>? _getCollectionRef(DocumentReference<User>? userDocRef) {
    if (userDocRef == null) {
      return null;
    }

    return userDocRef.collection(_collectionName).withConverter<Poi>(
          fromFirestore: Poi.fromFirestore,
          toFirestore: (Poi poi, _) => poi.toFirestore(),
        );
  }

  Future<List<Poi>> getAll(DocumentReference<User>? userDocRef) async {
    TripLog.d("FirestorePoiClient#getAll start");
    final collectionRef = _getCollectionRef(userDocRef);
    if (collectionRef == null) {
      return [];
    }

    final collectionSnapshot = await collectionRef.get();

    final pois = <Poi>[];
    for (var doc in collectionSnapshot.docs) {
      final poi = doc.data();
      pois.add(poi);
    }

    TripLog.d("FirestorePoiClient#getAll $pois");
    return pois;
  }

  Future<Poi?> save(DocumentReference<User>? userDocRef, Poi poi) async {
    TripLog.d("FirestorePoiClient#save start");
    final collectionRef = _getCollectionRef(userDocRef);
    if (collectionRef == null) {
      throw "cannot save poi. DocRef is null";
    }

    if (poi.docId.isEmpty) {
      DocumentReference<Poi> docRef = await collectionRef.add(poi);
      final newPoi = await docRef.get();
      return newPoi.data();
    } else {
      await collectionRef.doc(poi.docId).set(poi);
      return poi;
    }
  }

  StreamSubscription<QuerySnapshot<Poi>>? addListener(
    DocumentReference<User>? userDocRef, {
    required void Function(DocumentSnapshot<Poi>) onAdded,
    required void Function(DocumentSnapshot<Poi>) onModified,
    required void Function(DocumentSnapshot<Poi>) onRemoved,
    required Function onError,
  }) {
    TripLog.d("FirestorePoiClient#addListener");
    return _getCollectionRef(userDocRef)?.snapshots().listen(
      (event) {
        if (!event.metadata.hasPendingWrites) {
          for (var change in event.docChanges) {
            switch (change.type) {
              case DocumentChangeType.added:
                TripLog.d("FirestorePoiClient#listener added");
                onAdded(change.doc);
                break;
              case DocumentChangeType.modified:
                TripLog.d("FirestorePoiClient#listener modified");
                onModified(change.doc);
                break;
              case DocumentChangeType.removed:
                TripLog.d("FirestorePoiClient#listener removed");
                onRemoved(change.doc);
                break;
            }
          }
        }
      },
      onError: onError,
    );
  }

  void cancelListener(StreamSubscription<QuerySnapshot<Poi>>? listener) {
    TripLog.d("FirestorePoiClient#cancelListener");
    listener?.cancel();
  }
}
