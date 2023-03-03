import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:trip/util/global.dart';

///
/// Created by jozuko on 2023/02/22.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class User extends Equatable {
  final String id;
  final String nickname;
  final int updatedAt;

  const User({
    required this.id,
    required this.nickname,
    required this.updatedAt,
  });

  factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    final updatedAtTimestamp = data?["updatedAt"];
    final int updatedAt = updatedAtTimestamp != null ? (updatedAtTimestamp as Timestamp).seconds : 0;

    return User(
      id: snapshot.id,
      nickname: data?['nickname'] ?? "",
      updatedAt: updatedAt,
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      "nickname": nickname,
      "updatedAt": FieldValue.serverTimestamp(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        nickname,
        updatedAt,
      ];

  @override
  String toString() {
    var maskedId = '';
    if (isRelease) {
      if (id.length > 8) {
        maskedId = '${id.substring(0, 8)}*******';
      }
    } else {
      maskedId = id;
    }
    return '[id:$maskedId, nickname:$nickname, updatedAt:$updatedAt]';
  }
}
