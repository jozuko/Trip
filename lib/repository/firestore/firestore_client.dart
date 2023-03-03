import 'package:cloud_firestore/cloud_firestore.dart';
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

    // TODO for test testUserDocId => uBKweZxtZyLMijUhbP8z
    _userId = "uBKweZxtZyLMijUhbP8z";
  }

  DocumentReference<User>? _getUserDocRef() {
    if (_db == null) {
      initialize();
    }

    final db = _db;
    final userId = _userId;
    if (db == null || userId == null) {
      return null;
    }

    return db.doc("users/$userId").withConverter<User>(
          fromFirestore: User.fromFirestore,
          toFirestore: (User user, _) => user.toFirestore(),
        );
  }

  Future<QuerySnapshot<Map<String, dynamic>>?> getUserPlans() async {
    final userDocRef = _getUserDocRef();
    if (userDocRef == null) {
      return null;
    }
    final userSnapshot = await userDocRef.get();
    final user = userSnapshot.data();
    TripLog.d("$user");

    // 書き込み
    // if (user != null) {
    //   await userDocRef.set(user);
    // }

    return userDocRef.collection('plans').get();
  }
}
