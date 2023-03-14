import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trip/domain/firestore/location.dart';
import 'package:trip/domain/firestore/user.dart';
import 'package:trip/repository/firestore/firestore_client.dart';
import 'package:trip/repository/log/trip_logger.dart';
import 'package:trip/util/global.dart';

///
/// Created by jozuko on 2023/03/06.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class UserService {
  final _firestoreClient = getIt.get<FirestoreClient>();
  StreamSubscription<DocumentSnapshot<User>>? _userListener;
  User? _user;

  void dispose() {
    _firestoreClient.cancelUserListener(_userListener);
    _userListener = null;
    _user = null;
  }

  Future<void> initUser() async {
    _user = await _firestoreClient.getUser();
    _userListener = _firestoreClient.addUserListener(
      onData: (event) {
        if (event.metadata.hasPendingWrites) {
          TripLog.d("UserListener local data updated");
        } else {
          TripLog.d("UserListener server data updated");
          _user = event.data();
        }
      },
      onError: (error) {
        TripLog.e("UserListener $error");
      },
    );
  }

  User? getUser() {
    return _user?.copyWith();
  }

  Future<User> updateHomePos(Location location) async {
    User? user = _user;
    if (user == null) {
      throw "updateHomePos user is null.";
    }
    if (location.isInvalid) {
      return user;
    }

    user = user.copyWith(homePos: location);
    _user = user;
    await _firestoreClient.saveUser(user);
    return user;
  }
}
