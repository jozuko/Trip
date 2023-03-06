import 'package:equatable/equatable.dart';
import 'package:trip/repository/log/trip_logger.dart';

///
/// Created by jozuko on 2023/03/06.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class OpenTimes extends Equatable {
  final List<OpenTime> openTimes;

  const OpenTimes({
    required this.openTimes,
  });

  factory OpenTimes.fromFirestore(List<dynamic>? dataList) {
    if (dataList == null) {
      return const OpenTimes(openTimes: []);
    }

    var openTimes = <OpenTime>[];
    for (var data in dataList) {
      try {
        openTimes.add(OpenTime.fromFirestore(data));
      } catch (e) {
        TripLog.e('OpenTime $e');
      }
    }

    return OpenTimes(openTimes: openTimes);
  }

  List<Map<String, Object?>> toFirestore() {
    return openTimes.map((e) => e.toFirestore()).toList();
  }

  @override
  List<Object?> get props => [
        openTimes,
      ];

  @override
  String toString() {
    return '[${openTimes.join(",")}]';
  }
}

class OpenTime extends Equatable {
  final String from;
  final String to;

  const OpenTime({
    required this.from,
    required this.to,
  });

  factory OpenTime.fromFirestore(dynamic data) {
    if (data == null) {
      throw "argument is null";
    }
    if (data is! Map) {
      throw "argument is not map";
    }

    var from = data["from"];
    if (from == null || from is! String) {
      throw "from is null or not String";
    }

    var to = data["to"];
    if (to == null || to is! String) {
      throw "to is null or not String";
    }
    return OpenTime(
      from: from,
      to: to,
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      "from": from,
      "to": to,
    };
  }

  @override
  List<Object?> get props => [from, to];

  @override
  String toString() {
    return '$from-$to';
  }
}
