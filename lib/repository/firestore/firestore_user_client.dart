import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trip/domain/firestore/user.dart';

///
/// Created by jozuko on 2023/03/01.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class FirestoreUserClient {
  Future<User> get(FirebaseFirestore db, DocumentReference<User>? userDocRef, String? userId) async {
    if (userDocRef == null) {
      final user = User.create(userId);
      await save(db, user);
      return user;
    }

    final userSnapshot = await userDocRef.get();
    final user = userSnapshot.data();
    if (user == null) {
      final user = User.create(userId);
      await save(db, user);
      return user;
    }

    return user;
  }

  Future<void> save(FirebaseFirestore db, User user) async {
    await db
        .collection("users")
        .doc(user.id)
        .withConverter<User>(
          fromFirestore: User.fromFirestore,
          toFirestore: (User user, _) => user.toFirestore(),
        )
        .set(user);
  }

  StreamSubscription<DocumentSnapshot<User>>? addListener(
    DocumentReference<User>? userDocRef, {
    required void Function(DocumentSnapshot<User>) onData,
    required Function onError,
  }) {
    return userDocRef?.snapshots().listen(onData, onError: onError);
  }

  void cancelListener(StreamSubscription<DocumentSnapshot<User>>? listener) {
    listener?.cancel();
  }
}
