import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trip/domain/firestore/plan.dart';
import 'package:trip/repository/firestore/firestore_client.dart';
import 'package:trip/repository/log/trip_logger.dart';
import 'package:trip/util/global.dart';

///
/// Created by jozuko on 2023/03/01.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class PlanService {
  final _firestoreClient = getIt.get<FirestoreClient>();
  StreamSubscription<QuerySnapshot<Plan>>? _planListener;
  List<Plan> _plans = [];

  void dispose() {
    _firestoreClient.cancelPlanListener(_planListener);
    _planListener = null;
    _plans.clear();
  }

  Future<void> initPlans() async {
    _plans = await _firestoreClient.getPlans();
    _planListener = _firestoreClient.addPlanListener(onAdded: _onAdded, onModified: _onModified, onRemoved: _onRemoved, onError: _onError);
  }

  List<Plan> getPlans() {
    return _plans.map((e) => e.copyWith()).toList();
  }

  void _onAdded(DocumentSnapshot<Plan> planDocSnapshot) {
    final plan = planDocSnapshot.data();
    if (plan == null) {
      return;
    }
    _addOrReplacePlan(plan);
  }

  void _onModified(DocumentSnapshot<Plan> planDocSnapshot) {
    final plan = planDocSnapshot.data();
    if (plan == null) {
      return;
    }
    _addOrReplacePlan(plan);
  }

  void _onRemoved(DocumentSnapshot<Plan> planDocSnapshot) {
    final plan = planDocSnapshot.data();
    if (plan == null) {
      return;
    }

    final index = _plans.indexWhere((element) => element.docId == plan.docId);
    if (index >= 0) {
      _plans.removeAt(index);
    }
  }

  void _onError(error) {
    TripLog.e("PlanListener#onError $error");
  }

  void _addOrReplacePlan(Plan plan) {
    final index = _plans.indexWhere((element) => element.docId == plan.docId);
    if (index < 0) {
      _plans.add(plan);
    } else {
      _plans[index] = plan;
    }
  }
}
