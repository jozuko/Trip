import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:trip/domain/api_converter.dart';
import 'package:trip/domain/firestore/time.dart';
import 'package:trip/util/global.dart';

///
/// Created by jozuko on 2023/02/22.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class User extends Equatable {
  final String id;
  final String nickname;
  final Time updatedAt;

  const User({
    required this.id,
    required this.nickname,
    required this.updatedAt,
  });

  factory User.create(String? id) {
    if (id == null) {
      throw "cannot create user. userId is null";
    }
    return User(id: id, nickname: '', updatedAt: Time.current());
  }

  factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return User(
      id: snapshot.id,
      nickname: DataConverter.toNonNullString(data?['nickname'], ""),
      updatedAt: Time.fromFirestore(data?["updatedAt"]),
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      "nickname": nickname,
      "updatedAt": updatedAt.toFirestore(),
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
