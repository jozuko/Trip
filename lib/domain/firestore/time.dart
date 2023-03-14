import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

///
/// Created by jozuko on 2023/03/06.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class Time extends Equatable {
  final int? seconds;

  const Time({
    required this.seconds,
  });

  factory Time.current() {
    return Time(seconds: (DateTime.now().millisecondsSinceEpoch ~/ 1000).toInt());
  }

  factory Time.fromFirestore(dynamic data) {
    if (data == null) {
      return const Time(seconds: null);
    }
    if (data is! Timestamp) {
      return const Time(seconds: null);
    }
    return Time(seconds: data.seconds);
  }

  dynamic toFirestore() {
    return FieldValue.serverTimestamp();
  }

  Time copyWith({int? seconds}) {
    return Time(
      seconds: seconds ?? this.seconds,
    );
  }

  @override
  List<Object?> get props => [seconds ?? -1];
}
