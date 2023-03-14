import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:trip/domain/api_converter.dart';
import 'package:trip/domain/firestore/time.dart';

///
/// Created by jozuko on 2023/03/06.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class Plan extends Equatable {
  final String docId;
  final String name;
  final Time startTime;
  final List<String> spotIds;
  final Time updatedAt;

  const Plan({
    required this.docId,
    required this.name,
    required this.startTime,
    required this.spotIds,
    required this.updatedAt,
  });

  factory Plan.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return Plan(
      docId: snapshot.id,
      name: DataConverter.toNonNullString(data?["name"]),
      startTime: Time.fromFirestore(data?["startTime"]),
      spotIds: DataConverter.toStringList(data?["spotIds"]),
      updatedAt: Time.fromFirestore(data?["updatedAt"]),
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      "name": name,
      "startTime": startTime.toFirestore(),
      "spotIds": spotIds,
      "updatedAt": updatedAt.toFirestore(),
    };
  }

  Plan copyWith({
    String? docId,
    String? name,
    Time? startTime,
    List<String>? spotIds,
    Time? updatedAt,
  }) {
    return Plan(
      docId: docId ?? this.docId,
      name: name ?? this.name,
      startTime: startTime?.copyWith() ?? this.startTime,
      spotIds: spotIds?.map((e) => e).toList() ?? this.spotIds,
      updatedAt: updatedAt?.copyWith() ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        docId,
        name,
        startTime,
        spotIds,
        updatedAt,
      ];

  @override
  String toString() {
    return ''
        'docId: $docId, '
        'name: $name, '
        'startTime: $startTime, '
        'spotIds: $spotIds, '
        'updatedAt: $updatedAt ,';
  }
}
