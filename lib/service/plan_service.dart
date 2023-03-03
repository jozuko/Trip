import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trip/repository/firestore/firestore_client.dart';
import 'package:trip/repository/log/trip_logger.dart';
import 'package:trip/util/global.dart';

///
/// Created by jozuko on 2023/03/01.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class PlanService {
  final firestoreClient = getIt.get<FirestoreClient>();

  Future<void> getPlans() async {
    final plansSnapshot = await firestoreClient.getUserPlans();
    if (plansSnapshot == null) {
      return;
    }

    for (var doc in plansSnapshot.docs) {
      TripLog.d("${doc["spot"]}, ${(doc["location"] as GeoPoint).latitude}, ${(doc["location"] as GeoPoint).longitude}");
    }
  }
}
